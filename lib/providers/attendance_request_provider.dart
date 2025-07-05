import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/attendance_request_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class AttendanceRequestProvider with ChangeNotifier {
  final Http http = Http();
  
  AttendanceRequestModel? _attendanceRequest;
  AttendanceRequestModel? get attendanceRequest => _attendanceRequest;

  List<AttendanceRequestModel> _attendanceRequests = [];
  List<AttendanceRequestModel> get attendanceRequests => _attendanceRequests;
  
  Future<HttpModel> getAttendanceRequests({ Map<String, dynamic>? params }) async {
    try {
      HttpModel response = await http.get('attendance_requests', params);

      List<AttendanceRequestModel> newAttendanceRequests = [];
      for(var x in response.data) {
        newAttendanceRequests.add(AttendanceRequestModel.fromJson(x));
      }
      _attendanceRequests = newAttendanceRequests;

      notifyListeners();
      return response;
    }
    catch(err) {
      _attendanceRequests = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findAttendanceRequestById({required int id}) async {
    HttpModel response = await http.get('attendance_requests/id/$id');
    _attendanceRequest = AttendanceRequestModel.fromJson(response.data);

    notifyListeners();
    return response;
  }

  Future<HttpModel> create({
    required DateTime date,
    TimeOfDay? timeIn,
    TimeOfDay? timeOut,
    String? note,
    List<File>? attachments,
  }) async {
    formatTime(TimeOfDay? time) {
      if(time != null) {
        final valString = time.toString();
        return valString.replaceAll('TimeOfDay(', '').replaceAll(')', '');
      }

      return null;
    }

    Map<String, String> params= {
      "attendance_date": DateFormat("yyyy-MM-dd").format(date).toString(),
      "time_in": formatTime(timeIn) ?? '',
      "time_out": formatTime(timeOut) ?? '',
      "note": note ?? '',
    };

    List<MultipartFile> files = [];
    if(attachments != null) {
      files = attachments.map((attachment) {
        return http.multipartFile(
          'attachments[]',
          attachment.readAsBytes().asStream(), 
          attachment.lengthSync(),
          basename(attachment.path)
        );
      }).toList();
    }

    HttpModel response = await http.postMultipartRequest('attendance_requests', params: params, files: files);    
    
    notifyListeners();
    return response;
  }
}