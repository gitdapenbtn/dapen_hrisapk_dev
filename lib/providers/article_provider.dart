import 'package:dpbtn_absen/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/libraries/http/http.dart';
import 'package:dpbtn_absen/libraries/http/http_model.dart';

class ArticleProvider with ChangeNotifier {
  final Http http = Http();

  ArticleModel? _article;
  ArticleModel? get article => _article;

  List<ArticleModel> _articles = [];
  List<ArticleModel> get articles => _articles;

  Future<HttpModel> getArticles({Map<String, dynamic>? params}) async {
    try {
      HttpModel response = await http.get('articles', params);

      List<ArticleModel> newArticles = [];
      for (var x in response.data) {
        newArticles.add(ArticleModel.fromJson(x));
      }
      _articles = newArticles;

      notifyListeners();
      return response;
    } catch (err) {
      _articles = [];

      notifyListeners();
      rethrow;
    }
  }

  Future<HttpModel> findArticleById({required int id}) async {
    HttpModel response = await http.get('articles/id/$id');
    _article = ArticleModel.fromJson(response.data);

    notifyListeners();
    return response;
  }
}
