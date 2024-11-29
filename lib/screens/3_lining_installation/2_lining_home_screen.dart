import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/3_lining_installation/3theconditionbefore_screen.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class lining_ramminghome extends StatefulWidget {
  const lining_ramminghome({super.key});

  @override
  State<lining_ramminghome> createState() => _sinteringhomeState();
}

class _sinteringhomeState extends State<lining_ramminghome> {
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
    DateTime timestamp;

    if (arguments != null && arguments is ReportModel) {
      r = arguments;
    } else {
      // จัดการกรณีที่เป็น null หรือประเภทที่ไม่ถูกต้อง
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
      backgroundColor: bgprimary,
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
                  color: primarytitle,
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
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Lining Installation',
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w800,
                                  color: icons,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  'Repair : ${r!.repairid!}',
                                  style: const TextStyle(
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: icons,
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('EEE MMM, d, yyyy')
                                    .format(r.planfromWorktime!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  color: icons,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FullScreenImage(),
                            ),
                          );
                        },
                        icon: const Icon(FontAwesomeIcons.image, color: icons),
                        label:
                            const Text('image', style: TextStyle(color: icons)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: button,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size(90, 40),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: primaryText.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        // Wrap the Column with SingleChildScrollView
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                FaIcon(FontAwesomeIcons.calendarDay,
                                    color: button, size: 30.0),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 0, 0),
                                  child: Text(
                                    'Report Date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: icons,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'Start Date:  ${DateFormat('d MMM yyyy').format(r.planfromWorktime!)}',
                                    style: const TextStyle(
                                        fontSize: 14, color: icons),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 5, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    'End Date: ${DateFormat('d MMM yyyy').format(r.planfromWorktime!)}',
                                    style: const TextStyle(
                                        fontSize: 14, color: icons),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                    child: VerticalDivider(
                      color: divider,
                      thickness: 2,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Customer :  ${r.shortname!}',
                                  style: const TextStyle(
                                      fontSize: 14, color: icons),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Contact :  ${r.shortname!}',
                                  style: const TextStyle(
                                      fontSize: 14, color: icons),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 5, 0, 0),
                            child: Row(
                              children: [
                                Text(
                                  'Job Type :  ${r.repairid!}',
                                  style: const TextStyle(
                                      fontSize: 14, color: icons),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 100,
                                  child: VerticalDivider(
                                      thickness: 3, color: divider),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Form : The Condition Before Installation',
                                        style: TextStyle(
                                            fontSize: 16, color: icons),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.conditionbefore,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.userClock,
                                    color: button,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Pending',
                                  style: TextStyle(color: icons, fontSize: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 100,
                                  child: VerticalDivider(
                                      thickness: 3, color: divider),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Form : Lining after Sintering Check',
                                        style: TextStyle(
                                            fontSize: 16, color: icons),
                                      ),
                                      Text(
                                        'Customer : ${r.shortname!}',
                                        style: const TextStyle(
                                            fontSize: 14, color: icons),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.lining,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.userClock,
                                    color: button,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Pending',
                                  style: TextStyle(color: icons, fontSize: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
             Container(
              width: double.infinity,
              decoration: const BoxDecoration(),
              child: Align(
                alignment: const AlignmentDirectional(-1, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                const SizedBox(
                                  height: 100,
                                  child: VerticalDivider(
                                      thickness: 3, color: divider),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Form : Dimension of furnace inside',
                                        style: TextStyle(
                                            fontSize: 16, color: icons),
                                      ),
                                      Text(
                                        'Customer : ${r.shortname!}',
                                        style: const TextStyle(
                                            fontSize: 14, color: icons),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.dimension_of_furnace_inside_6,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
                                    );
                                  },
                                  icon: FaIcon(
                                    FontAwesomeIcons.userClock,
                                    color: button,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Pending',
                                  style: TextStyle(color: icons, fontSize: 14),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage('assets/images/lining.png'),
          minScale:
              PhotoViewComputedScale.contained * 0.8, // ตั้งค่าการซูมของภาพ
          maxScale:
              PhotoViewComputedScale.covered * 2.0, // ตั้งค่าการซูมสูงสุดของภาพ
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent, // กำหนดให้พื้นหลังเป็นโปร่งใส
          ),
        ),
      ),
    );
  }
}
