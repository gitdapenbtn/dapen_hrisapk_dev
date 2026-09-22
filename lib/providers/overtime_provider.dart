import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/overtime_model.dart';
import 'package:dpbtn_absen/models/overtime_type_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class OvertimeProvider with ChangeNotifier {
  final Http http = Http();

  OvertimeModel? _overtime;
  OvertimeModel? get overtime => _overtime;

  List<OvertimeModel> _overtimes = [];
  List<OvertimeModel> get overtimes => _overtimes;

  List<OvertimeTypeModel> _types = [];
  List<OvertimeTypeModel> get types => _types;

  Future<HttpModel> getOvertimes({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('overtimes', params);

      List<OvertimeModel> newOvertimes = [];
      for (var x in response.data) {
        newOvertimes.add(OvertimeModel.fromJson(x));
      }
      _overtimes = newOvertimes;

      notifyListeners();
      return response;
    } catch (err) {
      _overtimes = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findOvertimeById({required int id}) async {
    HttpModel response = await http.get('overtimes/id/$id');
    _overtime = OvertimeModel.fromJson(response.data);

    notifyListeners();
    return response;
  }

  Future<HttpModel> create({
    required OvertimeTypeModel type,
    required DateTime startDate,
    required String startTime,
    required DateTime endDate,
    required String endTime,
    String? reason,
    List<File>? attachments,
  }) async {
    String startDateString = DateFormat(
      "yyyy-MM-dd",
    ).format(startDate).toString();
    String endDateString = DateFormat("yyyy-MM-dd").format(endDate).toString();

    Map<String, String> params = {
      "overtime_type_id": type.id.toString(),
      "start_overtime": '$startDateString $startTime',
      "end_overtime": '$endDateString $endTime',
      "reason": reason ?? '',
    };

    List<MultipartFile> files = [];
    if (attachments != null) {
      files = attachments.map((attachment) {
        return http.multipartFile(
          'attachments[]',
          attachment.readAsBytes().asStream(),
          attachment.lengthSync(),
          basename(attachment.path),
        );
      }).toList();
    }

    HttpModel response = await http.postMultipartRequest(
      'overtimes',
      params: params,
      files: files,
    );

    notifyListeners();
    return response;
  }

  /*  */
  Future<HttpModel> getTypes() async {
    try {
      HttpModel response = await http.get('overtime_types');

      List<OvertimeTypeModel> newTypes = [];
      for (var x in response.data) {
        newTypes.add(OvertimeTypeModel.fromJson(x));
      }
      _types = newTypes;

      notifyListeners();
      return response;
    } catch (err) {
      _types = [];

      notifyListeners();
      rethrow;
    }
  }
}
