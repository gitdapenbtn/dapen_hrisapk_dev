import 'package:flutter/material.dart';
import 'package:dpbtn_absen/components/range_date_input.dart';
import 'package:dpbtn_absen/extensions/datetime_locale_id.dart';
import 'package:dpbtn_absen/layouts/constants/layout_color.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:dpbtn_absen/models/overtime_model.dart';
import 'package:dpbtn_absen/providers/overtime_provider.dart';
import 'package:dpbtn_absen/screens/overtime/overtime_detail_screen.dart';
import 'package:dpbtn_absen/screens/overtime/overtime_form_screen.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class OvertimeScreen extends StatefulWidget {
  const OvertimeScreen({super.key});

  @override
  State<OvertimeScreen> createState() => _OvertimeScreenState();
}

class _OvertimeScreenState extends State<OvertimeScreen> {
  late OvertimeProvider _overtimeProvider;
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
    _overtimeProvider = Provider.of<OvertimeProvider>(context);
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

      _overtimeProvider.getOvertimes(params: params).whenComplete(() {
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
        title: 'Lembur',
        bottom: LayoutAppBarBottom(
          child: RangeDateInput(
            fillColor: Colors.white60,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            style: const TextStyle(fontSize: 13),
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
            MaterialPageRoute(builder: (context) => const OvertimeFormScreen()),
          );
        },
        label: const Text('Buat'),
        icon: const Icon(UniconsLine.plus),
        backgroundColor: LayoutColor.primary,
        foregroundColor: LayoutColor.textPrimary,
      ),
      child: _listView(_overtimeProvider.overtimes),
    );
  }

  Widget _listView(List<OvertimeModel> overtimes) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: overtimes.length,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemBuilder: (ctx, i) {
        String startDate = overtimes[i].startDate
            .toLocalId('dd MMM, HH:mm')
            .toString();
        String endDate = overtimes[i].endDate
            .toLocalId('dd MMM, HH:mm')
            .toString();

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OvertimeDetailScreen(overtime: overtimes[i]),
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
                Text(
                  overtimes[i].type.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: LayoutColor.textSecondary,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 5),

                Wrap(
                  children: [
                    const SizedBox(
                      width: 60,
                      child: Text(
                        'Mulai',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: LayoutColor.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(': '),
                    Text(
                      startDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: LayoutColor.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                Wrap(
                  children: [
                    const SizedBox(
                      width: 60,
                      child: Text(
                        'Selesai',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: LayoutColor.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const Text(': '),
                    Text(
                      endDate,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: LayoutColor.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ],
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
                          overtimes[i].status.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: LayoutColor.secondary,
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
