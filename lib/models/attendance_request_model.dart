import 'package:dpbtn_absen/models/approver_model.dart';
import 'package:dpbtn_absen/models/attachment_model.dart';
import 'package:dpbtn_absen/models/attendance_request_status_model.dart';
import 'package:dpbtn_absen/models/employee_model.dart';

class AttendanceRequestModel {
  final int id;
  final DateTime date;
  final String? timeIn;
  final String? timeOut;
  final String? note;
  final AttendanceRequestStatusModel status;
  final EmployeeModel? employee;
  final List<AttachmentModel>? attachments;
  final List<ApproverModel>? approvers;

  AttendanceRequestModel({
    required this.id,
    required this.date,
    this.timeIn,
    this.timeOut,
    required this.status,
    this.note,
    this.employee,
    this.attachments,
    this.approvers,
  });

  factory AttendanceRequestModel.fromJson(Map<String, dynamic> data) {
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

    return AttendanceRequestModel(
      id: data['id'],
      date: DateTime.parse(data['attendance_date']),
      timeIn: data['time_in'],
      timeOut: data['time_out'],
      note: data['note'],
      status: AttendanceRequestStatusModel.fromJson(data['status']),
      employee: data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
      approvers: approvers,
      attachments: attachments,
    );
  }
}
