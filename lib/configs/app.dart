import 'package:flutter/material.dart';
import 'package:dpbtn_absen/screens/home/home_screen.dart';
import 'package:dpbtn_absen/screens/login/login_screen.dart';

/* Global Key */
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerStateKey =
    GlobalKey<ScaffoldMessengerState>();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
const homeScreen = HomeScreen();
const loginScreen = LoginScreen();

/* App */
const String title = 'DPBTN ABSEN';

/* API */
const api = {
  'url_default' : 'https://hrisdapenbtn.com',
  // 'url_default': 'http://10.0.2.2:8000',
};
