import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/jobdetail_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class MemoviewScreen extends StatefulWidget {
  const MemoviewScreen({super.key});

  @override
  State<MemoviewScreen> createState() => _MemoviewScreenState();
}

class _MemoviewScreenState extends State<MemoviewScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  JobDetailApi jobDetailApi = JobDetailApi();

  List<TextEditingController> materialNameControllers = [];
  List<TextEditingController> materialQtyControllers = [];
  List<TextEditingController> equipmentNameControllers = [];
  List<TextEditingController> equipmentQtyControllers = [];
  List<TextEditingController> repairEmployeeControllers = [];
  List<String> repairEmpNames = [];
  bool isLoading = false;
  List<File> images = [];
  // State variables to control expansion
  bool isMaterialExpanded = false;
  bool isEquipmentExpanded = false;
  bool isRepairEmployeeExpanded = false;
  String memo = "";
  ReportModel? reportModel;
  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  Future<void> fetchJobDetailsByJobID(String jobId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final jobDetails = await jobDetailApi.getJobDetailByJobID(jobId);
      if (jobDetails != null && jobDetails.isNotEmpty) {
        setState(() {
          repairEmpNames =
              jobDetails.map((item) => item.repairEmpName).toList();
          repairEmployeeControllers = repairEmpNames
              .map((name) => TextEditingController(text: name))
              .toList();
        });
      } else {
        setState(() {
          repairEmpNames = [];
          repairEmployeeControllers.clear();
        });
      }
    } catch (e) {
      debugPrint('Error fetching job details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      reportModel = ReportModel.fromMap(arguments['report']);
      memo = arguments['memo'] ?? '';
      images = List<File>.from(arguments['images'] ?? []);
    }
  }

  /// ฟังก์ชันลบภาพ

  // Method to add new TextField for Material
  void _addMaterialField([String? nameValue, String? qtyValue]) {
    final nameController = TextEditingController(text: nameValue);
    final qtyController = TextEditingController(text: qtyValue);
    setState(() {
      materialNameControllers.add(nameController);
      materialQtyControllers.add(qtyController);
    });
  }

  // Method to remove TextField at a specific index
  void _removeMaterialField(int index) {
    setState(() {
      materialNameControllers.removeAt(index);
      materialQtyControllers.removeAt(index);
    });
  }

  // Method to add new TextField for Equipment
  void _addEquipmentField([String? nameValue, String? qtyValue]) {
    final nameController = TextEditingController(text: nameValue);
    final qtyController = TextEditingController(text: qtyValue);
    setState(() {
      equipmentNameControllers.add(nameController);
      equipmentQtyControllers.add(qtyController);
    });
  }

  // Method to remove TextField at a specific index for Equipment
  void _removeEquipmentField(int index) {
    setState(() {
      equipmentNameControllers.removeAt(index);
      equipmentQtyControllers.removeAt(index);
    });
  }

  // Method to add new TextField for Repair Employee
  void _addRepairEmployeeField([String? value]) {
    final controller = TextEditingController(text: value);
    setState(() {
      repairEmployeeControllers.add(controller);
      repairEmpNames.add(controller.text);
    });
  }

  // Method to remove TextField at a specific index for Repair Employee
  void _removeRepairEmployeeField(int index) {
    setState(() {
      repairEmployeeControllers.removeAt(index);
      repairEmpNames.removeAt(index);
    });
  }

  Widget _buildMaterialFieldList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: materialNameControllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: materialNameControllers[index],
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: textprimary, width: 2.0),
                    ),
                    labelText: 'Material Name',
                    labelStyle: const TextStyle(color: textprimary),
                  ),
                  style: const TextStyle(color: textprimary),
                  onChanged: (value) {
                    // Handle changes if needed
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: materialQtyControllers[index],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: textprimary, width: 2.0),
                    ),
                    labelText: 'Qty',
                    labelStyle: const TextStyle(color: textprimary),
                  ),
                  style: const TextStyle(color: textprimary),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle changes if needed
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeMaterialField(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextFieldList({
    required List<TextEditingController> controllers,
    required Function(int) removeFunction,
    required String labelText,
    int minLines = 1,
    int maxLines = 5,
  }) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controllers[index],
                  minLines: minLines,
                  maxLines: maxLines,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: textprimary, width: 2.0),
                    ),
                    labelText: labelText,
                    labelStyle: const TextStyle(color: textprimary),
                  ),
                  style: const TextStyle(color: textprimary),
                  onChanged: (value) {
                    // Handle changes to the text if needed
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => removeFunction(index),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEquipmentFieldList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: equipmentNameControllers.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: equipmentNameControllers[index],
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: textprimary, width: 2.0),
                    ),
                    labelText: 'Equipment Name',
                    labelStyle: const TextStyle(color: textprimary),
                  ),
                  style: const TextStyle(color: textprimary),
                  onChanged: (value) {
                    // Handle changes if needed
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextField(
                  controller: equipmentQtyControllers[index],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: textprimary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          const BorderSide(color: textprimary, width: 2.0),
                    ),
                    labelText: 'Qty',
                    labelStyle: const TextStyle(color: textprimary),
                  ),
                  style: const TextStyle(color: textprimary),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    // Handle changes if needed
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeEquipmentField(index),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    ReportModel r =
        ReportModel.fromMap(arguments['report'] as Map<String, dynamic>);
    String memo = arguments['memo'] as String;

    // Fetch job details if not already fetched
    if (repairEmpNames.isEmpty && !isLoading) {
      fetchJobDetailsByJobID(r.jobid!);
    }

    return Scaffold(
      backgroundColor: bgprimary,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: bgprimary,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 0, color: divider, offset: Offset(0, 1))
                  ],
                  borderRadius: BorderRadius.only(
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
                                    color: textprimary),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 4, 0, 0),
                                child: Text(
                                  'Repair ID: ${r.repairid!}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: textprimary),
                                ),
                              ),
                              Text(
                                DateFormat('EEE MMM, d, yyyy')
                                    .format(r.planfromWorktime!),
                                style: const TextStyle(
                                    fontSize: 14, color: textprimary),
                              ),
                              Text(
                                'Job ID: ${r.jobid!}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: textprimary),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () async {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.memo,
                            arguments: {
                              'report': r.toMap(),
                              'memo': memo,
                              'images': images, // Pass images here
                            },
                          );
                        },
                        icon: const Icon(FontAwesomeIcons.pencilAlt,
                            color: bgprimary),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: bluedark,
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '    Work Description',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: textprimary),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        memo,
                        style:
                            const TextStyle(fontSize: 16, color: textprimary),
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Material Section with ExpansionTile
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Images',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: textprimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              images[index],
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          // Positioned(
                          //   right: 0,
                          //   top: 0,
                          //   child: GestureDetector(
                          //     //onTap: () => removeImage(index),
                          //     child: Container(
                          //       decoration: const BoxDecoration(
                          //         shape: BoxShape.circle,
                          //         color: Colors.red,
                          //       ),
                          //       child: const Icon(
                          //         Icons.close,
                          //         color: Colors.white,
                          //         size: 20,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
            // Equipment Section with ExpansionTile
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: ExpansionTile(
                title: Text(
                  'Equipment (${equipmentNameControllers.length} Qty)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textprimary,
                  ),
                ),
                initiallyExpanded: isEquipmentExpanded,
                onExpansionChanged: (bool expanded) {
                  setState(() => isEquipmentExpanded = expanded);
                },
                trailing: const Icon(
                  Icons.expand_more,
                  color: textprimary,
                  size: 32,
                ),
                children: [
                  Container(
                    height: equipmentNameControllers.length > 3 ? 250.0 : null,
                    child: SingleChildScrollView(
                      child: _buildEquipmentFieldList(),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _addEquipmentField(),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: textprimary),
                            SizedBox(width: 8),
                            Text('Add Equipment',
                                style: TextStyle(
                                    fontSize: 16, color: textprimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: ExpansionTile(
                title: Text(
                  'Material (${materialNameControllers.length} Qty)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textprimary,
                  ),
                ),
                initiallyExpanded: isMaterialExpanded,
                onExpansionChanged: (bool expanded) {
                  setState(() => isMaterialExpanded = expanded);
                },
                trailing: const Icon(
                  Icons.expand_more,
                  color: textprimary,
                  size: 32,
                ),
                children: [
                  Container(
                    height: materialNameControllers.length > 3 ? 250.0 : null,
                    child: SingleChildScrollView(
                      child: _buildMaterialFieldList(),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _addMaterialField(),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: textprimary),
                            SizedBox(width: 8),
                            Text('Add Material',
                                style: TextStyle(
                                    fontSize: 16, color: textprimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Repair Employees Section with ExpansionTile
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 16),
              child: ExpansionTile(
                title: Text(
                  'Operator (${repairEmployeeControllers.length} People)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: textprimary,
                  ),
                ),
                initiallyExpanded: isRepairEmployeeExpanded,
                onExpansionChanged: (bool expanded) {
                  setState(() => isRepairEmployeeExpanded = expanded);
                },
                trailing: const Icon(
                  Icons.expand_more,
                  color: textprimary,
                  size: 32,
                ),
                children: [
                  Container(
                    height: repairEmployeeControllers.length > 3 ? 250.0 : null,
                    child: SingleChildScrollView(
                      child: _buildTextFieldList(
                        controllers: repairEmployeeControllers,
                        removeFunction: _removeRepairEmployeeField,
                        labelText: 'Operator Name',
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () => _addRepairEmployeeField(),
                        child: Row(
                          children: const [
                            Icon(Icons.add, color: textprimary),
                            SizedBox(width: 8),
                            Text('Add Repair Employee',
                                style: TextStyle(
                                    fontSize: 16, color: textprimary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 45),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                    backgroundColor: bluedark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, AppRouter.memoapprove,
                        arguments: r);
                  },
                  child: const Text(
                    'Customer Approve',
                    style: TextStyle(color: textprimary, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in materialNameControllers) {
      controller.dispose();
    }
    for (var controller in materialQtyControllers) {
      controller.dispose();
    }
    for (var controller in equipmentNameControllers) {
      controller.dispose();
    }
    for (var controller in equipmentQtyControllers) {
      controller.dispose();
    }
    for (var controller in repairEmployeeControllers) {
      controller.dispose();
    }
    super.dispose();
  }
}
