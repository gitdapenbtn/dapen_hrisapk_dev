import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/article_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleDetailScreen extends StatefulWidget {
  final ArticleModel article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      appBar: const LayoutAppBar(title: 'Berita'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(widget.article.featuredImage),
          const SizedBox(height: 20),
          Text(
            widget.article.title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Html(
            shrinkWrap: true,
            onLinkTap: ((url, attributes, element) async {
              if (url != null) {
                final Uri uri = Uri.parse(url);
                if (!await launchUrl(uri)) {
                  throw Exception('Could not launch $uri');
                }
              }
            }),
            data: widget.article.content,
          ),
        ],
      ),
    );
  }
}
