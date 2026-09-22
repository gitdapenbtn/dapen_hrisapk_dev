import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/decision_letter_model.dart';

class DecisionLetterProvider with ChangeNotifier {
  final Http http = Http();

  DecisionLetterModel? _decisionLetter;
  DecisionLetterModel? get decisionLetter => _decisionLetter;

  List<DecisionLetterModel> _decisionLetters = [];
  List<DecisionLetterModel> get decisionLetters => _decisionLetters;

  Future<HttpModel> getDecisionLetters({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('decision-letter', params);

      List<DecisionLetterModel> newDecisionLetters = [];

      for (var x in response.data) {
        newDecisionLetters.add(DecisionLetterModel.fromJson(x));
      }

      _decisionLetters = newDecisionLetters;

      notifyListeners();
      return response;
    } catch (err) {
      _decisionLetters = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findDecisionLetterById({required int id}) async {
    HttpModel response = await http.get('decision-letter/id/$id');

    _decisionLetter = DecisionLetterModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
