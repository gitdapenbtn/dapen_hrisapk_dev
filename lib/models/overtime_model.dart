import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/employee_model.dart';
import 'package:dpbtn_absen/models/overtime_status_model.dart';
import 'package:dpbtn_absen/models/overtime_type_model.dart';

class OvertimeModel {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;
  final OvertimeTypeModel type;
  final OvertimeStatusModel status;
  final EmployeeModel? employee;
  final List<AttachmentModel>? attachments;
  final List<ApproverModel>? approvers;
  
  OvertimeModel({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.status,
    this.reason,
    this.employee,
    this.attachments,
    this.approvers,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic> data) {

    List<ApproverModel> approvers = [];
    if(data['approvals'] != null) {
      if(data['approvals'].length > 0) {
        for(var x in data['approvals']) {
          approvers.add(ApproverModel.fromJson(x));
        }
      }
    }

    List<AttachmentModel> attachments = [];
    if(data['attachments'] != null) {
      if(data['attachments'].length > 0) {
        for(var x in data['attachments']) {
          attachments.add(AttachmentModel.fromJson(x));
        }
      }
    }

    return OvertimeModel(
      id: data['id'],
      startDate: DateTime.parse(data['start_overtime']),
      endDate: DateTime.parse(data['end_overtime']),
      type: OvertimeTypeModel.fromJson(data['overtime_type']),
      status: OvertimeStatusModel.fromJson(data['status']),
      employee: data['employee'] != null
        ? EmployeeModel.fromJson(data['employee'])
        : null,
      approvers: approvers,
      attachments: attachments,
    );
  }
}