import 'dart:async';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/helpers/permission.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/screens/login/login_screen.dart';
import 'package:dpbtn_absen/screens/main/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ super.key });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final duration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    splashScreenHandler();
  }
  
  splashScreenHandler() async{
    await requestLocationPermission();
    await requestCameraPermission();
    
    String? accessToken = await Http().getAccessToken();
    if(accessToken != null) {
      return Timer(duration, redirectToHomeScreen);
    } else {
      return Timer(duration, redirectToLoginScreen);
    }
  }

  redirectToLoginScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  redirectToHomeScreen() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LayoutColor.primary,
      body: SafeArea(
        child: Center(
          child: Image.asset(
            'assets/images/splashscreen.png',
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.fitWidth,
          ),
        )
      )
    );
  }
}