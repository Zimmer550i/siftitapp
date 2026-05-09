import 'package:firebase_core/firebase_core.dart';
import 'package:sarkasm/firebase_options.dart';
import 'package:sarkasm/themes/light_theme.dart';
import 'package:sarkasm/utils/app_colors.dart';
import 'package:sarkasm/utils/app_constants.dart';
import 'package:sarkasm/utils/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sarkasm/views/screens/auth/splash.dart';
import 'controllers/localization_controller.dart';
import 'controllers/theme_controller.dart';
import 'helpers/di.dart' as di;
import 'helpers/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  Map<String, Map<String, String>> languages = await di.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.teal[600],
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(languages: languages));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.languages});
  final Map<String, Map<String, String>> languages;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetBuilder<LocalizationController>(
          builder: (localizeController) {
            return GetMaterialApp(
              title: AppConstants.APP_NAME,
              debugShowCheckedModeBanner: false,
              // theme: themeController.darkTheme ? dark() : light(),
              theme: light(),
              defaultTransition: Transition.cupertino,
              locale: localizeController.locale,
              translations: Messages(languages: languages),
              fallbackLocale: Locale(
                AppConstants.languages[0].languageCode,
                AppConstants.languages[0].countryCode,
              ),
              transitionDuration: const Duration(milliseconds: 500),
              getPages: AppRoutes.pages,
              // initialRoute: AppRoutes.splash,
              home: Splash(),
            );
          },
        );
      },
    );
  }
}
