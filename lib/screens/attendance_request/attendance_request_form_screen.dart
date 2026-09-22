import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/date_input.dart';
import 'package:dpbtn_absen/components/file_input.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/components/time_input.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/providers/attendance_request_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class AttendanceRequestFormScreen extends StatefulWidget {
  const AttendanceRequestFormScreen({super.key});

  @override
  State<AttendanceRequestFormScreen> createState() =>
      _AttendanceRequestFormScreenState();
}

class _AttendanceRequestFormScreenState
    extends State<AttendanceRequestFormScreen> {
  late AttendanceRequestProvider _attendanceRequestProvider;
  final TextEditingController _noteController = TextEditingController();
  late DateTime _date;
  TimeOfDay? _timeIn;
  TimeOfDay? _timeOut;
  List<File> _attachments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _attendanceRequestProvider = Provider.of<AttendanceRequestProvider>(
      context,
      listen: false,
    );
    _date = DateTime.now();
  }

  _submitHandler() {
    setState(() {
      _isLoading = true;
    });

    _attendanceRequestProvider
        .create(
          date: _date,
          timeIn: _timeIn,
          timeOut: _timeOut,
          note: _noteController.text,
          attachments: _attachments,
        )
        .then((resp) {
          Navigator.pop(context);
          showSnackBarAnywhere('${resp.message}');
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
      isLoading: _isLoading,
      appBar: const LayoutAppBar(title: 'Form Pengajuan Absensi'),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 80),
      bottomSheet: Container(
        color: LayoutColor.background,
        padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        child: PrimaryButton(
          onPressed: _isLoading ? null : _submitHandler,
          child: const Text('Kirim'),
        ),
      ),
      children: [
        DateInput(
          initialDate: _date,
          onChange: (value) {
            setState(() {
              _date = value;
            });
          },
          decoration: CustomInputDecoration(
            labelText: 'Tanggal Absensi',
            suffixIcon: const Icon(UniconsLine.calendar_alt),
          ),
        ),

        const SizedBox(height: 30),

        TimeInput(
          onChange: (value) {
            setState(() {
              _timeIn = value;
            });
          },
          decoration: CustomInputDecoration(
            labelText: 'Jam Masuk',
            suffixIcon: const Icon(UniconsLine.clock_seven),
          ),
        ),

        const SizedBox(height: 30),

        TimeInput(
          onChange: (value) {
            setState(() {
              _timeOut = value;
            });
          },
          decoration: CustomInputDecoration(
            labelText: 'Jam Pulang',
            suffixIcon: const Icon(UniconsLine.clock_five),
          ),
        ),

        const SizedBox(height: 30),

        TextFormField(
          controller: _noteController,
          maxLines: null,
          decoration: CustomInputDecoration(
            labelText: 'Catatan',
            suffixIcon: const Icon(UniconsLine.notes),
          ),
        ),

        const SizedBox(height: 30),
        FileInput(
          onChanged: (value) {
            setState(() {
              _attachments = value;
            });
          },
        ),
      ],
    );
  }
}
