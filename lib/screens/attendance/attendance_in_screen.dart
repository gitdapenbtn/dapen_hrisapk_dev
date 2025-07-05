// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:datetime_setting/datetime_setting.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/location_picker.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/components/selfie_picker.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/parts/layout_buttom_sheet.dart';
import 'package:dpbtn_absen/providers/attendance_provider.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class AttendanceInScreen extends StatefulWidget {
  const AttendanceInScreen({ super.key });

  @override
  State<AttendanceInScreen> createState() => _AttendanceInScreenState();
}

class _AttendanceInScreenState extends State<AttendanceInScreen> {
  final TextEditingController _noteController = TextEditingController();
  late AttendanceProvider _attendanceProvider;
  late ProfileProvider _profileProvider;

  File? _image;
  LocationData? _location;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendanceProvider = Provider.of<AttendanceProvider>(context, listen: false);
    _profileProvider = Provider.of<ProfileProvider>(context, listen: false);
  }

  _timeAutoSettingDialog() {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Batal"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    
    Widget continueButton = TextButton(
      child: const Text("Pengaturan"),
      onPressed: () {
        Navigator.pop(context);
        DatetimeSetting.openSetting();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Waktu tidak sesuai."),
      content: const Text("Aktifkan Mode Waktu Otomatis."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _submitHandler() async {
    setState(() {
      _isLoading = true;
    });

    bool timeAuto = true;
    bool timezoneAuto = true;

    if(Platform.isAndroid) {
      timeAuto = await DatetimeSetting.timeIsAuto();
      timezoneAuto = await DatetimeSetting.timeZoneIsAuto();
    }

    if (!timezoneAuto || !timeAuto) {
      setState(() {
        _isLoading = false;
      });
      _timeAutoSettingDialog();
    } else {
      _attendanceProvider.postTimeIn(
        photo: _image!,
        latitude: _location!.latitude.toString(),
        longitude: _location!.longitude.toString(),
        time: TimeOfDay.now().format(context).toString(),
        note: _noteController.text
      )
      .then((resp) async {
        showSnackBarAnywhere('Berhasil absen masuk.');
        // showSnackBarAnywhere('${resp.message}');
        await _profileProvider.getAttendanceToday();
      })
      .catchError((err) {
        setState(() {
          _isLoading = false;
        });
        showSnackBarAnywhere(err.toString());
      })
      .whenComplete(() {
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomSheet: _bottomSheet(),
    );
  }

  Widget _body() {
    Widget body;

    if(_image == null) {
      body = SelfiePicker(
        onTakePicture: (image) {
          setState(() {
            _image = File(image);
          });
        },
      );
    } else {
      body = LocationPicker(
        onChange: (value) {
          setState(() {
            _location = value;
          });
        },
      );
    }

    return body;
  }

  Widget? _bottomSheet() {
    Widget? bottomSheet;

    if(_image != null) {
      bottomSheet = LayoutBottomSheet(
        title: 'Absen Masuk',
        children: [
          TextFormField(
            controller: _noteController,
            decoration: CustomInputDecoration(
              labelText: 'Catatan',
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            onPressed: _isLoading 
              ? null 
              : _submitHandler,
            child: const Text('Kirim')
          ),
        ],
      );
    } else {
      bottomSheet = null;
    }
    
    return bottomSheet;
  }
}