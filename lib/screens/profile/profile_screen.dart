import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/section.dart';
import 'package:dpbtn_absen/components/section_title.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _religionController = TextEditingController();
  final TextEditingController _organizationController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _joinDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  late ProfileProvider _profileProvider;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _profileProvider = Provider.of<ProfileProvider>(context);
  }

  @protected
  @mustCallSuper
  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });
    return Future.delayed(const Duration(seconds: 1), () async {
      await _profileProvider.getProfile();

      final employee = _profileProvider.profile!.employee!;

      _nikController.text = employee.registrationNumber ?? '';
      _nameController.text = employee.name;
      _emailController.text = employee.email;
      _genderController.text = employee.gender != null
          ? employee.gender!.name
          : '';
      _birthdayController.text = employee.birthday ?? '';
      _religionController.text = employee.religion ?? '';
      _joinDateController.text = employee.joinDate ?? '';

      _organizationController.text = employee.organization != null
          ? employee.organization!.name
          : '';
      _positionController.text = employee.position != null
          ? employee.position!.name
          : '';

      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      hasNavigationBottom: true,
      isLoading: _isLoading,
      onRefresh: _onRefresh,
      appBar: const LayoutAppBar(title: 'Profil'),
      child: Column(
        children: [
          const SectionTitle('Biodata', margin: EdgeInsets.only(bottom: 20)),
          Section(
            child: Column(
              children: [
                TextFormField(
                  controller: _nikController,
                  enabled: false,
                  decoration: CustomInputDecoration(
                    labelText: 'Nomor Induk Karyawan',
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _nameController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Nama Karyawan'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Jenis Kelamin'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _birthdayController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Tanggal Lahir'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _religionController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Agama'),
                ),
              ],
            ),
          ),

          const SectionTitle('Pekerjaan', margin: EdgeInsets.only(bottom: 20)),
          Section(
            child: Column(
              children: [
                TextFormField(
                  controller: _positionController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Jabatan'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _organizationController,
                  enabled: false,
                  decoration: CustomInputDecoration(labelText: 'Divisi'),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _joinDateController,
                  enabled: false,
                  decoration: CustomInputDecoration(
                    labelText: 'Tanggal Bergabung',
                  ),
                ),
              ],
            ),
          ),

          const SectionTitle('Akun', margin: EdgeInsets.only(bottom: 20)),
          Section(
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: CustomInputDecoration(labelText: 'Email'),
                  enabled: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
