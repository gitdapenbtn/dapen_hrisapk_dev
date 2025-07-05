import 'package:dpbtn_absen/models/guideline_model.dart';
import 'package:dpbtn_absen/providers/guideline_provider.dart';
import 'package:dpbtn_absen/screens/guideline/guideline_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GuidelineListScreen extends StatefulWidget {
  final int organizationId;
  final String organizationName;
  const GuidelineListScreen({
    super.key,
    required this.organizationId,
    required this.organizationName,
  });

  @override
  State<GuidelineListScreen> createState() => _GuidelineListScreenState();
}

class _GuidelineListScreenState extends State<GuidelineListScreen> {
  late GuidelineProvider _guidelineProvider;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _onRefresh();
  }

  @override
  @protected
  @mustCallSuper
  void didChangeDependencies() {
    super.didChangeDependencies();
    _guidelineProvider = Provider.of<GuidelineProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(seconds: 1), () async {
      Map<String, dynamic> params = {
        "employee_organization_id": widget.organizationId.toString(),
      };

      _guidelineProvider.getGuidelines(params: params).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      onRefresh: _onRefresh,
      isLoading: _isLoading,
      appBar: const LayoutAppBar(
        title: 'Dokumen Pedoman',
      ),
      child: Column(
        children: [
          _listView(_guidelineProvider.guidelines),
        ],
      ),
    );
  }

  Widget _listView(List<GuidelineModel> guidelines) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: guidelines.length,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (ctx, i) {
        String lastReviewAt = DateFormat('dd MMMM yyyy')
            .format(guidelines[i].lastReviewAt)
            .toString();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GuidelinePdfScreen(
                  title: guidelines[i].title,
                  url: guidelines[i].file,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            guidelines[i].letterNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            guidelines[i].title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
                const Divider(),
                Text(
                  'Terakhir Di Review : $lastReviewAt',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
