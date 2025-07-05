import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Http http = Http();

  Future<HttpModel> login({
    required String email,
    required String password,
    String? server,
  }) async {
    String? fcmRegistrationId = await _secureStorage.read(key: 'fcm_registration_id');
    
    await http.resetBaseUrl();
    if(server != null) {
      if(server != '') {
        await http.setBaseUrl(server);
      }
    }

    Map<String, dynamic> params = {
      'email': email,
      'password': password,
      'fcm_registration_id': fcmRegistrationId,
    };

    HttpModel response = await http.post('auth/login', params);
    await http.setAccessToken(response.data['access_token']);
    await ProfileProvider().getProfile();

    return response;
  }

  Future<HttpModel> forgotPassword(String email) async {
    Map<String, dynamic> params = {
      'email': email,
    };

    HttpModel response = await http.post('auth/forgot_password', params);
    return response;
  }

  Future<HttpModel> resetPassword({
    required String email,
    required String newPassword,
    required String newPasswordConfirmation,
    required String verificationCode,
  }) async {
    Map<String, dynamic> params = {
      'email': email,
      'new_password': newPassword,
      'new_password_confirmation': newPasswordConfirmation,
      'verification_code': verificationCode
    };

    HttpModel response = await http.post('auth/reset_password', params);
    return response;
  }

  Future<HttpModel> logout() async {
    HttpModel response = await http.delete('auth/logout');
    await http.removeAccessToken();

    await _secureStorage.delete(key: 'todayAttendance');
    await _secureStorage.delete(key: 'inAttendances');
    await _secureStorage.delete(key: 'outAttendances');

    return response;
  }
}