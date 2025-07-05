class EmployeePosition {
  final int? id;
  final String name;
  final String? description;
  
  EmployeePosition({
    this.id,
    required this.name,
    this.description,
  });

  factory EmployeePosition.fromJson(Map<String, dynamic> data) {
    return EmployeePosition(
      id: data['id'],
      name: data['position_name'],
      description: data['position_description'],
    );
  }
}