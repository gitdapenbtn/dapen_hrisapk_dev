import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/attendance_model.dart';
import 'package:dpbtn_absen/models/attendance_summary_model.dart';
import 'package:dpbtn_absen/models/leave_type_model.dart';
import 'package:dpbtn_absen/models/user_model.dart';

class ProfileProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Http http = Http();

  UserModel? _profile;
  UserModel? get profile => _profile;

  AttendanceModel _attendance = AttendanceModel(id: 0, date: DateTime.now());
  AttendanceModel get attendance => _attendance;

  AttendanceSummaryModel _attendanceSummary = AttendanceSummaryModel();
  AttendanceSummaryModel get attendanceSummary => _attendanceSummary;

  List<LeaveTypeModel> _leaveQuotas = [];
  List<LeaveTypeModel> get leaveQuotas => _leaveQuotas;

  Future<HttpModel> getProfile() async {
    HttpModel response = await http.get('profile', null, false);
    _profile = UserModel.fromJson(response.data);
    await _secureStorage.write(key: 'user', value: json.encode(response.data));

    notifyListeners();
    return response;
  }

  Future getLocalProfile() async {
    final String? localProfile = await _secureStorage.read(key: 'user');
    _profile = UserModel.fromJson(json.decode(localProfile!));

    notifyListeners();
  }

  Future<HttpModel> changePassword({
    required String oldPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    Map<String, dynamic> params = {
      "old_password": oldPassword,
      "new_password": newPassword,
      "new_password_confirmation": newPasswordConfirmation,
    };

    HttpModel response = await http.put('profile/password', params);

    notifyListeners();
    return response;
  }

  Future getAttendanceToday() async {
    try {
      HttpModel response = await http.get(
        'profile/attendance_today',
        null,
        false,
      );
      if (response.data != null) {
        _attendance = AttendanceModel.fromJson(response.data);
        await _secureStorage.write(
          key: 'todayAttendance',
          value: json.encode(_attendance.toMap()),
        );
      }
    } catch (err) {
      await getLocalAttendanceToday();
    }

    notifyListeners();
  }

  Future<HttpModel> getLeaveQuotas({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('profile/leave_quota', params);

      List<LeaveTypeModel> newLeaveQuotas = [];
      for (var x in response.data) {
        newLeaveQuotas.add(LeaveTypeModel.fromJson(x));
      }
      _leaveQuotas = newLeaveQuotas;

      notifyListeners();
      return response;
    } catch (err) {
      _leaveQuotas = [];
      notifyListeners();
      rethrow;
    }
  }

  Future getLocalAttendanceToday() async {
    final DateTime dateNow = DateTime.now();
    final String? todayAttendance = await _secureStorage.read(
      key: 'todayAttendance',
    );

    AttendanceModel newAttendance = AttendanceModel(id: 0, date: dateNow);
    if (todayAttendance != null && todayAttendance.isNotEmpty) {
      AttendanceModel newTodayAttendance = AttendanceModel.fromJson(
        json.decode(todayAttendance),
      );
      if (newTodayAttendance.date.toLocalId('yyyy-MM-dd').toString() ==
          newAttendance.date.toLocalId('yyyy-MM-dd').toString()) {
        newAttendance = newTodayAttendance;
      }
    }

    _attendance = newAttendance;
    await _secureStorage.write(
      key: 'todayAttendance',
      value: json.encode(newAttendance.toMap()),
    );

    notifyListeners();
  }

  Future<HttpModel> getLeaveQuota({Map<String, dynamic>? params}) async {
    HttpModel response = await http.get('attendances/summary', params);
    if (response.data != null) {
      _attendanceSummary = AttendanceSummaryModel.fromJson(response.data);
    }

    notifyListeners();
    return response;
  }

  Future<HttpModel> getAttendanceSummary({Map<String, dynamic>? params}) async {
    HttpModel response = await http.get('attendances/summary', params, false);
    if (response.data != null) {
      _attendanceSummary = AttendanceSummaryModel.fromJson(response.data);
    }

    notifyListeners();
    return response;
  }

  Future setAttendanceIn({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note,
  }) async {
    String? localTodayAttendace = await _secureStorage.read(
      key: 'todayAttendance',
    );

    if (localTodayAttendace != null && localTodayAttendace.isNotEmpty) {
      AttendanceModel todayAttendance = AttendanceModel.fromJson(
        json.decode(localTodayAttendace),
      );
      todayAttendance = todayAttendance.updateWith(
        timeIn: time,
        latitudeIn: latitude,
        longitudeIn: longitude,
        imageIn: photo.path,
        noteIn: note,
      );

      _attendance = todayAttendance;
      await _secureStorage.write(
        key: 'todayAttendance',
        value: json.encode(todayAttendance.toMap()),
      );
    }

    notifyListeners();
  }

  Future setAttendanceOut({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note,
  }) async {
    String? localTodayAttendace = await _secureStorage.read(
      key: 'todayAttendance',
    );

    if (localTodayAttendace != null && localTodayAttendace.isNotEmpty) {
      AttendanceModel todayAttendance = AttendanceModel.fromJson(
        json.decode(localTodayAttendace),
      );
      todayAttendance = todayAttendance.updateWith(
        timeOut: time,
        latitudeOut: latitude,
        longitudeOut: longitude,
        imageOut: photo.path,
        noteOut: note,
      );

      _attendance = todayAttendance;
      await _secureStorage.write(
        key: 'todayAttendance',
        value: json.encode(todayAttendance.toMap()),
      );
    }

    notifyListeners();
  }
}
