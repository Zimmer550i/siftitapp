import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sarkasm/models/user_model.dart';
import 'package:sarkasm/utils/custom_snackbar.dart';
import 'package:sarkasm/views/screens/auth/login.dart';
import 'package:sarkasm/views/screens/auth/verification.dart';
import 'package:sarkasm/views/screens/onboarding/onboarding.dart';
import 'package:sarkasm/views/screens/scanning/camera_permission.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleInit;

  AuthController({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _storage = storage ?? FirebaseStorage.instance;

  String loadingType = "";
  RxBool isLoading = RxBool(false);
  bool isSendingVerification = false;
  final Rxn<UserModel> userModel = Rxn<UserModel>();
  UserModel? get getUser => userModel.value;
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  bool get isUserLoggedIn => _auth.currentUser != null;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  @override
  void onInit() {
    super.onInit();
    _googleInit = _googleSignIn.initialize();
  }

  Future<void> checkAuthStatus() async {
    final user = _auth.currentUser;

    if (user == null) {
      Get.offAll(() => const Onboarding());
      return;
    } else {
      userModel.value = await getUserInfo(uid: user.uid);
    }

    // If user exists but email is not verified
    if (!user.emailVerified) {
      await user.reload();
      if (!(_auth.currentUser?.emailVerified ?? false)) {
        Get.offAll(() => Verification(email: user.email ?? ''));
        return;
      }
    }

    // User is authenticated and verified
    _openApp();
  }

  Future<void> _ensureGoogleSignInReady() async {
    _googleInit ??= _googleSignIn.initialize();
    await _googleInit;
  }

  Future<void> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (!_validateNameEmailPassword(name, email, password)) return;
    if (password != confirmPassword) {
      customSnackBar('Passwords do not match');
      return;
    }

    await _runAuthAction(() async {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      await credential.user?.updateDisplayName(name.trim());

      // Save user to Firestore
      if (credential.user != null) {
        await _saveUserToFirestore(
          uid: credential.user!.uid,
          name: name.trim(),
          email: email.trim(),
        );
        userModel.value = await getUserInfo(uid: credential.user!.uid);
      }

      await credential.user?.sendEmailVerification();
      customSnackBar(
        'Verification link sent. Please check your email.',
        isError: false,
      );
      Get.to(() => Verification(email: email.trim()));
    });
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (!_validateEmailPassword(email, password)) return;

    await _runAuthAction(() async {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) return;

      await user.reload();
      if (!(_auth.currentUser?.emailVerified ?? false)) {
        await sendEmailVerification(showSuccess: false);
        customSnackBar(
          'Please verify your email. We sent a new verification link.',
          isError: false,
        );
        Get.to(() => Verification(email: email.trim()));
        return;
      }
      userModel.value = await getUserInfo(uid: user.uid);

      _openApp();
    });
  }

  Future<void> signInWithGoogle() async {
    await _runAuthAction(() async {
      await _ensureGoogleSignInReady();
      if (!_googleSignIn.supportsAuthenticate()) {
        customSnackBar('Google sign-in is not supported on this platform.');
        return;
      }

      final googleUser = await _googleSignIn.authenticate();
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) {
        customSnackBar('Google sign-in did not return an ID token.');
        return;
      }

      final credential = GoogleAuthProvider.credential(idToken: idToken);
      final result = await _auth.signInWithCredential(credential);

      // Save user to Firestore
      if (result.user != null) {
        await _saveUserToFirestore(
          uid: result.user!.uid,
          name: result.user!.displayName ?? 'User',
          email: result.user!.email ?? '',
        );
        userModel.value = await getUserInfo(uid: result.user!.uid);
      }

      _openApp();
    });
  }

  Future<void> signInWithApple() async {
    await _runAuthAction(() async {
      final rawNonce = _generateNonce();
      final hashedNonce = _sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: hashedNonce,
      );

      final idToken = appleCredential.identityToken;
      if (idToken == null) {
        customSnackBar('Apple sign-in did not return an identity token.');
        return;
      }

      final oauthCredential = OAuthProvider(
        'apple.com',
      ).credential(idToken: idToken, rawNonce: rawNonce);

      final credential = await _auth.signInWithCredential(oauthCredential);
      final displayName = [
        appleCredential.givenName,
        appleCredential.familyName,
      ].whereType<String>().where((part) => part.trim().isNotEmpty).join(' ');

      if (displayName.isNotEmpty &&
          (credential.user?.displayName?.isEmpty ?? true)) {
        await credential.user?.updateDisplayName(displayName);
      }

      // Save user to Firestore
      if (credential.user != null) {
        await _saveUserToFirestore(
          uid: credential.user!.uid,
          name: credential.user!.displayName ?? 'User',
          email: credential.user!.email ?? '',
        );
        userModel.value = await getUserInfo(uid: credential.user!.uid);
      }

      _openApp();
    });
  }

  Future<void> sendEmailVerification({bool showSuccess = true}) async {
    final user = _auth.currentUser;
    if (user == null) {
      customSnackBar('No signed-in user found.');
      return;
    }

    isSendingVerification = true;
    update();
    try {
      await user.sendEmailVerification();
      if (showSuccess) {
        customSnackBar('Verification email sent.', isError: false);
      }
    } on FirebaseAuthException catch (error) {
      customSnackBar(_messageForAuthException(error));
    } finally {
      isSendingVerification = false;
      update();
    }
  }

  Future<void> checkEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      customSnackBar('Please log in again to check verification.');
      Get.offAll(() => const Login());
      return;
    }

    await _runAuthAction(() async {
      await user.reload();
      if (_auth.currentUser?.emailVerified ?? false) {
        _openApp();
      } else {
        customSnackBar('Email is not verified yet.');
      }
    });
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.trim().isEmpty || !GetUtils.isEmail(email.trim())) {
      customSnackBar('Please enter a valid email address.');
      return;
    }

    await _runAuthAction(() async {
      await _auth.sendPasswordResetEmail(email: email.trim());
      customSnackBar(
        'Password reset link sent. Please check your inbox.',
        isError: false,
      );
      Get.offAll(() => const Login());
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    userModel.value = null;
    Get.offAll(() => const Login());
  }

  bool _validateNameEmailPassword(String name, String email, String password) {
    if (name.trim().isEmpty) {
      customSnackBar('Please enter your name.');
      return false;
    }
    return _validateEmailPassword(email, password);
  }

  bool _validateEmailPassword(String email, String password) {
    if (email.trim().isEmpty || !GetUtils.isEmail(email.trim())) {
      customSnackBar('Please enter a valid email address.');
      return false;
    }
    if (password.length < 6) {
      customSnackBar('Password must be at least 6 characters.');
      return false;
    }
    return true;
  }

  Future<void> _runAuthAction(Future<void> Function() action) async {
    isLoading(true);
    update();
    try {
      await action();
    } on FirebaseAuthException catch (error) {
      debugPrint(
        'FirebaseAuthException: code=${error.code}, message=${error.message}',
      );
      customSnackBar(_messageForAuthException(error));
    } on SignInWithAppleAuthorizationException catch (error) {
      if (error.code != AuthorizationErrorCode.canceled) {
        customSnackBar('Apple sign-in failed. Please try again.');
      }
    } on GoogleSignInException catch (error) {
      if (error.code != GoogleSignInExceptionCode.canceled) {
        customSnackBar(error.description ?? 'Google sign-in failed.');
      }
    } catch (e) {
      customSnackBar('Something went wrong. Please try again.');
    } finally {
      isLoading(false);
      update();
    }
  }

  void _openApp() {
    Get.offAll(() => CameraPermission());
  }

  String _messageForAuthException(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'user-not-found':
        return 'No account found for this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid sign-in credential. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'Please choose a stronger password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'invalid-oauth-provider':
        return 'Invalid Apple sign-in provider configuration.';
      case 'invalid-oauth-client-id':
        return 'Invalid Apple OAuth client ID configuration.';
      default:
        return error.message ?? 'Authentication failed. Please try again.';
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserModel?> getUserInfo({String? uid}) async {
    try {
      final userId = uid ?? _auth.currentUser?.uid;
      if (userId == null || userId.isEmpty) return null;

      final userDoc = await _firestore.collection('users').doc(userId).get();
      final data = userDoc.data();
      if (!userDoc.exists || data == null) return null;

      final user = UserModel.fromJson(data);
      if (userId == _auth.currentUser?.uid) {
        userModel.value = user;
      }
      return user;
    } catch (e) {
      debugPrint('Error getting user info from Firestore: $e');
      return null;
    }
  }

  Future<void> updateUserInfo({String? name, String? imageUrl}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      customSnackBar('No signed-in user found.');
      return;
    }

    final trimmedName = name?.trim();
    final trimmedImageUrl = imageUrl?.trim();

    if (trimmedName != null && trimmedName.isEmpty) {
      customSnackBar('Please enter your name.');
      return;
    }

    if ((trimmedName == null || trimmedName.isEmpty) &&
        (trimmedImageUrl == null || trimmedImageUrl.isEmpty)) {
      customSnackBar('Nothing to update.');
      return;
    }

    await _runAuthAction(() async {
      final updateData = <String, dynamic>{'updatedAt': DateTime.now()};

      if (trimmedName != null && trimmedName.isNotEmpty) {
        updateData['name'] = trimmedName;
        await currentUser.updateDisplayName(trimmedName);
      }

      if (trimmedImageUrl != null && trimmedImageUrl.isNotEmpty) {
        updateData['imageUrl'] = trimmedImageUrl;
        await currentUser.updatePhotoURL(trimmedImageUrl);
      }

      await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .set(updateData, SetOptions(merge: true));

      await currentUser.reload();
      userModel.value = await getUserInfo(uid: currentUser.uid);
      customSnackBar('Profile updated successfully.', isError: false);
    });
  }

  Future<String?> uploadProfileImage(File imageFile) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      customSnackBar('No signed-in user found.');
      return null;
    }

    try {
      final fileExtension = imageFile.path.split('.').last.toLowerCase();
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final storageRef = _storage
          .ref()
          .child('users')
          .child(currentUser.uid)
          .child('profile')
          .child(fileName);

      final uploadTask = await storageRef.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      debugPrint('Firebase Storage upload error: ${e.code} - ${e.message}');
      customSnackBar('Failed to upload profile image.');
      return null;
    } catch (e) {
      debugPrint('Profile image upload error: $e');
      customSnackBar('Failed to upload profile image.');
      return null;
    }
  }

  Future<void> _saveUserToFirestore({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      final userModel = UserModel(
        uid: uid,
        name: name,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(uid)
          .set(userModel.toJson(), SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error saving user to Firestore: $e');
      // Don't show error to user as auth was successful
    }
  }
}
