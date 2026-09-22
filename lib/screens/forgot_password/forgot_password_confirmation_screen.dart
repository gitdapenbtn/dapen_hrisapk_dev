import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/on_will_pop_exit.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/screens/forgot_password/reset_password_screen.dart';

class ForgotPasswordConfirmationScreen extends StatefulWidget {
  final String email;
  final String verificationCode;

  const ForgotPasswordConfirmationScreen({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<ForgotPasswordConfirmationScreen> createState() =>
      _ForgotPasswordConfirmationScreenState();
}

class _ForgotPasswordConfirmationScreenState
    extends State<ForgotPasswordConfirmationScreen> {
  final FocusNode _code1Focus = FocusNode();
  final FocusNode _code2Focus = FocusNode();
  final FocusNode _code3Focus = FocusNode();
  final FocusNode _code4Focus = FocusNode();
  final TextEditingController _code1 = TextEditingController();
  final TextEditingController _code2 = TextEditingController();
  final TextEditingController _code3 = TextEditingController();
  final TextEditingController _code4 = TextEditingController();

  _submitHandler() {
    String verificationCode =
        _code1.text + _code2.text + _code3.text + _code4.text;
    if (widget.verificationCode == verificationCode) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(
            email: widget.email,
            verificationCode: verificationCode,
          ),
        ),
      );
    }
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
                  'Kode Verifikasi',
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
                  'Kode Dikirim Melalui Email',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      child: TextFormField(
                        controller: _code1,
                        focusNode: _code1Focus,
                        keyboardType: TextInputType.number,
                        decoration: CustomInputDecoration(),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _code2Focus.requestFocus();
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _code2Focus.requestFocus();
                          } else {
                            _code1Focus.requestFocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      child: TextFormField(
                        controller: _code2,
                        focusNode: _code2Focus,
                        keyboardType: TextInputType.number,
                        decoration: CustomInputDecoration(),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _code1Focus.requestFocus();
                          } else {
                            _code3Focus.requestFocus();
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _code3Focus.requestFocus();
                          } else {
                            _code2Focus.requestFocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      child: TextFormField(
                        controller: _code3,
                        focusNode: _code3Focus,
                        keyboardType: TextInputType.number,
                        decoration: CustomInputDecoration(),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _code2Focus.requestFocus();
                          } else {
                            _code4Focus.requestFocus();
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (value.isNotEmpty) {
                            _code4Focus.requestFocus();
                          } else {
                            _code3Focus.requestFocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 5,
                      child: TextFormField(
                        controller: _code4,
                        focusNode: _code4Focus,
                        keyboardType: TextInputType.number,
                        decoration: CustomInputDecoration(),
                        maxLength: 1,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            _code3Focus.requestFocus();
                          }
                        },
                        onFieldSubmitted: (value) {
                          if (value.isEmpty) {
                            _code4Focus.requestFocus();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                child: PrimaryButton(
                  onPressed: _submitHandler,
                  child: const Text('Verifikasi'),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: LayoutColor.primary,
        body: Center(child: SvgPicture.asset('assets/svg/attendance2.svg')),
      ),
    );
  }
}
