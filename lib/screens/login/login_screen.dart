import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/alert_message.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/on_will_pop_exit.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/providers/auth_provider.dart';
import 'package:dpbtn_absen/screens/forgot_password/forgot_password_screen.dart';
import 'package:dpbtn_absen/screens/main/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _serverController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  late AuthProvider _authProvider;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScopeExit(
      child: Scaffold(
        bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, -2),
                blurRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: const Text(
                  'Selamat Datang',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              ),

              Container(
                alignment: Alignment.center,
                width: double.infinity,
                child: const Text(
                  'Masuk Untuk Melanjutkan',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 30),
                width: double.infinity,
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocus,
                  decoration: CustomInputDecoration(
                    labelText: 'Email',
                    hintText: 'Your Email',
                    suffixIcon: const Icon(UniconsLine.envelope),
                  ),
                  onFieldSubmitted: (value) {
                    _passwordFocus.requestFocus();
                  },
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                width: double.infinity,
                child: TextFormField(
                  controller: _passwordController,
                  focusNode: _passwordFocus,
                  obscureText: true,
                  decoration: CustomInputDecoration(
                    labelText: 'Password',
                    hintText: 'Your Password',
                    suffixIcon: const Icon(UniconsLine.lock),
                  ),
                  onFieldSubmitted: (value) {
                    _submitHandler();
                  },
                ),
              ),

              ListTileTheme(
                contentPadding: EdgeInsets.zero,
                dense: true,
                child: ExpansionTile(
                  title: const Text(
                    'Lanjutan',
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 12),
                  ),
                  initiallyExpanded: false,
                  children: [
                    TextFormField(
                      controller: _serverController,
                      decoration: CustomInputDecoration(
                        labelText: 'Server',
                        hintText: 'https://hrisdapenbtn.com',
                        suffixIcon: const Icon(UniconsLine.server),
                      ),
                    ),
                  ],
                ),
              ),

              Visibility(
                visible: _errorMessage != null,
                child: AlertMessage(
                  message: _errorMessage,
                  margin: const EdgeInsets.only(top: 10),
                  type: AlertMessageType.danger,
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                child: PrimaryButton(
                  onPressed: _isLoading ? null : _submitHandler,
                  child: const Text('Masuk'),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Lupa Password ?',
                    style: TextStyle(color: LayoutColor.info),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: LayoutColor.primary,
        body: Container(
          alignment: Alignment.topCenter,
          child: SvgPicture.asset('assets/svg/attendance2.svg'),
        ),
      ),
    );
  }

  _submitHandler() async {
    try {
      setState(() {
        _errorMessage = null;
        _isLoading = true;
      });

      await _authProvider.login(
        email: _emailController.text,
        password: _passwordController.text,
        server: _serverController.text,
      );

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
        (route) => false,
      );
    } catch (err) {
      setState(() {
        _errorMessage = err.toString();
        _isLoading = false;
      });
    }
  }
}
