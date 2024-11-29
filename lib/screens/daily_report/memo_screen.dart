import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/fetchJobDetail_model.dart';
import 'package:engineer/models/jobdetail_model.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/jobdetail_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MemoScreen extends StatefulWidget {
  const MemoScreen({super.key});

  @override
  State<MemoScreen> createState() => _MemoScreenState();
}

class _MemoScreenState extends State<MemoScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();

  TextEditingController memoController = TextEditingController();
  ReportModel? reportModel;
  bool isFirstTimeAccess = true;
  List<String> repairEmpNames = [];
  String formDate = "";
  String toDate = "";
  JobDetailModelByJobID? jobDetail;
  bool isLoading = true;
  JobDetailModel job = JobDetailModel();
  final JobDetailApi jobDetailApi = JobDetailApi();

  final ImagePicker _picker = ImagePicker();
  List<File> images = []; // List เก็บรูปภาพ
  final TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments = ModalRoute.of(context)!.settings.arguments;

    if (arguments is Map<Object?, Object?>) {
      final convertedArguments = arguments.map((key, value) =>
          MapEntry(key.toString(), value)); // Ensure all keys are strings

      reportModel = ReportModel.fromMap(
        convertedArguments['report'] as Map<String, dynamic>,
      );
      memoController.text = convertedArguments['memo'] as String? ?? '';
      images = (convertedArguments['images'] as List<dynamic>?)?.cast<File>() ??
          []; // Load images if passed
    } else {
      reportModel = ReportModel();
      memoController.text = '';
      images = [];
    }
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  @override
  void dispose() {
    memoController.dispose();
    textController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        images.add(File(pickedFile.path));
      });
    }
  }

  // ฟังก์ชันลบภาพ
  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void viewAndEditImage(BuildContext context, File image) {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              child: Stack(
                children: [
                  // รูปภาพแสดงผลเต็มหน้าจอ
                  Positioned.fill(
                    child: Image.file(image, fit: BoxFit.contain),
                  ),
                  // กรอบข้อความ
                  Positioned(
                    bottom: 50,
                    left: 20,
                    right: 20,
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black.withOpacity(0.5),
                        hintText: 'Add text here...',
                        hintStyle: const TextStyle(color: Colors.white70),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  // ปุ่มปิด
                  Positioned(
                    top: 10,
                    right: 10,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (reportModel == null) {
      return const CircularProgressIndicator();
    }

    return Scaffold(
      backgroundColor: bgprimary, // Set background color to bgprimary
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: bgprimary, // Set the background to bgprimary
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Customer Service Report',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  'Repair : ${reportModel!.repairid ?? "Enter Repair ID"}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        textprimary, // Set text color to textprimary
                                  ),
                                ),
                              ),
                              Text(
                                isFirstTimeAccess
                                    ? 'No date provided'
                                    : DateFormat('EEE MMM, d, yyyy')
                                        .format(reportModel!.planfromWorktime!),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color:
                                      textprimary, // Set text color to textprimary
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.memoview,
                            arguments: {
                              'report': reportModel!.toMap(),
                              'memo': memoController.text,
                              'images': images,
                            },
                          );
                        },
                        icon: const Icon(Icons.save_as_sharp,
                            color: bgprimary), // Set icon color to bluedark
                        label: const Text('Save'),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          backgroundColor:
                              bluedark, // Set button background color to bluedark
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
              height: 110,
              decoration: BoxDecoration(
                color: secondaryText.withOpacity(0.3),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: Row(
                  children: [
                    Container(
                      width: 180, // Optional: Set a fixed width if needed
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
                                          textprimary), // Set text color to textprimary
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
                                  'Start Date :  ${DateFormat('d MMM yyyy').format(reportModel!.planfromWorktime!)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color:
                                          textprimary), // Set text color to textprimary
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
                                  'End Date :  ${DateFormat('d MMM yyyy').format(reportModel!.planfromWorktime!)}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color:
                                          textprimary), // Set text color to textprimary
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 90,
                      child: VerticalDivider(
                        color: textprimary, // Set divider color to textprimary
                        thickness: 2,
                      ),
                    ),
                    Container(
                      width: 300, // Optional: Set a fixed width if needed
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
                                Expanded(
                                  child: Text(
                                    'Customer :  ${reportModel!.shortname!}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            textprimary), // Set text color to textprimary
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
                                Expanded(
                                  child: Text(
                                    'Contact :  ${reportModel!.contactperson!}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            textprimary), // Set text color to textprimary
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
                                Expanded(
                                  child: Text(
                                    'Job Type :  ${reportModel!.jtName!}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            textprimary), // Set text color to textprimary
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
                                Expanded(
                                  child: Text(
                                    'Jobid :  ${reportModel!.jobid!}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color:
                                            textprimary), // Set text color to textprimary
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Card(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              color: bgcard, // Set the card color to bgprimary
              elevation: 7,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Text(
                        'Engineer Responsible : ${reportModel!.repairEmpName!}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: textprimary, // Set text color to textprimary
                        ),
                      ),
                    ),
                    ExpansionTile(
                      title: const Text(
                        'Details',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(
                              255, 248, 0, 0), // Set text color to textprimary
                        ),
                      ),
                      initiallyExpanded:
                          false, // Set to true if you want it to be open initially
                      children: [
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Text(
                            'Repair Detail : ${reportModel!.repairdetail!}',
                            style: const TextStyle(
                              fontSize: 16,
                              color:
                                  textprimary, // Set text color to textprimary
                            ),
                          ),
                        ),
                        Divider(),
                        Align(
                          alignment: const AlignmentDirectional(-1, 0),
                          child: Text(
                            'Description : ${reportModel!.description!}',
                            style: const TextStyle(
                              fontSize: 16,
                              color:
                                  textprimary, // Set text color to textprimary
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Column(
                children: [
                  const Text(
                    'Work Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: textprimary, // Set text color to textprimary
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: TextField(
                      controller: memoController,
                      minLines: 15,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Enter Description here...',
                        hintStyle: const TextStyle(
                          color:
                              textprimary, // Set hint text color to textprimary
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              8), // Optional: Add rounded corners
                          borderSide: const BorderSide(
                            color:
                                textprimary, // Set the border color to textprimary
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
                        color:
                            textprimary, // Set input text color to textprimary
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount:
                    images.length + 1, // Add an extra slot for adding images
                itemBuilder: (context, index) {
                  if (index == images.length) {
                    return GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: const Center(
                          child: Icon(Icons.add_a_photo,
                              size: 30, color: Colors.grey),
                        ),
                      ),
                    );
                  } else {
                    return Stack(
                      children: [
                        GestureDetector(
                          onTap: () => viewAndEditImage(context, images[index]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              images[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () => removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
