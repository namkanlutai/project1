import 'dart:convert';

import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signature/signature.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class MemoApproveScreen extends StatefulWidget {
  const MemoApproveScreen({super.key});

  @override
  State<MemoApproveScreen> createState() => _MemoApproveScreenState();
}

class _MemoApproveScreenState extends State<MemoApproveScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: textprimary, // Set the pen color to textprimary
    exportBackgroundColor: Colors.white,
  );
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
    ReportModel r = ModalRoute.of(context)!.settings.arguments as ReportModel;
    return Scaffold(
      backgroundColor: bgprimary, // Set background color to bgprimary
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
                  color: bgprimary, // Set background color for the container
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
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  'Repair : ${r.repairid!}',
                                  style: const TextStyle(
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        textprimary, // Set text color to textprimary
                                  ),
                                ),
                              ),
                              Text(
                                DateFormat('EEE MMM, d, yyyy')
                                    .format(r.planfromWorktime!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 0,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                              context, AppRouter.report,
                              arguments: r);
                        },
                        icon: const Icon(
                          Icons.save_as_sharp,
                          color: bgprimary, // Set icon color to bluedark
                        ),
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              bluedark, // Set background color to bgprimary
                          foregroundColor:
                              textprimary, // Set text color to textprimary
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
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
              height: 100,
              decoration: BoxDecoration(
                color: secondaryText.withOpacity(0.3),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              FaIcon(FontAwesomeIcons.calendarDay,
                                  color: bluedark,
                                  size: 30.0), // Set icon color to bluedark
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                child: Text(
                                  'Report Date',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          textprimary // Set text color to textprimary
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
                                  'Start Date :  ${DateFormat('d MMM yyyy').format(r.planfromWorktime!)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color:
                                        textprimary, // Set text color to textprimary
                                  ),
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
                                  'End Date :  ${DateFormat('d MMM yyyy').format(r.planfromWorktime!)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color:
                                        textprimary, // Set text color to textprimary
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                    child: VerticalDivider(
                      color: textprimary, // Set divider color to textprimary
                      thickness: 5,
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                'Customer :  ${r.shortname!}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                'Contact :  ${r.shortname!}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Row(
                            children: [
                              Text(
                                'Job Type :  ${r.repairid!}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Column(
                children: [
                  const Text(
                    'Customer Comment',
                    style: TextStyle(
                        fontSize: 18,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w800,
                        color: textprimary), // Set text color to textprimary
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: TextField(
                      maxLines: 8,
                      decoration: InputDecoration(
                        hintText: 'Enter your comment here',
                        hintStyle: const TextStyle(
                          color:
                              textprimary, // Set hint text color to textprimary
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                          borderSide: const BorderSide(
                            color:
                                textprimary, // Set border color to textprimary
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: textprimary, // Set border color when enabled
                            width: 1.5, // Optional: Set border thickness
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: textprimary, // Set border color when focused
                            width:
                                2.0, // Optional: Increase border thickness when focused
                          ),
                        ),
                      ),
                      style: const TextStyle(
                          color: textprimary,
                          fontSize: 18 // Set input text color to textprimary
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: 250,
              decoration: const BoxDecoration(
                color: bgprimary, // Set background color to bgprimary
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'Customer Signature',
                            style: TextStyle(
                              fontSize: 18,
                              letterSpacing: 0,
                              fontWeight: FontWeight.w800,
                              color:
                                  textprimary, // Set text color to textprimary
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 120,
                              decoration: BoxDecoration(
                                color: secondaryText.withOpacity(
                                    0.3), // Background color for signature pad
                                border: Border.all(
                                  color:
                                      textprimary, // Border color set to textprimary
                                  width: 2.0, // Border thickness
                                ),
                                borderRadius: BorderRadius.circular(
                                    8), // Optional: rounded corners
                              ),
                              child: Signature(
                                controller: _controller,
                                backgroundColor: Colors
                                    .transparent, // Keep the signature pad transparent
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.clear();
        },
        backgroundColor: bluedark, // Set button background color to bluedark
        foregroundColor: textprimary, // Set button icon color to textprimary
        child: const Icon(Icons.clear),
      ),
    );
  }
}
