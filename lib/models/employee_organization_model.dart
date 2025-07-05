class EmployeeOrganizationModel {
  final int? id;
  final String name;
  final String? description;

  EmployeeOrganizationModel({
    this.id,
    required this.name,
    this.description,
  });

  factory EmployeeOrganizationModel.fromJson(Map<String, dynamic> data) {
    return EmployeeOrganizationModel(
      id: data['id'],
      name: data['organization_name'],
      description: data['organization_description'],
    );
  }
}
