class PermitTypeModel {
  final int id;
  final String name;
  final String? code;
  final String? description;
  final bool withTime;

  PermitTypeModel({
    required this.id,
    required this.name,
    this.code,
    this.description,
    this.withTime = false,
  });

  factory PermitTypeModel.fromJson(Map<String, dynamic> data) {
    return PermitTypeModel(
      id: data['id'],
      name: data['type_name'],
      code: data['type_code'],
      description: data['type_description'],
      withTime: data['with_time'],
    );
  }
}
