import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/attendance_model.dart';
import 'package:dpbtn_absen/providers/profile_provider.dart';

class AttendanceProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Http http = Http();
  
  AttendanceModel? _attendance;
  AttendanceModel? get attendance => _attendance;

  List<AttendanceModel> _attendances = [];
  List<AttendanceModel> get attendances => _attendances;
  
  Future<HttpModel> getAttendances({ Map<String, dynamic>? params }) async {
    try {
      HttpModel response = await http.get('attendances', params);

      List<AttendanceModel> newAttendances = [];
      for(var x in response.data) {
        newAttendances.add(AttendanceModel.fromJson(x));
      }
      _attendances = newAttendances;
      
      notifyListeners();
      return response;
    }
    catch(err) {
      _attendances = [];
      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findAttendanceById({required int id}) async {
    HttpModel response = await http.get('attendances/id/$id');
    _attendance = AttendanceModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
  
  Future<HttpModel> postTimeIn({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note,
    String? date,
    bool sync=false,
  }) async {
    try {
      Map<String, String> params= {
        "date" : date ?? '',
        "time" : time,
        "latitude" : latitude,
        "longitude": longitude,
        "note": note ?? '', 
        "sync": sync.toString(),
      };

      List<MultipartFile> files = [];
      files.add(http.multipartFile(
          'image',
          photo.readAsBytes().asStream(), 
          photo.lengthSync(),
          'image',
        )
      );

      HttpModel response = await http.postMultipartRequest(
        'attendances/in',
        params: params, 
        files: files,
        showSnackBar: false,
      );

      ProfileProvider().setAttendanceIn(
        photo: photo,
        latitude: latitude,
        longitude: longitude,
        time: time,
        note: note,
      );
      
      notifyListeners();
      return response;
    } on SocketException {
      if(!sync) {
        await postTimeInLocal(photo: photo, latitude: latitude, longitude: longitude, time: time, note: note);
      }

      notifyListeners();
      return HttpModel(
        message: 'Berhasil absen masuk',
        status: false,
      );
    }
  }

  Future<HttpModel> postTimeOut({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note,
    String? date,
    bool sync=false,
  }) async {
    try {
      Map<String, String> params= {
        "date" : date ?? '',
        "time" : time,
        "latitude" : latitude,
        "longitude": longitude,
        "note": note ?? '', 
        "sync": sync.toString(),
      };

      List<MultipartFile> files = [];
      files.add(http.multipartFile(
          'image',
          photo.readAsBytes().asStream(), 
          photo.lengthSync(),
          'image',
        ));

      HttpModel response = await http.postMultipartRequest(
        'attendances/out',
        params: params, 
        files: files,
        showSnackBar: false,
      );
      
      await ProfileProvider().setAttendanceOut(
        photo: photo,
        latitude: latitude,
        longitude: longitude,
        time: time,
        note: note,
      );

      notifyListeners();
      return response;
    } on SocketException {
      if(!sync) {
        await postTimeOutLocal(photo: photo, latitude: latitude, longitude: longitude, time: time, note: note);
      }

      notifyListeners();
      return HttpModel(
        message: 'Berhasil absen pulang',
        status: false,
      );
    }
  }

  Future postTimeInLocal({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note,
  }) async {
    try {
      Map params= {
        "date": DateTime.now().toLocalId('yyyy-MM-dd'),
        "time" : time,
        "latitude" : latitude,
        "longitude": longitude,
        "note": note ?? '', 
        "photo": photo.path
      };
      
      String? localAttendances = await _secureStorage.read(key: 'inAttendances');
      List<dynamic> newLocalAttendances = [];
      if(localAttendances != null) {
        newLocalAttendances = json.decode(localAttendances);
        int existsAttendance = newLocalAttendances.indexWhere((e) => e['date'] == params['date']);
        if(existsAttendance == -1) {
          newLocalAttendances.add(params);
        } else {
          newLocalAttendances[existsAttendance] = params;
        }
      } else {
        newLocalAttendances.add(params);
      }

      await _secureStorage.write(key: 'inAttendances', value: json.encode(newLocalAttendances));
      await ProfileProvider().setAttendanceIn(
        photo: photo,
        latitude: latitude,
        longitude: longitude,
        time: time,
        note: note,
      );
    }
    catch(err) {
      rethrow;
    }
  }
  
  Future postTimeOutLocal({
    required File photo,
    required String latitude,
    required String longitude,
    required String time,
    String? note
  }) async {
    try {
      Map params= {
        "date": DateTime.now().toLocalId('yyyy-MM-dd'),
        "time" : time,
        "latitude" : latitude,
        "longitude": longitude,
        "note": note ?? '', 
        "photo": photo.path,
      };
      
      String? localAttendances = await _secureStorage.read(key: 'outAttendances');
      List<dynamic> newLocalAttendances = [];
      if(localAttendances != null) {
        newLocalAttendances = json.decode(localAttendances);
        int existsAttendance = newLocalAttendances.indexWhere((e) => e['date'] == params['date']);
        if(existsAttendance == -1) {
          newLocalAttendances.add(params);
        } else {
          newLocalAttendances[existsAttendance] = params;
        }
      } else {
        newLocalAttendances.add(params);
      }

      await _secureStorage.write(key: 'outAttendances', value: json.encode(newLocalAttendances));
      await ProfileProvider().setAttendanceOut(
        photo: photo,
        latitude: latitude,
        longitude: longitude,
        time: time,
        note: note,
      );
    }
    catch(err) {
      rethrow;
    }
  }

  Future sync() async {
    final String? localInAttendances = await _secureStorage.read(key: 'inAttendances');
    final String? localOutAttendances = await _secureStorage.read(key: 'outAttendances');

    if(localInAttendances != null && localInAttendances.isNotEmpty) {
      List localInAttendancesList = json.decode(localInAttendances);
      if(localInAttendancesList.isNotEmpty) {
        List removeLocalInAttendancesList = [];
        for(var x in localInAttendancesList) {
          try {
            HttpModel resp = await postTimeIn(
              date: x['date'],
              photo: File(x['photo']),
              latitude: x['latitude'], 
              longitude: x['longitude'], 
              time: x['time'],
              sync: true,
            );

            if(resp.status != false) {
              removeLocalInAttendancesList.add(x['date']);
            }
          }
          catch(err) {
            continue;
          }
        }
        localInAttendancesList.removeWhere((e) => removeLocalInAttendancesList.contains(e['date']));
        await _secureStorage.write(key: 'inAttendances', value: json.encode(localInAttendancesList));
      }
    }

    if(localOutAttendances != null) {
      final List localOutAttendancesList = json.decode(localOutAttendances);
      if(localOutAttendancesList.isNotEmpty) {
        List removeLocalOutAttendancesList = [];
        for(var x in localOutAttendancesList) {
          try {
            HttpModel resp = await postTimeOut(
              date: x['date'],
              photo: File(x['photo']), 
              latitude: x['latitude'], 
              longitude: x['longitude'], 
              time: x['time'],
              sync: true,
            );

            if(resp.status != false) {
              removeLocalOutAttendancesList.add(x['date']);
            }
          }
          catch(err) {
            continue;
          }
        }

        localOutAttendancesList.removeWhere((e) => removeLocalOutAttendancesList.contains(e['date']));
        await _secureStorage.write(key: 'outAttendances', value: json.encode(localOutAttendancesList));
      }
    }
  }
}