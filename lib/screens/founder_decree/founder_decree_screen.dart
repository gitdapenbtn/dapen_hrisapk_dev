import 'package:dpbtn_absen/models/employee_organization_model.dart';
import 'package:dpbtn_absen/providers/employee_organization_provider.dart';
import 'package:dpbtn_absen/screens/founder_decree/founder_decree_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:dpbtn_absen/layouts/layout.dart';
import 'package:dpbtn_absen/layouts/parts/layout_app_bar.dart';
import 'package:provider/provider.dart';

class FounderDecreeScreen extends StatefulWidget {
  const FounderDecreeScreen({super.key});

  @override
  State<FounderDecreeScreen> createState() => _FounderDecreeScreenState();
}

class _FounderDecreeScreenState extends State<FounderDecreeScreen> {
  late EmployeeOrganizationProvider _employeeOrganizationProvider;
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

    _employeeOrganizationProvider = Provider.of<EmployeeOrganizationProvider>(
      context,
    );
  }

  Future _onRefresh() {
    setState(() {
      _isLoading = true;
    });

    return Future.delayed(const Duration(seconds: 1), () async {
      _employeeOrganizationProvider.getEmployeeOrganizations().whenComplete(() {
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
      padding: EdgeInsets.zero,
      child: _listView(_employeeOrganizationProvider.employeeOrganizations),
    );
  }

  Widget _listView(List<EmployeeOrganizationModel> employeeOrganizations) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: employeeOrganizations.length,
      itemBuilder: (ctx, i) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FounderDecreeListScreen(
                  organizationId: employeeOrganizations[i].id!,
                  organizationName: employeeOrganizations[i].name,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white70,
              border: const Border(bottom: BorderSide(color: Colors.black12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      employeeOrganizations[i].name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employeeOrganizations[i].description ?? '',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        );
      },
    );
  }
}
