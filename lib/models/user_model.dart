import 'package:dpbtn_absen/models/employee_model.dart';

class UserModel {
  final int? id;
  final String name;
  final String email;
  final int? userGroupId;
  final EmployeeModel? employee;
  final bool guidelineAccess;
  final bool circularLetterAccess;
  final bool approvalAccess;

  UserModel({
    this.id,
    required this.name,
    required this.email,
    this.userGroupId,
    this.employee,
    this.guidelineAccess = false,
    this.circularLetterAccess = false,
    this.approvalAccess = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> data) {
    final String modules = data['user_group']['modules'].toString();

    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      userGroupId: data['user_group_id'],
      employee: data['employee'] != null
          ? EmployeeModel.fromJson(data['employee'])
          : null,
      approvalAccess: modules.contains('permit-update') ||
          modules.contains('leave-update') ||
          modules.contains('attendance-request-update'),
      circularLetterAccess: modules.contains('circular-letter-view'),
      guidelineAccess: modules.contains('guideline-view'),
    );
  }
}
