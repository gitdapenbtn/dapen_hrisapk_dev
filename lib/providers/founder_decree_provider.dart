import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';
import 'package:dpbtn_absen/models/founder_decree_model.dart';

class FounderDecreeProvider with ChangeNotifier {
  final Http http = Http();

  FounderDecreeModel? _founderDecree;
  FounderDecreeModel? get founderDecree => _founderDecree;

  List<FounderDecreeModel> _founderDecrees = [];
  List<FounderDecreeModel> get founderDecrees => _founderDecrees;

  Future<HttpModel> getFounderDecrees({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('founder-decree', params);

      List<FounderDecreeModel> newFounderDecrees = [];

      for (var x in response.data) {
        newFounderDecrees.add(FounderDecreeModel.fromJson(x));
      }

      _founderDecrees = newFounderDecrees;

      notifyListeners();
      return response;
    } catch (err) {
      _founderDecrees = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findFounderDecreeById({required int id}) async {
    HttpModel response = await http.get('founder-decree/id/$id');

    _founderDecree = FounderDecreeModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
