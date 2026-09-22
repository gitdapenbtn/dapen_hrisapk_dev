import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/avatar_initial_name.dart';
import 'package:dpbtn_absen/components/section.dart';
import 'package:dpbtn_absen/components/section_title.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/providers/auth_provider.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:dpbtn_absen/screens/login/login_screen.dart';
import 'package:dpbtn_absen/screens/profile/change_password_screen.dart';
import 'package:dpbtn_absen/screens/profile/profile_screen.dart';
import 'package:dpbtn_absen/screens/leave_quota/leave_quota_screen.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late AuthProvider _authProvider;
  bool _isLoading = false;
  String version = '1.0.0';

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
    _getInformation();
  }

  _getInformation() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  _logoutHandler() {
    setState(() {
      _isLoading = true;
    });

    _authProvider
        .logout()
        .then((resp) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
            (route) => false,
          );
        })
        .catchError((err) {
          setState(() {
            _isLoading = false;
          });
          showSnackBarAnywhere(err.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasNavigationBottom: true,
      isLoading: _isLoading,
      children: [
        Section(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            width: MediaQuery.of(context).size.width,
            child: Consumer<ProfileProvider>(
              builder: (context, value, child) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AvatarInitialName(
                    name: value.profile?.employee?.name ?? '-',
                    fontSize: 30,
                    radius: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    value.profile?.employee?.name ?? '-',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: LayoutColor.textPrimary,
                    ),
                  ),
                  Text(
                    value.profile?.employee?.organization?.name ?? '-',
                    style: const TextStyle(
                      fontSize: 14,
                      color: LayoutColor.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        Section(
          child: Column(
            children: [
              _button(
                label: 'Profil',
                icon: const Icon(UniconsLine.user),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileScreen(),
                    ),
                  );
                },
              ),
              _button(
                label: 'Saldo Cuti',
                icon: const Icon(UniconsLine.list_ul),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LeaveQuotaScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        const SectionTitle('Informasi'),
        Section(
          child: Column(
            children: [
              _button(
                label: 'Versi $version',
                icon: const Icon(UniconsLine.info_circle),
              ),
            ],
          ),
        ),

        const SectionTitle('Akun'),
        Section(
          child: Column(
            children: [
              _button(
                label: 'Ganti Password',
                icon: const Icon(UniconsLine.lock),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordScreen(),
                    ),
                  );
                },
              ),
              _button(
                label: 'Keluar',
                icon: const Icon(UniconsLine.exit),
                onTap: _logoutHandler,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _button({required String label, Icon? icon, Function? onTap}) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: icon != null,
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: icon,
                    ),
                  ),
                  Text(label),
                ],
              ),
            ),

            Visibility(
              visible: onTap != null,
              child: const Icon(UniconsLine.angle_right),
            ),
          ],
        ),
      ),
    );
  }
}
