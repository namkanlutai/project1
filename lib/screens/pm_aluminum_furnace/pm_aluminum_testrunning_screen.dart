import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class AluminumFurnaceTestRunning extends StatefulWidget {
  const AluminumFurnaceTestRunning({super.key});

  @override
  State<AluminumFurnaceTestRunning> createState() =>
      _AluminumFurnaceTestRunningState();
}

class _AluminumFurnaceTestRunningState
    extends State<AluminumFurnaceTestRunning> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;
  List<TextEditingController> _controllers = [];
  List<bool> _isFieldEmpty = [];
  List<int> _selectedStatusList =
      []; // List to store the selected status for each card
  String? _selectedGroupName;

  @override
  void initState() {
    super.initState();
    getUser();

    // Fetch the list of SinteringItems
    _sinteringItems = _apiService.fetchListItem('17');

    _sinteringItems.then((items) {
      setState(() {
        _controllers = List.generate(
          items.length,
          (_) => TextEditingController(),
        );
        _isFieldEmpty = List.generate(items.length, (_) => false);
        _selectedStatusList = List.generate(
            items.length, (_) => 0); // Initialize to 0 for no selection

        // Set the first groupName as the selected groupName
        if (items.isNotEmpty) {
          _selectedGroupName = items.first.groupName;
        }
      });
    });
  }

  Future<void> getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  int _getGroupNumber(List<ListItem> items, String groupName, int index) {
    int count = 1;
    for (int i = 0; i < index; i++) {
      if (items[i].groupName == groupName) {
        count++;
      }
    }
    return count;
  }

  bool _validateFields() {
    List<int> requiredIndices = [1, 2]; // 0-based index for 1, 2, 3, and 8
    bool allValid = true;

    for (int index in requiredIndices) {
      if (_controllers[index].text.isEmpty) {
        setState(() {
          _isFieldEmpty[index] = true;
        });
        allValid = false;
      } else {
        setState(() {
          _isFieldEmpty[index] = false;
        });
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields.'),
        ),
      );
    }

    return allValid;
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _postData(List<ListItem> items, String repairId,
      {String? username}) async {
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 17,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Coil Cement",
      "FurnaceNo": 2,
      "HFT": "2 T",
      "Note": "ทดสอบ App",
      "Details": List.generate(_controllers.length, (index) {
        TextEditingController textController = _controllers[index];

        print("Selected Status List: ${_selectedStatusList}");
        print("Text Field Value: ${_controllers[index].text}");

        return {
          "CheckID": 0,
          "GroupID": items[index].groupId,
          "TypeNo": items[index].typeNo,
          "Value": _selectedStatusList[index],
          "valuedetail": textController.text,
        };
      })
    };

    try {
      final response = await http.post(
        Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ReportModel r = ModalRoute.of(context)!.settings.arguments as ReportModel;

    return Scaffold(
      backgroundColor: primarytitle, // Change background to primarytitle
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),

            // Add Group Name header back
            FutureBuilder<List<ListItem>>(
              future: _sinteringItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No group names found');
                } else {
                  // GroupName Header: Display group names at the top of the screen
                  List<String> uniqueGroupNames = snapshot.data!
                      .map((item) => item.groupName)
                      .toSet()
                      .toList();

                  return Container(
                    height: 50.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: uniqueGroupNames.map((groupName) {
                        bool isSelected = _selectedGroupName == groupName;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGroupName = groupName;
                            });
                          },
                          child: Card(
                            color: isSelected ? primary : secondaryText,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 10.0),
                              child: Text(
                                groupName,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : icons,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }
              },
            ),

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
                  return Column(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      int index = entry.key;
                      ListItem item = entry.value;
                      return _buildCard(
                          item, index, snapshot.data!, snapshot.data!.length);
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            _buildNextButton(r),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(
      ListItem item, int index, List<ListItem> items, int totalItems) {
    if (_selectedGroupName != null && item.groupName != _selectedGroupName) {
      return SizedBox.shrink(); // Skip displaying this card
    }

    TextEditingController textController = _controllers[index];
    bool isLastItem = index == totalItems - 1;
    int itemNumber = _getGroupNumber(items, _selectedGroupName ?? '', index);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: _isFieldEmpty[index]
              ? Colors.red
              : Colors.transparent, // Highlight border if field is empty
          width: 1.5,
        ),
      ),
      color: secondaryText, // Set card background color to secondaryText
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$itemNumber. ${item.typeName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: icons, // Set text color to icons
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                if (item.stdValueMin != null || item.stdValueMax != null)
                  Flexible(
                    // Wrap in Flexible to prevent overflow
                    child: Text(
                      '     Standard: ${item.stdValueMin ?? "N/A"} - ${item.stdValueMax ?? "N/A"}  ${item.unitId ?? ""}',
                      style: TextStyle(
                        fontSize: 14,
                        color: icons, // Set text color to icons
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),

            // Add the button row for Good, No Good, N/A
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatusList[index] = 1; // Good
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: _selectedStatusList[index] == 1
                            ? Colors.green
                            : icons,
                        size: 25.0,
                      ),
                      Text(
                        'Good',
                        style: TextStyle(
                          fontSize: 18,
                          color: _selectedStatusList[index] == 1
                              ? Colors.black
                              : icons,
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatusList[index] = 2; // No Good
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.cancel,
                        color: _selectedStatusList[index] == 2
                            ? Colors.red
                            : icons, // Set default icon color to icons
                        size: 25.0, // Increase icon size
                      ),
                      Text(
                        'No Good',
                        style: TextStyle(
                          fontSize: 18, // Increase text size
                          color: _selectedStatusList[index] == 2
                              ? Colors.black
                              : icons, // Set text color to icons
                        ),
                      ),
                    ],
                  ),
                ),

                // N/A button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStatusList[index] = 3; // N/A
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: _selectedStatusList[index] == 3
                            ? Colors.yellow
                            : icons, // Set default icon color to icons
                        size: 25.0, // Increase icon size
                      ),
                      Text(
                        'N/A',
                        style: TextStyle(
                          fontSize: 18, // Increase text size
                          color: _selectedStatusList[index] == 3
                              ? Colors.black
                              : icons, // Set text color to icons
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Conditionally show the text field only if stdValueMin or stdValueMax is not null
            if (item.stdValueMin != null || item.stdValueMax != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Flexible(
                    // Wrap in Flexible to prevent overflow
                    child: SizedBox(
                      child: TextField(
                        controller: textController,
                        style: const TextStyle(
                          fontSize: 19,
                          color: icons, // Set text color to icons
                          fontFamily: 'MN KhaotomMat',
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: isLastItem
                            ? TextInputType.text
                            : TextInputType.numberWithOptions(
                                decimal: true), // Enable decimal input
                        inputFormatters: isLastItem
                            ? null
                            : <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(RegExp(
                                    r'^\d*\.?\d*')), // Allow digits and a single decimal point
                              ],
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Input Value',
                          labelStyle:
                              TextStyle(color: icons), // Text color in label
                          hintText: 'Input',
                          hintStyle: TextStyle(color: icons), // Hint text color
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 10),
                          isDense: true,
                          suffixText: item.unitId ?? '', // Add unitId as suffix
                          suffixStyle: const TextStyle(
                            fontSize: 16,
                            color: icons, // Suffix color
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: icons, // Border color
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: icons, // Border color on focus
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isFieldEmpty[index] = value.isEmpty;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),

            if (_isFieldEmpty[index])
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red, size: 16),
                    SizedBox(width: 5),
                    Text(
                      'This field is required.',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
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
        onTap: () {
          if (_validateFields()) {
            _sinteringItems.then((items) {
              String fullName = '${user.firstname} ${user.lastname}';
              _postData(items, r.repairid!, username: fullName);
            });
          }
        },
        child: Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(30),
            ),
            alignment: const AlignmentDirectional(0, 0),
            child: const Text(
              'Save',
              style: TextStyle(
                color: background,
                fontSize: 18,
              ),
            )),
      ),
    );
  }
}
