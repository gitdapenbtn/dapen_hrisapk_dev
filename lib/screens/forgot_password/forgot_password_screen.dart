import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dpbtn_absen/components/alert_message.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/providers/auth_provider.dart';
import 'package:dpbtn_absen/screens/forgot_password/forgot_password_confirmation_screen.dart';
import 'package:dpbtn_absen/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({ super.key });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  late AuthProvider _authProvider;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  _submitHandler() {
    setState(() {
      _isLoading = true;
    });

    _authProvider.forgotPassword(_emailController.text)
      .then((resp) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ForgotPasswordConfirmationScreen(
              email: _emailController.text,
              verificationCode: resp.data['verification_code']
            )
          )
        );
      })
      .catchError((err) {
        setState(() {
          _errorMessage = err.toString();
        });
      })
      .whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              blurRadius: 10
            )
          ]
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text('Lupa Password', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black87
              )),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text('Atur Ulang Password', style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 15,
                color: Colors.black54
              )),
            ),

            SizedBox(
              width: double.infinity,
              child: TextField(
                controller: _emailController,
                decoration: CustomInputDecoration(
                  labelText: 'Email',
                  hintText: 'Your Email',
                  suffixIcon: const Icon(UniconsLine.envelope),
                ),
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
              margin: const EdgeInsets.only(top: 20, bottom: 20),
              alignment: Alignment.center,
              child: PrimaryButton(
                onPressed: _isLoading ? null : _submitHandler,
                child: const Text('Reset Password'),
              ),
            ),

            InkWell(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text(
                'Masuk',
                style: TextStyle(
                  color: LayoutColor.info
                ),
              ),
            )              
          ],
        ),
      ),
      backgroundColor: LayoutColor.primary,
      body: Center(
        child: SvgPicture.asset('assets/svg/attendance2.svg')
      ),
    );
  }
}