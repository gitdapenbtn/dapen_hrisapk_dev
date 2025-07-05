import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/range_date_input.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/permit_model.dart';
import 'package:dpbtn_absen/providers/permit_provider.dart';
import 'package:dpbtn_absen/screens/permit/permit_detail_screen.dart';
import 'package:dpbtn_absen/screens/permit/permit_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class PermitScreen extends StatefulWidget {
  const PermitScreen({ super.key });

  @override
  State<PermitScreen> createState() => _PermitScreenState();
}

class _PermitScreenState extends State<PermitScreen> {
  late PermitProvider _permitProvider;
  DateTimeRange _period = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 7)),
    end: DateTime.now(),
  );
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
    _permitProvider = Provider.of<PermitProvider>(context);
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(seconds: 1), () async {
      Map<String, dynamic> params = {
        "mine": true.toString(),
        "start_date": _period.start.toLocalId("yyyy-MM-dd"),
        "end_date": _period.end.toLocalId("yyyy-MM-dd"),
      };
      
      _permitProvider.getPermits(params: params)
        .whenComplete(() {
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
      appBar: LayoutAppBar(
        title: 'Izin',
        bottom: LayoutAppBarBottom(
          child: RangeDateInput(
            fillColor: Colors.white60,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            style: const TextStyle(
              fontSize: 13,
            ),
            onChange: (period) {
              setState(() {
                _period = period;
              });
              _onRefresh();
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PermitFormScreen()
            )
          );
        },
        label: const Text('Buat'),
        icon: const Icon(UniconsLine.plus),
        backgroundColor: LayoutColor.primary,
        foregroundColor: LayoutColor.textPrimary,
      ),
      child: _listView(_permitProvider.permits),
    );
  }

  Widget _listView(List<PermitModel> permits) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: permits.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (ctx, i) {
        String startDate = permits[i].startDate.toLocalId('EEE, dd MMM').toString();
        String endDate = permits[i].endDate.toLocalId('EEE, dd MMM').toString();
        String rangeDate = '$startDate - $endDate';

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PermitDetailScreen(permit: permits[i])
              )
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
                  offset: const Offset(0,2),
                )
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  permits[i].type.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.textSecondary,
                    fontSize: 12,
                  )
                ),
                Text(
                  rangeDate,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.textPrimary,
                    fontSize: 15
                  )
                ),

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Icon(UniconsLine.check_circle),
                        const SizedBox(width: 10),
                        Text(
                          permits[i].status.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LayoutColor.secondary
                          ),
                        ),
                      ],
                    ),

                    Container(
                      decoration: BoxDecoration(
                        color: LayoutColor.secondary.withOpacity(.2),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(UniconsLine.angle_right),
                    ),
                  ],
                )
              ],
            ),
          )
        );
      },
    );
 }
}