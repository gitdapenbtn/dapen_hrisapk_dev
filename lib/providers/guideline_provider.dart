import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/guideline_model.dart';

class GuidelineProvider with ChangeNotifier {
  final Http http = Http();

  GuidelineModel? _guideline;
  GuidelineModel? get guideline => _guideline;

  List<GuidelineModel> _guidelines = [];
  List<GuidelineModel> get guidelines => _guidelines;

  Future<HttpModel> getGuidelines({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('guidelines', params);

      List<GuidelineModel> newGuidelines = [];
      for (var x in response.data) {
        newGuidelines.add(GuidelineModel.fromJson(x));
      }
      _guidelines = newGuidelines;

      notifyListeners();
      return response;
    } catch (err) {
      _guidelines = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findGuidelineById({required int id}) async {
    HttpModel response = await http.get('guidelines/id/$id');
    _guideline = GuidelineModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
