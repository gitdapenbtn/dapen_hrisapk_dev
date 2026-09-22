import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/employee_model.dart';

class ApprovalModel {
  final int id;
  final String type;
  final String? typeDetail;
  final String date;
  final String status;
  final String? reason;
  final int? isApproved;
  final List<AttachmentModel> attachments;
  final EmployeeModel? employee;
  final List<ApproverModel>? approvers;

  ApprovalModel({
    required this.id,
    required this.type,
    this.typeDetail,
    required this.date,
    this.reason,
    required this.status,
    this.isApproved,
    required this.attachments,
    this.employee,
    this.approvers,
  });

  factory ApprovalModel.fromJson(Map<String, dynamic> data) {
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

    return ApprovalModel(
      id: data['id'],
      type: data['type'],
      typeDetail: data['type_detail'],
      date: data['date'],
      reason: data['reason'],
      status: data['status'],
      isApproved: data['is_approved'],
      employee: data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
      attachments: attachments,
    );
  }
}
