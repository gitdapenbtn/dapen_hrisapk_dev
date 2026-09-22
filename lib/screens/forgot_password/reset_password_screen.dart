import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dpbtn_absen/components/alert_message.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/providers/auth_provider.dart';
import 'package:dpbtn_absen/screens/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String verificationCode;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  late AuthProvider _authProvider;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();
  final FocusNode _newPasswordFocus = FocusNode();
  final FocusNode _newPasswordConfirmationFocus = FocusNode();
  String? _errorMessage;
  String? _newPasswordConfirmationErrorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  _submitHandler() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    String newPassword = _newPasswordController.text;
    String newPasswordConfirmation = _newPasswordConfirmationController.text;

    if (newPassword == newPasswordConfirmation) {
      _authProvider
          .resetPassword(
            email: widget.email,
            newPassword: newPassword,
            newPasswordConfirmation: newPasswordConfirmation,
            verificationCode: widget.verificationCode,
          )
          .then((resp) {
            showSnackBarAnywhere(resp.message ?? '');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
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
    } else {
      setState(() {
        _newPasswordController.clear();
        _newPasswordConfirmationController.clear();
        _newPasswordConfirmationErrorMessage = null;
      });
    }
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
                'Atur Ulang Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 30),
              alignment: Alignment.center,
              width: double.infinity,
              child: const Text(
                'Masukkan Password Baru',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15,
                  color: Colors.black54,
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: TextField(
                controller: _newPasswordController,
                focusNode: _newPasswordFocus,
                decoration: CustomInputDecoration(
                  labelText: 'Password Baru',
                  hintText: 'Password Baru Anda',
                  suffixIcon: const Icon(UniconsLine.lock),
                ),
                enabled: !_isLoading,
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              child: TextField(
                controller: _newPasswordConfirmationController,
                focusNode: _newPasswordConfirmationFocus,
                decoration: CustomInputDecoration(
                  errorText: _newPasswordConfirmationErrorMessage,
                  labelText: 'Konfirmasi Password Baru',
                  hintText: 'Ulangi Password Baru Anda',
                  suffixIcon: const Icon(UniconsLine.lock),
                ),
                enabled: !_isLoading,
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
                onPressed: !_isLoading ? _submitHandler : null,
                child: const Text('Ubah Password'),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: LayoutColor.primary,
      body: Center(child: SvgPicture.asset('assets/svg/attendance2.svg')),
    );
  }
}
