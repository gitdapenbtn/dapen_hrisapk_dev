class AttendanceRequestStatusModel {
  final int id;
  final String name;
  final String? description;
  
  AttendanceRequestStatusModel({
    required this.id,
    required this.name,
    this.description,
  });

  factory AttendanceRequestStatusModel.fromJson(Map<String, dynamic> data) {
    return AttendanceRequestStatusModel(
      id: data['id'],
      name: data['status_name'],
      description: data['type_description'],
    );
  }
}