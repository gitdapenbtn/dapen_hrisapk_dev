import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/permit_model.dart';
import 'package:dpbtn_absen/models/permit_type_model.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class PermitProvider with ChangeNotifier {
  final Http http = Http();

  PermitModel? _permit;
  PermitModel? get permit => _permit;

  List<PermitModel> _permits = [];
  List<PermitModel> get permits => _permits;

  List<PermitTypeModel> _types = [];
  List<PermitTypeModel> get types => _types;

  Future<HttpModel> getPermits({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('permits', params);

      List<PermitModel> newPermits = [];
      for (var x in response.data) {
        newPermits.add(PermitModel.fromJson(x));
      }
      _permits = newPermits;

      notifyListeners();
      return response;
    } catch (err) {
      _permits = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findPermitById({required int id}) async {
    HttpModel response = await http.get('permits/id/$id');
    _permit = PermitModel.fromJson(response.data);

    notifyListeners();
    return response;
  }

  Future<HttpModel> create({
    required PermitTypeModel type,
    required DateTime startDate,
    required DateTime endDate,
    String? reason,
    List<File>? attachments,
  }) async {
    Map<String, String> params = {
      "permit_type_id": type.id.toString(),
      "start_date": DateFormat("yyyy-MM-dd").format(startDate).toString(),
      "end_date": DateFormat("yyyy-MM-dd").format(endDate).toString(),
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
      'permits',
      params: params,
      files: files,
    );

    notifyListeners();
    return response;
  }

  /*  */
  Future<HttpModel> getTypes() async {
    try {
      HttpModel response = await http.get('permit_types');

      List<PermitTypeModel> newTypes = [];
      for (var x in response.data) {
        newTypes.add(PermitTypeModel.fromJson(x));
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
