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

class LiningHome extends StatefulWidget {
  const LiningHome({super.key});

  @override
  State<LiningHome> createState() => _LiningHomeState();
}

class _LiningHomeState extends State<LiningHome> {
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
                decoration: BoxDecoration(
                  color: primarytitle,
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 0, color: divider, offset: Offset(0, 1)),
                  ],
                  borderRadius: const BorderRadius.only(
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
                                'Form Lining installation report',
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
                                        'Form : ตารางการตรวจสอบ Coil ก่อนการตำเตา',
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
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRouter.fullcoil_lining,
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
                                        'Form : The Condition Before Installation',
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
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRouter.liningbeforeinstall,
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
                                        'Form : Insulation and waring net for lining',
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
                                      AppRouter.lininginsulation,
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
                                        'Form : Ramming',
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
                                      AppRouter.liningramming,
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
                                      AppRouter.liningdimension,
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
                                        'Form : Former dimension',
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
                                      AppRouter.liningformer,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
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
                                        'Form : Ramming of bottom part (deep form the furnace top to lining material)',
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
                                      AppRouter.liningrammingofbottom,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
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
                                        'Form : ข้อสังเกตุบริเวณก้นเตา',
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
                                      AppRouter.liningfurnacebottom,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
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
                                        'Form : Ramming of taper and side wall ด้านข้าง',
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
                                      AppRouter.liningrammingoftaper,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
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
                                        'Form : Summary of lining installation',
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
                                      AppRouter.liningsummaryoflining,
                                      arguments: {
                                        'report': r,
                                        'timestamp': DateTime.now(),
                                      },
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
