import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class fullFormBeforeAndAfter extends StatefulWidget {
  const fullFormBeforeAndAfter({super.key});

  @override
  State<fullFormBeforeAndAfter> createState() => _FullFormBeforeAndAfterState();
}

class _FullFormBeforeAndAfterState extends State<fullFormBeforeAndAfter> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  bool isdrawing = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    ReportModel? r;

    if (arguments != null && arguments is ReportModel) {
      r = arguments;
    } else {
      // Handle null or incorrect type case
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error: No report data provided.'),
        ),
      );
    }

    print('Arguments---------------: $arguments');
    return Scaffold(
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: background,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 0, color: divider, offset: Offset(0, 1)),
                  ],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Center(
                                child: Text(
                                  'ตารางการตรวจสอบ coil ก่อนการตำเตา',
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  'Repair : ${r.repairid!}',
                                  style: const TextStyle(
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                DateFormat('EEE MMM, d, yyyy')
                                    .format(r.planfromWorktime!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Stack(
              children: [
                Image.asset(
                  'assets/images/Coil.jpg',
                  width: 650,
                  height: 600,
                ),
                Positioned(
                  left: 0,
                  top: 60,
                  width: 450,
                  height: 190,
                  child: GestureDetector(
                    onTap: () {
                      print('Section 1 tapped!');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.topcastable,
                        arguments: r,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.red, width: 2), // Red border
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 250,
                  width: 450,
                  height: 170,
                  child: GestureDetector(
                    onTap: () {
                      print('Section 2 tapped!');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.coilbutton,
                        arguments: r,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.green, width: 2), // Green border
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 420,
                  width: 450,
                  height: 70,
                  child: GestureDetector(
                    onTap: () {
                      print('Section 3 tapped!');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.coilantenna,
                        arguments: r,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.blue, width: 2), // Blue border
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 490,
                  width: 450,
                  height: 110,
                  child: GestureDetector(
                    onTap: () {
                      print('Section 3 tapped!');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRouter.coilMetal,
                        arguments: r,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 222, 240, 21),
                            width: 2), // Blue border
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
