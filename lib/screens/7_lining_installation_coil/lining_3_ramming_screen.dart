import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/1_sintering/sinteringshowdata_screen.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class lining_ramming extends StatefulWidget {
  final DateTime timestamp;

  const lining_ramming({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<lining_ramming> createState() => _SinteringChecklistState();
}

class _SinteringChecklistState extends State<lining_ramming> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;

  // Store controllers by group and index within that group
  Map<String, List<TextEditingController>> _groupedControllers = {};
  Map<String, List<bool>> _groupedFieldEmpty = {};
  Map<String, List<int>> _groupedButtonSelections =
      {}; // 0: None, 1: Good, 2: No Good

  final TextEditingController _controllerRemark = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUser();
    _sinteringItems = _apiService.fetchListItem('18');
    _sinteringItems.then((items) {
      setState(() {
        // Group the items by groupName
        Map<String, List<ListItem>> groupedItems = {};
        for (var item in items) {
          if (!groupedItems.containsKey(item.groupName)) {
            groupedItems[item.groupName] = [];
          }
          groupedItems[item.groupName]!.add(item);
        }

        // Initialize controllers, field empty states, and button selections for each group
        groupedItems.forEach((groupName, groupItems) {
          _groupedControllers[groupName] =
              List.generate(groupItems.length, (_) => TextEditingController());
          _groupedFieldEmpty[groupName] =
              List.generate(groupItems.length, (_) => false);
          _groupedButtonSelections[groupName] = List.generate(
              groupItems.length, (_) => 0); // Initialize with 0 (no selection)
        });
      });
    });
  }

  Future<void> getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  Future<void> _postData(List<ListItem> items, String repairId,
      {String? username}) async {
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 18,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timestamp),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Ramming (การตำ)",
      "FurnaceNo": 2,
      "HFT": "2 T",
      "Note": _controllerRemark.text,
      "Details": []
    };

    // Iterate over each group of controllers
    _groupedControllers.forEach((groupName, controllers) {
      List<ListItem> groupItems = items
          .where((item) => item.groupName == groupName)
          .toList(); // Filter items by group

      for (int i = 0; i < controllers.length; i++) {
        TextEditingController controller = controllers[i];
        String enteredText = controller.text;

        // หากเป็น typeValue == 'b' (มีปุ่ม Good/No Good)
        if (groupItems[i].typeValue == 'b') {
          int buttonValue = _groupedButtonSelections[groupName]![
              i]; // 1 for Good, 2 for No Good
          jsonData['Details'].add({
            "CheckID": 0,
            "GroupID": groupItems[i].groupId,
            "TypeNo": groupItems[i].typeNo,
            "ValueBit": 1,
            "Value": buttonValue
                .toString(), // บันทึกค่า button (Good/No Good) ใน Value
            "valuedetail": enteredText // บันทึกค่า text field ใน valuedetail
          });
        }
        // หากเป็น typeValue == 'v' (รับค่าเป็นตัวเลข)
        else if (groupItems[i].typeValue == 'v') {
          // บันทึกค่าลงใน Value
          jsonData['Details'].add({
            "CheckID": 0,
            "GroupID": groupItems[i].groupId,
            "TypeNo": groupItems[i].typeNo,
            "ValueBit": 1,
            "Value": enteredText, // เก็บค่าใน Value (ไม่เก็บลง valuedetail)
            "valuedetail": '' // ไม่เก็บค่าใน valuedetail
          });
        }
        // หากเป็น typeValue == 's' (รับค่าเป็นข้อความ)
        else if (groupItems[i].typeValue == 's') {
          // บันทึกค่าลงใน valuedetail
          jsonData['Details'].add({
            "CheckID": 0,
            "GroupID": groupItems[i].groupId,
            "TypeNo": groupItems[i].typeNo,
            "ValueBit": 1,
            "Value": '', // ไม่เก็บค่าใน Value
            "valuedetail": enteredText // เก็บค่าใน valuedetail
          });
        }
      }
    });

    // ส่งข้อมูลไปยัง API
    try {
      print(
          'Request Payload: ${jsonEncode(jsonData)}'); // Log the request payload for debugging

      // Send the POST request
      final response = await http.post(
        Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      // Log the response for debugging
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Check the response
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Failed to save data: ${response.statusCode}, ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  bool _validateFields(List<ListItem> items) {
    bool allValid = true;
    List<String> errorMessages =
        []; // Store error messages for specific groupNames

    // Define the specific card indices we want to check for text fields (0 and 2)
    List<int> specificCardIndicesToCheck =
        []; // 0-based index for 1st and 3rd card

    // Iterate through the controllers and buttons by group
    _groupedControllers.forEach((groupName, controllers) {
      for (int i = 0; i < controllers.length; i++) {
        // Only validate for the specific cards at index 0 and 2
        if (specificCardIndicesToCheck.contains(i)) {
          // 1. Validate the text fields
          if (controllers[i].text.isEmpty) {
            setState(() {
              _groupedFieldEmpty[groupName]![i] = true;
            });
            allValid = false; // Mark invalid if the required field is empty

            // Add error message for the groupName
            if (!errorMessages.contains(groupName)) {
              errorMessages.add(groupName); // Avoid duplicates
            }
          } else {
            setState(() {
              _groupedFieldEmpty[groupName]![i] = false;
            });
          }

          // 2. Validate "Good" or "No Good" buttons (only if present in the card)
          if (items[i].typeValue == 'b') {
            if (_groupedButtonSelections[groupName] != null &&
                _groupedButtonSelections[groupName]![i] == 0) {
              // Button is not selected
              setState(() {
                _groupedFieldEmpty[groupName]![i] =
                    true; // Mark field as required
                allValid = false; // Mark as invalid

                // Add error message for the groupName
                if (!errorMessages.contains(groupName)) {
                  errorMessages.add(groupName); // Avoid duplicates
                }
              });
            } else {
              // Button is selected (Good or No Good)
              setState(() {
                _groupedFieldEmpty[groupName]![i] = false;
              });
            }
          }
        }
      }
    });

    // Show a snackbar message if validation fails
    if (!allValid) {
      String errorMessage =
          "Please fill in all required fields and select Good or No Good where applicable for specific cards.";

      if (errorMessages.isNotEmpty) {
        errorMessage += "\nError in groups: " + errorMessages.join(', ');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }

    return allValid;
  }

  @override
  void dispose() {
    _groupedControllers.forEach((_, controllers) {
      for (var controller in controllers) {
        controller.dispose();
      }
    });
    _controllerRemark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return Scaffold(
        body: Center(child: Text('Error: Missing or incorrect arguments.')),
      );
    }

    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final ReportModel r = args['report'];

    return Scaffold(
      backgroundColor: primarytitle,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            _buildHeader(r),
            FutureBuilder<List<ListItem>>(
              future: _sinteringItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No items found');
                } else {
                  // Group items by groupName
                  Map<String, List<ListItem>> groupedItems = {};
                  for (var item in snapshot.data!) {
                    if (!groupedItems.containsKey(item.groupName)) {
                      groupedItems[item.groupName] = [];
                    }
                    groupedItems[item.groupName]!.add(item);
                  }

                  return Column(
                    children: [
                      // Iterate over each group and display groupName as a header
                      ...groupedItems.entries.map((entry) {
                        int groupIndex =
                            groupedItems.keys.toList().indexOf(entry.key) +
                                1; // เพิ่มการนับลำดับ
                        String groupName = entry.key;
                        List<ListItem> items = entry.value;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Group header with order number
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text(
                                '${groupIndex}. ${groupName}', // แสดงลำดับที่เพิ่มขึ้น
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                                height: 10), // ระยะห่างก่อนเริ่ม card

                            // Iterate over the items in each group
                            ...items.asMap().entries.map((entry) {
                              int index = entry.key;
                              ListItem item = entry.value;

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: _buildCard(item, index, groupName),
                              );
                            }).toList(),

                            // Add Divider after each group
                            const Divider(
                              color: Colors.white70, // สีของเส้นแบ่ง
                              thickness: 1.5, // ความหนาของเส้นแบ่ง
                            ),

                            // Add space between groups
                            const SizedBox(height: 20),
                          ],
                        );
                      }).toList(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _controllerRemark,
                          style: const TextStyle(fontSize: 16, color: icons),
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2.0),
                            ),
                            labelText: 'Remarks',
                            labelStyle: TextStyle(color: icons),
                            hintText: 'Enter any additional remarks',
                            hintStyle: TextStyle(color: icons),
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildNextButton(r),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: primarytitle,
          boxShadow: [
            BoxShadow(
              blurRadius: 0,
              color: divider,
              offset: Offset(0, 1),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'The Condition Before Installation',
                        style: TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: icons,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        'Repair : ${r.repairid!}',
                        style: const TextStyle(
                          letterSpacing: 0,
                          fontWeight: FontWeight.bold,
                          color: icons,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (r.repairid != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SimpleDataTable(repairID: r.repairid!),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Repair ID is missing')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: button,
                ),
                child: const Text('Data CheckList',
                    style: TextStyle(color: icons)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(ListItem item, int index, String groupName) {
    TextEditingController textController =
        _groupedControllers[groupName]![index];
    bool hasValidStdValues =
        (item.stdValueMin != null && item.stdValueMin != 0) ||
            (item.stdValueMax != null && item.stdValueMax != 0);

    TextInputType keyboardType;
    List<TextInputFormatter> inputFormatters;

    if (item.typeValue == 'v') {
      keyboardType = TextInputType.number;
      inputFormatters = <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ];
    } else {
      keyboardType = TextInputType.text;
      inputFormatters = <TextInputFormatter>[];
    }

    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      color: primaryText,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${index + 1}. ${item.typeName}',
                    style: const TextStyle(fontSize: 16, color: icons),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            if (hasValidStdValues)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '     Standard : ${item.stdValueMin ?? "N/A"} - ${item.stdValueMax ?? "N/A"}',
                  style: const TextStyle(fontSize: 14, color: icons),
                ),
              ),
            const SizedBox(height: 10),

            // Button handling for Good and No Good
            if (item.typeValue == 'b')
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _groupedButtonSelections[groupName]![index] =
                              1; // "Good" selected
                          _groupedFieldEmpty[groupName]![index] =
                              false; // Update validation
                        });
                      },
                      icon: const Icon(Icons.thumb_up, color: Colors.white),
                      label: const Text('Good',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _groupedButtonSelections[groupName]![index] == 1
                                ? Colors.green
                                : divider,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _groupedButtonSelections[groupName]![index] =
                              2; // "No Good" selected
                          _groupedFieldEmpty[groupName]![index] =
                              false; // Update validation
                        });
                      },
                      icon: const Icon(Icons.thumb_down, color: Colors.white),
                      label: const Text('No Good',
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _groupedButtonSelections[groupName]![index] == 2
                                ? Colors.red
                                : divider,
                        minimumSize: const Size(0, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),

            // Text field handling for text input
            if (keyboardType == TextInputType.text)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(fontSize: 16, color: icons),
                      keyboardType: keyboardType,
                      inputFormatters: inputFormatters,
                      minLines: 1,
                      maxLines: null, // Dynamically expand based on content
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        labelText: 'Input Value',
                        labelStyle: const TextStyle(color: icons),
                        hintText: 'Enter Value',
                        hintStyle: const TextStyle(color: icons),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        isDense: true,
                        suffixText: item.unitId ?? '',
                        suffixStyle:
                            const TextStyle(fontSize: 16, color: icons),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _groupedFieldEmpty[groupName]![index] = value.isEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),

            // Leave the number input field unchanged (fixed size)
            if (keyboardType == TextInputType.number)
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(fontSize: 16, color: icons),
                      keyboardType: TextInputType.numberWithOptions(
                          decimal: true), // อนุญาตให้ใส่จุดทศนิยม
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9.]')), // อนุญาตเฉพาะตัวเลขและจุดทศนิยม
                      ],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 2.0),
                        ),
                        labelText: 'Input Value',
                        labelStyle: const TextStyle(color: icons),
                        hintText: 'Enter Value',
                        hintStyle: const TextStyle(color: icons),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        isDense: true,
                        suffixText: item.unitId ?? '',
                        suffixStyle:
                            const TextStyle(fontSize: 16, color: icons),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _groupedFieldEmpty[groupName]![index] = value.isEmpty;
                        });
                      },
                    ),
                  ),
                ],
              ),

            if (_groupedFieldEmpty[groupName]![index])
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'This field is required.',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(80, 0, 80, 5),
      child: InkWell(
        onTap: () async {
          try {
            if (_validateFields(await _sinteringItems)) {
              final items = await _sinteringItems;
              String fullName = '${user.firstname} ${user.lastname}';
              await _postData(items, r.repairid!, username: fullName);
            }
          } catch (e) {
            // Handle any errors that occur during the post
            print('Error: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error saving data: $e')),
            );
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: button,
            borderRadius: BorderRadius.circular(30),
          ),
          alignment: const AlignmentDirectional(0, 0),
          child:
              const Text('Save', style: TextStyle(color: icons, fontSize: 18)),
        ),
      ),
    );
  }
}
