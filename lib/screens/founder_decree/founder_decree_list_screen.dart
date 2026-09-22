import 'package:dpbtn_absen/models/founder_decree_model.dart';
import 'package:dpbtn_absen/providers/founder_decree_provider.dart';
import 'package:dpbtn_absen/screens/founder_decree/founder_decree_pdf_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class FounderDecreeListScreen extends StatefulWidget {
  final int organizationId;
  final String organizationName;

  const FounderDecreeListScreen({
    super.key,
    required this.organizationId,
    required this.organizationName,
  });

  @override
  State<FounderDecreeListScreen> createState() =>
      _FounderDecreeListScreenState();
}

class _FounderDecreeListScreenState extends State<FounderDecreeListScreen> {
  late FounderDecreeProvider _founderDecreeProvider;
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

    _founderDecreeProvider = Provider.of<FounderDecreeProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(seconds: 1), () async {
      Map<String, dynamic> params = {
        "employee_organization_id": widget.organizationId.toString(),
      };

      _founderDecreeProvider.getFounderDecrees(params: params).whenComplete(() {
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
      appBar: const LayoutAppBar(title: 'Ketetapan Pendiri'),
      child: Column(
        children: [_listView(_founderDecreeProvider.founderDecrees)],
      ),
    );
  }

  Widget _listView(List<FounderDecreeModel> founderDecrees) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: founderDecrees.length,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      itemBuilder: (ctx, i) {
        String lastReviewAt = DateFormat(
          'dd MMMM yyyy',
        ).format(founderDecrees[i].lastReviewAt);

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FounderDecreePdfScreen(
                  title: founderDecrees[i].title,
                  url: founderDecrees[i].file,
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
                ),
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
                            founderDecrees[i].letterNumber,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            founderDecrees[i].title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
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
                  style: const TextStyle(color: Colors.black45, fontSize: 12),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
