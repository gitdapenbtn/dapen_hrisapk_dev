import 'package:flutter/material.dart';
import 'package:dpbtn_absen/helpers/snackbar.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';

class AppProvider with ChangeNotifier {
  final Http http = Http();

  bool _hasCheckConnection = false;
  bool get hasCheckConnection => _hasCheckConnection;

  bool _isOffline = false;
  bool get isOffline => _isOffline;

  Future<bool> checkConnection() async {
    try {
      _hasCheckConnection = true;
      await http.get('profile', null, false);
      _isOffline = false;

      notifyListeners();
      return true;
    } catch (err) {
      _isOffline = true;

      showSnackBarAnywhere('Offline Mode', width: 200);

      notifyListeners();
      return false;
    }
  }
}
