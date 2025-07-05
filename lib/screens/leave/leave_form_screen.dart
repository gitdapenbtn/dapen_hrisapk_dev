import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/custom_input_decoration.dart';
import 'package:dpbtn_absen/components/date_input.dart';
import 'package:dpbtn_absen/components/file_input.dart';
import 'package:dpbtn_absen/components/primary_button.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/leave_type_model.dart';
import 'package:dpbtn_absen/providers/leave_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class LeaveFormScreen extends StatefulWidget {
  const LeaveFormScreen({ super.key });

  @override
  State<LeaveFormScreen> createState() => _LeaveFormScreenState();
}

class _LeaveFormScreenState extends State<LeaveFormScreen> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _addressController= TextEditingController();
  late LeaveProvider _leaveProvider;

  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  LeaveTypeModel? _leaveType;
  List<File> _attachments = [];
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
    _leaveProvider = Provider.of<LeaveProvider>(context);
  }

  Future _onRefresh() {
    return Future.delayed(const Duration(seconds: 1), () async {
      await _leaveProvider.getTypes();
      setState(() {
      });
    });
  }
  
  _submitHandler() async {
    setState(() {
      _isLoading = true;
    });

    _leaveProvider.create(
      startDate: _startDate,
      endDate: _endDate,
      type: _leaveType!,
      reason: _reasonController.text,
      address: _addressController.text,
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
      onRefresh: _onRefresh,
      appBar: const LayoutAppBar(
        title: 'Form Cuti',
      ),
      padding: const EdgeInsets.only(
        top: 30,
        left: 20,
        right: 20,
        bottom: 80
      ),
      bottomSheet: Container(
        color: LayoutColor.background,
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          onPressed: _isLoading 
            ? null
            : _submitHandler ,
          child: const Text('Kirim'),
        ),
      ),
      children: [
        DropdownSearch<LeaveTypeModel>(
          items: (filter, infiniteScrollProps) => _leaveProvider.types,
          itemAsString: (item) => item.name,
          popupProps: const PopupProps.dialog(
            fit: FlexFit.loose,
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Pilih Tipe Cuti',
                textAlign: TextAlign.center, 
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              )
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: CustomInputDecoration(
              labelText: 'Tipe Cuti',
              hintText: 'Pilih Tipe Cuti',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const Icon(UniconsLine.label)
            ),
          ),
          onChanged: (value) {
            setState(() {
              _leaveType = value;
            });
          },
          autoValidateMode: AutovalidateMode.always,
        ),

        const SizedBox(height: 30),
        DateInput(
          initialDate: _startDate,
          decoration: CustomInputDecoration(
            labelText: 'Mulai Tanggal',
            suffixIcon: const Icon(UniconsLine.calendar_alt),
          ),
          onChange: (value) {
            setState(() {
              _startDate = value;
            });
          },
        ),

        const SizedBox(height: 30),
        DateInput(
          initialDate: _endDate,
          decoration: CustomInputDecoration(
            labelText: 'Sampai Tanggal',
            suffixIcon: const Icon(UniconsLine.calendar_alt),
          ),
          onChange: (value) {
            setState(() {
              _endDate = value;
            });
          },
        ),

        const SizedBox(height: 30),
        TextFormField(
          controller: _reasonController,
          maxLines: null,
          decoration: CustomInputDecoration(
            labelText: 'Alasan / Keperluan',
            suffixIcon: const Icon(UniconsLine.notes),
          ),
        ),

        const SizedBox(height: 30),
        TextFormField(
          controller: _addressController,
          maxLines: null,
          decoration: CustomInputDecoration(
            labelText: 'Alamat Cuti',
            suffixIcon: const Icon(UniconsLine.home),
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