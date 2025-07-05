import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/leave_model.dart';
import 'package:dpbtn_absen/models/leave_type_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class LeaveProvider with ChangeNotifier {
  final Http http = Http();
  
  LeaveModel? _leave;
  LeaveModel? get leave => _leave;

  List<LeaveModel> _leaves = [];
  List<LeaveModel> get leaves => _leaves;

  List<LeaveTypeModel> _types = [];
  List<LeaveTypeModel> get types => _types;
  
  Future<HttpModel> getLeaves({ Map<String, dynamic>? params }) async {
    try {
      HttpModel response = await http.get('leaves', params);

      List<LeaveModel> newLeaves = [];
      for(var x in response.data) {
        newLeaves.add(LeaveModel.fromJson(x));
      }
      _leaves = newLeaves;
      
      notifyListeners();
      return response;
    }
    catch(err) {
      _leaves = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findLeaveById({required int id}) async {
    HttpModel response = await http.get('leaves/id/$id');
    _leave = LeaveModel.fromJson(response.data);

    notifyListeners();
    return response;
  }

  Future<HttpModel> create({
    required LeaveTypeModel type,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
    String? address,
    List<File>? attachments,
  }) async {
    Map<String, String> params= {
      "leave_type_id": type.id.toString(),
      "start_date": DateFormat("yyyy-MM-dd").format(startDate).toString(),
      "end_date": DateFormat("yyyy-MM-dd").format(endDate).toString(),
      "reason": reason ?? '',
      "address": address ?? '',
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

    HttpModel response = await http.postMultipartRequest('leaves', params: params, files: files);    

    notifyListeners();
    return response;
  }

  /*  */
  Future<HttpModel> getTypes() async {
    try {
      HttpModel response = await http.get('leave_types');

      List<LeaveTypeModel> newTypes = [];
      for(var x in response.data) {
        newTypes.add(LeaveTypeModel.fromJson(x));
      }
      _types = newTypes;
      
      notifyListeners();
      return response;
    }
    catch(err) {
      _types = [];

      notifyListeners();
      rethrow;
    }
  }
}