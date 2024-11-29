import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/report_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  List<ReportModel> entries = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    ReportApi api = ReportApi();
    entries = await api.getReportList(user.employeeCode!);

    // จัดเรียงตามวันที่ โดยให้รายการล่าสุดมาก่อน
    entries.sort((a, b) => b.planfromWorktime!.compareTo(a.planfromWorktime!));

    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double fixedHeight = 170;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bgprimary,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: screenHeight - fixedHeight,
                  child: ListView.builder(
                      itemCount: entries.length,
                      itemBuilder: (context, index) {
                        ReportModel report = entries[index];
                        return Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 10),
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: bgcard,
                              boxShadow: [
                                BoxShadow(
                                  color: textprimary,
                                  spreadRadius: 1,
                                  blurRadius: 0,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    DateFormat('EEE MMM, d, yy  ' +
                                            '  ${DateFormat('hh:mm').format(report.planfromWorktime!)} - ${DateFormat('hh:mm').format(report.plantoWorktime!)}')
                                        .format(report.planfromWorktime!),
                                    style: const TextStyle(
                                        fontSize: 15, color: textprimary),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Repair: ${report.repairid}   Customer: ${report.shortname!}',
                                    style: const TextStyle(
                                        fontSize: 15, color: textprimary),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    'Detail : ${report.repairdetail!}',
                                    style: const TextStyle(
                                        fontSize: 15, color: textprimary),
                                  ),
                                  const Divider(),
                                  Wrap(
                                    spacing: 8.0,
                                    runSpacing: 8.0,
                                    children: [
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          // Pass report as Map
                                          Navigator.pushNamed(
                                              context, AppRouter.memo,
                                              arguments: {
                                                'report': report.toMap(),
                                              });
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Daily Report'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRouter.liningh,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Lining Form'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRouter.sintering,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Sintering Form'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRouter.coil,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Coil Form'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRouter.aluminum,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('PM Aluminum'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                              context, AppRouter.repaircoilhome,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text('Repair Coil Form'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              AppRouter.dismantlebuildladle,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text(
                                            'Dismantle & Build Ladle Form'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              AppRouter.lining_ramminghome_2,
                                              arguments: report);
                                        },
                                        icon: const Icon(Icons.edit_outlined),
                                        label: const Text(
                                            'Linging Installation Form(Ramming)'),
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                          ),
                                          backgroundColor: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
