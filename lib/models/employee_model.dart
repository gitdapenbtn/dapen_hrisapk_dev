import 'package:dpbtn_absen/models/employee_organization_model.dart';
import 'package:dpbtn_absen/models/employee_position_model.dart';
import 'package:dpbtn_absen/models/gender_model.dart';

class EmployeeModel {
  final int? id;
  final String name;
  final String email;
  final String? registrationNumber;
  final String? religion;
  final String? birthday;
  final String? address;
  final String? joinDate;
  final GenderModel? gender;
  final EmployeeOrganizationModel? organization;
  final EmployeePosition? position;

  EmployeeModel({
    this.id,
    required this.name,
    required this.email,
    this.gender,
    this.organization,
    this.position,
    this.religion,
    this.registrationNumber,
    this.birthday,
    this.address,
    this.joinDate,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> data) {
    return EmployeeModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      address: data['address'],
      birthday: data['date_of_birth'],
      joinDate: data['join_date'],
      registrationNumber: data['registration_number'],
      religion: data['religion'],
      gender:
          data['gender'] != null ? GenderModel.fromJson(data['gender']) : null,
      organization: data['employee_organization'] != null
          ? EmployeeOrganizationModel.fromJson(data['employee_organization'])
          : null,
      position: data['employee_position'] != null
          ? EmployeePosition.fromJson(data['employee_position'])
          : null,
    );
  }
}
