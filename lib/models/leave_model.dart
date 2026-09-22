import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/employee_model.dart';
import 'package:dpbtn_absen/models/leave_status_model.dart';
import 'package:dpbtn_absen/models/leave_type_model.dart';

class LeaveModel {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String? reason;
  final LeaveTypeModel type;
  final LeaveStatusModel status;
  final EmployeeModel? employee;
  final List<AttachmentModel>? attachments;
  final List<ApproverModel>? approvers;

  LeaveModel({
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

  factory LeaveModel.fromJson(Map<String, dynamic> data) {
    List<ApproverModel> approvers = [];
    if (data['approvals'] != null) {
      if (data['approvals'].length > 0) {
        for (var x in data['approvals']) {
          approvers.add(ApproverModel.fromJson(x));
        }
      }
    }

    List<AttachmentModel> attachments = [];
    if (data['attachments'] != null) {
      if (data['attachments'].length > 0) {
        for (var x in data['attachments']) {
          attachments.add(AttachmentModel.fromJson(x));
        }
      }
    }

    return LeaveModel(
      id: data['id'],
      startDate: DateTime.parse(data['start_date']),
      endDate: DateTime.parse(data['end_date']),
      type: LeaveTypeModel.fromJson(data['leave_type']),
      status: LeaveStatusModel.fromJson(data['status']),
      employee: data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
      approvers: approvers,
      attachments: attachments,
      reason: data['reason'],
    );
  }
}
