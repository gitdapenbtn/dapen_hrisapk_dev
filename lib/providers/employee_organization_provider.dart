import 'package:dpbtn_absen/models/employee_organization_model.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';

class EmployeeOrganizationProvider with ChangeNotifier {
  final Http http = Http();

  EmployeeOrganizationModel? _employeeOrganization;
  EmployeeOrganizationModel? get employeeOrganization => _employeeOrganization;

  List<EmployeeOrganizationModel> _employeeOrganizations = [];
  List<EmployeeOrganizationModel> get employeeOrganizations =>
      _employeeOrganizations;

  Future<HttpModel> getEmployeeOrganizations(
      {Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('employee_organizations', params);

      List<EmployeeOrganizationModel> newEmployeeOrganizations = [];
      for (var x in response.data) {
        newEmployeeOrganizations.add(EmployeeOrganizationModel.fromJson(x));
      }
      _employeeOrganizations = newEmployeeOrganizations;

      notifyListeners();
      return response;
    } catch (err) {
      _employeeOrganizations = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findEmployeeOrganizationById({required int id}) async {
    HttpModel response = await http.get('employee_organizations/id/$id');
    _employeeOrganization = EmployeeOrganizationModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
