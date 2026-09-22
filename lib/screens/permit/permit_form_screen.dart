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
import 'package:dpbtn_absen/models/permit_type_model.dart';
import 'package:dpbtn_absen/providers/permit_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class PermitFormScreen extends StatefulWidget {
  const PermitFormScreen({super.key});

  @override
  State<PermitFormScreen> createState() => _PermitFormScreenState();
}

class _PermitFormScreenState extends State<PermitFormScreen> {
  final TextEditingController _reasonController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  late PermitProvider _permitProvider;
  PermitTypeModel? _permitType;
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
    _permitProvider = Provider.of<PermitProvider>(context);
  }

  Future _onRefresh() {
    return Future.delayed(const Duration(seconds: 1), () async {
      await _permitProvider.getTypes();
      setState(() {});
    });
  }

  _submitHandler() async {
    setState(() {
      _isLoading = true;
    });

    _permitProvider
        .create(
          startDate: _startDate,
          endDate: _endDate,
          type: _permitType!,
          reason: _reasonController.text,
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
      appBar: const LayoutAppBar(title: 'Form Izin'),
      padding: const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 80),
      bottomSheet: Container(
        color: LayoutColor.background,
        padding: const EdgeInsets.all(20),
        child: PrimaryButton(
          onPressed: _isLoading ? null : _submitHandler,
          child: const Text('Kirim'),
        ),
      ),
      children: [
        DropdownSearch<PermitTypeModel>(
          items: (filter, infiniteScrollProps) => _permitProvider.types,
          itemAsString: (item) => item.name,
          popupProps: const PopupProps.dialog(
            fit: FlexFit.loose,
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Pilih Tipe Izin',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          decoratorProps: DropDownDecoratorProps(
            decoration: CustomInputDecoration(
              labelText: 'Tipe Izin',
              hintText: 'Pilih Tipe Izin',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const Icon(UniconsLine.label),
            ),
          ),
          onChanged: (value) {
            setState(() {
              _permitType = value;
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
            labelText: 'Alasan',
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
