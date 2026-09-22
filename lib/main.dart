import 'package:camera/camera.dart';
import 'package:dpbtn_absen/providers/approval_provider.dart';
import 'package:dpbtn_absen/providers/article_provider.dart';
import 'package:dpbtn_absen/providers/circular_letter_provider.dart';
import 'package:dpbtn_absen/providers/employee_organization_provider.dart';
import 'package:dpbtn_absen/providers/guideline_provider.dart';
import 'package:dpbtn_absen/providers/decision_letter_provider.dart';
import 'package:dpbtn_absen/providers/founder_decree_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/providers/app_provider.dart';
import 'package:dpbtn_absen/providers/attendance_provider.dart';
import 'package:dpbtn_absen/providers/attendance_request_provider.dart';
import 'package:dpbtn_absen/providers/auth_provider.dart';
import 'package:dpbtn_absen/providers/leave_provider.dart';
import 'package:dpbtn_absen/providers/overtime_provider.dart';
import 'package:dpbtn_absen/providers/permit_provider.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:dpbtn_absen/screens/splash/splash_screen.dart';
import 'package:dpbtn_absen/services/firebase_messaging_service.dart';
import 'package:dpbtn_absen/services/notification_service.dart';
import 'package:dpbtn_absen/configs/app.dart';
import 'package:provider/single_child_widget.dart';
import 'package:upgrader/upgrader.dart';

final NotificationService _notificationService = NotificationService();
final FirebaseMessagingService _firebaseMessagingService =
    FirebaseMessagingService();
List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _firebaseMessagingService.init(_notificationService);
  await _notificationService.init();
  cameras = await availableCameras();

  if (kDebugMode) {
    await Upgrader.clearSavedSettings();
  }

  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return MaterialApp(
      title: 'DPBTN ABSEN',
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerStateKey,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: LayoutColor.primary,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => AppProvider()),
  ChangeNotifierProvider(create: (_) => AuthProvider()),
  ChangeNotifierProvider(create: (_) => ProfileProvider()),
  ChangeNotifierProvider(create: (_) => AttendanceProvider()),
  ChangeNotifierProvider(create: (_) => AttendanceRequestProvider()),
  ChangeNotifierProvider(create: (_) => LeaveProvider()),
  ChangeNotifierProvider(create: (_) => PermitProvider()),
  ChangeNotifierProvider(create: (_) => OvertimeProvider()),
  ChangeNotifierProvider(create: (_) => ApprovalProvider()),
  ChangeNotifierProvider(create: (_) => EmployeeOrganizationProvider()),
  ChangeNotifierProvider(create: (_) => GuidelineProvider()),
  ChangeNotifierProvider(create: (_) => CircularLetterProvider()),
  ChangeNotifierProvider(create: (_) => ArticleProvider()),
  ChangeNotifierProvider(create: (_) => DecisionLetterProvider()),
  ChangeNotifierProvider(create: (_) => FounderDecreeProvider()),
];
