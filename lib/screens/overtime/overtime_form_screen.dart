import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:dpbtn_absen/models/overtime_type_model.dart';
import 'package:dpbtn_absen/providers/overtime_provider.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class OvertimeFormScreen extends StatefulWidget {
  const OvertimeFormScreen({ super.key });

  @override
  State<OvertimeFormScreen> createState() => _OvertimeFormScreenState();
}

class _OvertimeFormScreenState extends State<OvertimeFormScreen> {
  final TextEditingController _reasonController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  TimeOfDay _startTime = const TimeOfDay(hour: 17, minute: 00);
  TimeOfDay _endTime = const TimeOfDay(hour: 20, minute: 00);
  late OvertimeProvider _overtimeProvider;
  OvertimeTypeModel? _overtimeType;
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
    _overtimeProvider = Provider.of<OvertimeProvider>(context);
  }

  Future _onRefresh() {
    return Future.delayed(const Duration(seconds: 1), () async {
      await _overtimeProvider.getTypes();
      setState(() {
      });
    });
  }
  
  _submitHandler() async {
    setState(() {
      _isLoading = true;
    });
    
    _overtimeProvider.create(
      startDate: _startDate,
      startTime: _startTime.format(context).toString(),
      endDate: _endDate,
      endTime: _endTime.format(context).toString(),
      type: _overtimeType!,
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
      appBar: const LayoutAppBar(
        title: 'Form Lembur',
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
        DropdownSearch<OvertimeTypeModel>(
          items: (filter, infiniteScrollProps) => _overtimeProvider.types,
          itemAsString: (item) => item.name,
          popupProps: const PopupProps.dialog(
            fit: FlexFit.loose,
            title: Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Pilih Tipe Lembur',
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
              labelText: 'Tipe Lembur',
              hintText: 'Pilih Tipe Lembur',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: const Icon(UniconsLine.label)
            ),
          ),
          onChanged: (value) {
            setState(() {
              _overtimeType = value;
            });
          },
          autoValidateMode: AutovalidateMode.always,
        ),

        const SizedBox(height: 30),

        Row(
          children: [
            Flexible(
              child: DateInput(
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
            ),
            const SizedBox(width: 20),
            Flexible(
              child: TimeInput(
                initialTime: _startTime,
                decoration: CustomInputDecoration(
                  labelText: 'Jam',
                  suffixIcon: const Icon(UniconsLine.calendar_alt),
                ),
                onChange: (value) {
                  setState(() {
                    _startTime = value;
                  });
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 30),
        Row(
          children: [
            Flexible(
              child: DateInput(
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
            ),
            const SizedBox(width: 20),
            Flexible(
              child: TimeInput(
                initialTime: _endTime,
                decoration: CustomInputDecoration(
                  labelText: 'Jam',
                  suffixIcon: const Icon(UniconsLine.calendar_alt),
                ),
                onChange: (value) {
                  setState(() {
                    _endTime = value;
                  });
                },
              ),
            ),
          ],
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