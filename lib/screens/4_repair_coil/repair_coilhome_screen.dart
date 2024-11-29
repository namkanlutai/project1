import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';

class repair_coilhome extends StatefulWidget {
  const repair_coilhome({super.key});

  @override
  State<repair_coilhome> createState() => _LiningHomeState();
}

class _LiningHomeState extends State<repair_coilhome> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  bool isDrawing = false;

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
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error', style: TextStyle(color: icons)),
          backgroundColor: primarytitle,
        ),
        body: const Center(
          child: Text('Error: No report data provided.',
              style: TextStyle(color: icons)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: primarytitle,
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
                                'Customer Service Report',
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
                                    'Start Date: ${DateFormat('d MMM yyyy').format(r.planfromWorktime!)}',
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
                        mainAxisSize: MainAxisSize.max,
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
                                        'Form : สาเหตุที่ส่งซ่อม (Cause)',
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
                                      AppRouter.repaircoilcheck0,
                                      arguments: r,
                                    );
                                  },
                                  icon: const FaIcon(
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
                                        'Form : สรุปผลการซ่อมคอยล์ (Coil repair result)',
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
                                      AppRouter.repaircoilcheck0_1,
                                      arguments: r,
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
                                        'Form : กำหนดวางแผนการทำงาน (Schedule)',
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
                                      AppRouter.repaircoilcheck0_2,
                                      arguments: r,
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
                                        'Form : การตรวจสอบขนาดของ Coil',
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
                                      AppRouter.repaircoilcheck1_0,
                                      arguments: r,
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
            const SizedBox(height: 15),
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
      appBar: AppBar(backgroundColor: primarytitle),
      body: Container(
        color: primarytitle,
        child: PhotoView(
          imageProvider: const AssetImage('assets/images/lining.png'),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }
}
