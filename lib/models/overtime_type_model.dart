class OvertimeTypeModel {
  final int id;
  final String name;
  final String? code;
  final String? description;
  
  OvertimeTypeModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
  });

  factory OvertimeTypeModel.fromJson(Map<String, dynamic> data) {
    return OvertimeTypeModel(
      id: data['id'],
      name: data['type_name'],
      code: data['type_code'],
      description: data['type_description'],
    );
  }
}