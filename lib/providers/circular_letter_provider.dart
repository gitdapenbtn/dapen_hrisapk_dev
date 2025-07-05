import 'package:dpbtn_absen/models/circular_letter_model.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';

class CircularLetterProvider with ChangeNotifier {
  final Http http = Http();

  CircularLetterModel? _guideline;
  CircularLetterModel? get guideline => _guideline;

  List<CircularLetterModel> _guidelines = [];
  List<CircularLetterModel> get guidelines => _guidelines;

  Future<HttpModel> getCircularLetters({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('circular-letters', params);

      List<CircularLetterModel> newCircularLetters = [];
      for (var x in response.data) {
        newCircularLetters.add(CircularLetterModel.fromJson(x));
      }
      _guidelines = newCircularLetters;

      notifyListeners();
      return response;
    } catch (err) {
      _guidelines = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findCircularLetterById({required int id}) async {
    HttpModel response = await http.get('circular-letters/id/$id');
    _guideline = CircularLetterModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
