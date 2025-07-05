import 'dart:convert';

class HttpModel {
  final String? message;
  final dynamic data;
  final dynamic errors;
  final bool? status;

  HttpModel({
    this.message,
    this.data,
    this.status,
    this.errors,
  });

  factory HttpModel.fromResponseBody(String body) {
    Map<String, dynamic> resp = json.decode(body);
    
    return HttpModel(
      message: resp['message'],
      data: resp['data'],
      errors: resp['errors'],
    );
  }
}