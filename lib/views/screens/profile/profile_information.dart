import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sarkasm/controllers/auth_controller.dart';
import 'package:sarkasm/utils/custom_snackbar.dart';
import 'package:sarkasm/views/base/custom_app_bar.dart';
import 'package:sarkasm/views/base/custom_button.dart';
import 'package:sarkasm/views/base/custom_text_field.dart';
import 'package:sarkasm/views/base/profile_picture.dart';

class ProfileInformation extends StatefulWidget {
  const ProfileInformation({super.key});

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  final auth = Get.find<AuthController>();
  bool isEditing = false;
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  File? profilePic;

  @override
  void initState() {
    super.initState();
    nameCtrl.text = auth.getUser?.name ?? "";
    emailCtrl.text = auth.getUser?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile Information"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ProfilePicture(
                image: auth.getUser?.imageUrl,
                imageFile: profilePic,
                isEditable: isEditing,
                imagePickerCallback: (p0) {
                  setState(() {
                    profilePic = p0;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: nameCtrl,
                title: "Name",
                hintText: "Enter your name",
              ),
              const SizedBox(height: 20),
              if (!isEditing)
                CustomTextField(
                  controller: emailCtrl,
                  title: "Email",
                  hintText: "Enter your email",
                ),
              Spacer(),
              CustomButton(
                onTap: () async {
                  if (isEditing) {
                    String? imageUrl;
                    if (profilePic != null) {
                      try {
                        imageUrl = await auth.uploadProfileImage(profilePic!);
                      } catch (e) {
                        customSnackBar(e.toString());
                      }
                    }
                    await auth.updateUserInfo(
                      name: nameCtrl.text,
                      imageUrl: imageUrl,
                    );
                  }
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                text: isEditing ? "Update Profile" : "Edit Profile",
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
