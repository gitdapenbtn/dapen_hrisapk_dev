import 'package:dpbtn_absen/models/approval_model.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';

class ApprovalProvider with ChangeNotifier {
  final Http http = Http();
  
  ApprovalModel? _approval;
  ApprovalModel? get approval => _approval;

  List<ApprovalModel> _approvals = [];
  List<ApprovalModel> get approvals => _approvals;
  
  Future<HttpModel> getApprovals({ Map<String, dynamic>? params }) async {
    try {
      HttpModel response = await http.get('approvals', params);

      List<ApprovalModel> newApprovals = [];
      for(var x in response.data) {
        newApprovals.add(ApprovalModel.fromJson(x));
      }
      _approvals = newApprovals;
      
      notifyListeners();
      return response;
    }
    catch(err) {
      _approvals = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findApprovalById(ApprovalModel approvalModel) async {
    HttpModel response = await http.get('approvals/${approvalModel.type}/${approvalModel.id}');
    _approval = ApprovalModel.fromJson(response.data);

    notifyListeners();
    return response;
  }

  Future<HttpModel> approve(ApprovalModel approvalModel) async {
    Map<String, dynamic> params = {
      'id': approvalModel.id,
      'type': approvalModel.type,
    };

    HttpModel response = await http.post('approvals/approve', params);

    notifyListeners();
    return response;
  }

  Future<HttpModel> reject(ApprovalModel approvalModel) async {
    Map<String, dynamic> params = {
      'id': approvalModel.id,
      'type': approvalModel.type,
    };

    HttpModel response = await http.post('approvals/reject', params);

    notifyListeners();
    return response;
  }
}