class AttachmentModel {
  final String name;
  final String file;
  
  AttachmentModel({
    required this.name,
    required this.file,
  });

  factory AttachmentModel.fromJson(Map<String, dynamic> data) {
    return AttachmentModel(
      name: data['attachment_name'],
      file: data['attachment_file'],
    );
  }
}