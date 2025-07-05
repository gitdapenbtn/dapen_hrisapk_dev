import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/configs/app.dart';
import 'package:http/http.dart' as http;
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/libraries/http/http_exceptions.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
export 'package:http/http.dart';

class Http {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late Uri _uri;
  late String? _baseUrl;
  final String _baseUrlPrefix = "/api";
  late String? _accessToken;
  late Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '',
    'Device-ID': '',
    'Device-Type': 'mobile'
  };

  final String sockeExceptionMessage = 'Silahkan cek koneksi internet kamu.';

  getBaseUrl() async {
    _baseUrl = await storage.read(key: 'base_url');
    _baseUrl = _baseUrl ?? api['url_default'];
    return _baseUrl;
  }

  setBaseUrl(String baseUrl) async {
    if (baseUrl.endsWith('/')) {
      baseUrl = baseUrl.substring(0, baseUrl.length - 1);
    }
    await storage.write(key: 'base_url', value: baseUrl);
  }

  resetBaseUrl() async {
    await storage.delete(key: 'base_url');
  }

  getAccessToken() async {
    _accessToken = await storage.read(key: 'access_token');
    headers['Authorization'] = 'Bearer $_accessToken';

    return _accessToken;
  }

  setAccessToken(String accessToken) async {
    await storage.write(key: 'access_token', value: accessToken);
  }

  removeAccessToken() async {
    await storage.delete(key: 'access_token');
    headers['Authorization'] = 'Bearer ';
  }

  getUri(String path, [Map<String, dynamic>? params]) async {
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    _uri = Uri.parse('$_baseUrl$_baseUrlPrefix$path')
        .replace(queryParameters: params);
    return _uri;
  }

  getDeviceId() async {
    String? deviceId = await storage.read(key: 'deviceId');
    headers['Device-ID'] = deviceId ?? '';
  }

  getApiUrl(String path, [Map<String, dynamic>? params]) async {
    await getBaseUrl();
    await getAccessToken();
    await getDeviceId();
    await getUri(path, params);

    return _uri;
  }

  response({String? body, int? statusCode}) {
    HttpModel response = HttpModel.fromResponseBody(body!);

    switch (statusCode) {
      case 422:
        throw InvalidInputException(response.message);
      case 400:
        throw BadRequestException(response.message);
      case 404:
        throw NotFoundException(response.message);
      case 405:
        throw NotFoundException(response.message);
      case 500:
        throw InternalServerErrorException(response.message);
      case 401:
        removeAccessToken();
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (route) => loginScreen),
            (route) => false);
        throw UnauthorizedException(response.message);
      case 403:
        removeAccessToken();
        Navigator.pushAndRemoveUntil(
            navigatorKey.currentContext!,
            MaterialPageRoute(builder: (route) => loginScreen),
            (route) => false);
        throw UnauthorizedException(response.message);
      default:
        return response;
    }
  }

  Future<HttpModel> get(String path,
      [Map<String, dynamic>? params, bool showSnackBar = true]) async {
    try {
      await getBaseUrl();
      await getAccessToken();
      await getDeviceId();
      await getUri(path, params);

      http.Response resp = await http.get(_uri, headers: headers);

      return response(body: resp.body, statusCode: resp.statusCode);
    } on SocketException {
      if (showSnackBar) {
        showSnackBarAnywhere(sockeExceptionMessage);
      }
      rethrow;
    }
  }

  Future<HttpModel> post(String path,
      [Map<String, dynamic>? params, bool showSnackBar = true]) async {
    try {
      await getBaseUrl();
      await getAccessToken();
      await getDeviceId();
      await getUri(path);

      http.Response resp =
          await http.post(_uri, body: json.encode(params), headers: headers);

      return response(body: resp.body, statusCode: resp.statusCode);
    } on SocketException {
      if (showSnackBar) {
        showSnackBarAnywhere(sockeExceptionMessage);
      }
      rethrow;
    }
  }

  Future<HttpModel> put(String path,
      [Map<String, dynamic>? params, bool showSnackBar = true]) async {
    try {
      await getBaseUrl();
      await getAccessToken();
      await getDeviceId();
      await getUri(path);

      http.Response resp =
          await http.put(_uri, body: json.encode(params), headers: headers);

      return response(body: resp.body, statusCode: resp.statusCode);
    } on SocketException {
      if (showSnackBar) {
        showSnackBarAnywhere(sockeExceptionMessage);
      }
      rethrow;
    }
  }

  Future<HttpModel> delete(String path) async {
    try {
      await getBaseUrl();
      await getAccessToken();
      await getDeviceId();
      await getUri(path);

      http.Response resp = await http.delete(_uri, headers: headers);

      return response(body: resp.body, statusCode: resp.statusCode);
    } on SocketException {
      showSnackBarAnywhere(sockeExceptionMessage);
      rethrow;
    }
  }

  Future<HttpModel> postMultipartRequest(String path,
      {Map<String, String>? params,
      List<http.MultipartFile>? files,
      bool showSnackBar = true}) async {
    try {
      await getBaseUrl();
      await getAccessToken();
      await getDeviceId();
      await getUri(path);

      var request = http.MultipartRequest("POST", _uri);

      /* Set Headers */
      headers['Content-Type'] = 'multipart/form-data';
      request.headers.addAll(headers);

      /* Set Files */
      if (files != null) {
        for (var file in files) {
          request.files.add(file);
        }
      }

      /* Set Fields */
      if (params != null) {
        request.fields.addAll(params);
      }

      http.StreamedResponse resp = await request.send();
      String respBody = await resp.stream.bytesToString();

      return response(body: respBody, statusCode: resp.statusCode);
    } on SocketException {
      if (showSnackBar) {
        showSnackBarAnywhere(sockeExceptionMessage);
      }
      rethrow;
    }
  }

  http.MultipartFile multipartFile(
      String requestName, file, fileLength, filename) {
    return http.MultipartFile(
      requestName,
      file,
      fileLength,
      filename: filename,
    );
  }
}
