import 'package:dpbtn_absen/components/section_title.dart';
import 'package:dpbtn_absen/models/article_model.dart';
import 'package:dpbtn_absen/providers/article_provider.dart';
import 'package:dpbtn_absen/screens/article/article_detail_screen.dart';
import 'package:dpbtn_absen/screens/article/article_screen.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/section.dart';
import 'package:provider/provider.dart';

class ArticleSection extends StatefulWidget {
  const ArticleSection({super.key});

  @override
  State<ArticleSection> createState() => _ArticleSectionState();
}

class _ArticleSectionState extends State<ArticleSection> {
  late ArticleProvider _articleProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _articleProvider = Provider.of<ArticleProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    double cardHeight = 220;
    double cardWidth = MediaQuery.of(context).size.width * .6;
    double cardBorderRadius = 10;
    double imgHeight = cardHeight * .6;

    return Column(
      children: [
        SectionTitle(
          'Berita Terbaru',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ArticleScreen(),
              ),
            );
          },
        ),
        const SizedBox(height: 10),
        Visibility(
          visible: (_articleProvider.articles.isNotEmpty),
          child: Section(
            fullWidth: true,
            child: SizedBox(
              height: cardHeight,
              child: ListView.separated(
                separatorBuilder: (_, i) {
                  return const SizedBox(width: 20);
                },
                shrinkWrap: true,
                itemCount: _articleProvider.articles.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemBuilder: (ctx, i) {
                  final ArticleModel article = _articleProvider.articles[i];

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ArticleDetailScreen(article: article),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        width: cardWidth,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(cardBorderRadius),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(0, 2),
                              color: Colors.black12,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: imgHeight,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(cardBorderRadius),
                                  topRight: Radius.circular(cardBorderRadius),
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(article.featuredImage),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                top: 12,
                                bottom: 10,
                                left: 10,
                                right: 20,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    article.title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    article.description ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Visibility(
          visible: _articleProvider.articles.isEmpty,
          child: Section(
            child: DottedBorder(
              options: OvalDottedBorderOptions(
                color: Colors.black38,
                dashPattern: const [10, 6],
              ),
              child: Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.center,
                width: double.infinity,
                child: const Text('Belum ada berita'),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
