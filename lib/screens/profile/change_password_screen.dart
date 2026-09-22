import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late ProfileProvider _profileProvider;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPasswordConfirmationController =
      TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  }

  _submitHandler() async {
    try {
      setState(() {
        _isLoading = true;
      });

      HttpModel resp = await _profileProvider.changePassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
        newPasswordConfirmation: _newPasswordConfirmationController.text,
      );

      showSnackBarAnywhere(resp.message ?? '');

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      showSnackBarAnywhere(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      isLoading: _isLoading,
      padding: const EdgeInsets.all(20),
      appBar: const LayoutAppBar(title: 'Ganti Password'),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          onPressed: _isLoading ? null : _submitHandler,
          child: const Text('Simpan'),
        ),
      ),
      children: [
        TextFormField(
          controller: _oldPasswordController,
          decoration: CustomInputDecoration(labelText: 'Password Lama'),
        ),

        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextFormField(
            controller: _newPasswordController,
            decoration: CustomInputDecoration(labelText: 'Password Baru'),
          ),
        ),

        Container(
          margin: const EdgeInsets.only(top: 20),
          child: TextFormField(
            controller: _newPasswordConfirmationController,
            decoration: CustomInputDecoration(
              labelText: 'Konfirmasi Password Baru',
            ),
          ),
        ),
      ],
    );
  }
}
