import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/4_repair_coil/widget/widget_button_0_1.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class repair_coilcheck0_1 extends StatefulWidget {
  const repair_coilcheck0_1({super.key});

  @override
  State<repair_coilcheck0_1> createState() => _RepairCoilCheck01State();
}

class _RepairCoilCheck01State extends State<repair_coilcheck0_1> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;
  Map<String, List<TextEditingController>> _controllers = {};
  Map<String, List<String>> _inputValues = {};
  Map<String, Map<int, String>> _buttonSelections = {};

  @override
  void initState() {
    super.initState();
    getUser();

    _sinteringItems = _apiService.fetchListItem('12');
    _sinteringItems.then((items) {
      setState(() {
        for (var item in items) {
          if (!_controllers.containsKey(item.groupName)) {
            _controllers[item.groupName] = [];
            _inputValues[item.groupName] = [];
            _buttonSelections[item.groupName] = {};
          }
          _controllers[item.groupName]!.add(TextEditingController());
          _inputValues[item.groupName]!.add('');
        }
      });
    });
  }

  Future<void> getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  void _handleValueSelected(int index, String selectedValue,
      String textFieldValue, String groupName) {
    setState(() {
      _buttonSelections[groupName]![index] = selectedValue;
      _controllers[groupName]![index].text = textFieldValue;
      _inputValues[groupName]![index] = textFieldValue;
    });
  }

  bool _validateFields() {
    print('Validating fields...');
    bool allValid = true;
    for (var groupName in _controllers.keys) {
      for (int i = 0; i < _controllers[groupName]!.length; i++) {
        print(
            'Group: $groupName, Card $i - Selected Value: ${_buttonSelections[groupName]![i]}');
        print(
            'Group: $groupName, Card $i - TextField Value: ${_controllers[groupName]![i].text}');

        if (_buttonSelections[groupName]![i] == null ||
            _buttonSelections[groupName]![i]!.isEmpty) {
          allValid = false;
          print('Validation failed at group: $groupName, card: $i');
          break;
        }
      }
      if (!allValid) {
        break;
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a button for each card.'),
        ),
      );
    }

    print('Validation result: $allValid');
    return allValid;
  }

  @override
  void dispose() {
    for (var controllerList in _controllers.values) {
      for (var controller in controllerList) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  Future<void> _postData(List<ListItem> items, String repairId,
      {String? username}) async {
    List<Map<String, dynamic>> details = [];

    // Group items by groupName for easier access
    Map<String, List<ListItem>> groupedItems = {};
    for (var item in items) {
      if (!groupedItems.containsKey(item.groupName)) {
        groupedItems[item.groupName] = [];
      }
      groupedItems[item.groupName]!.add(item);
    }

    // Log the entire items list for debugging
    print('Logging all SinteringItems:');
    for (var item in items) {
      print(
          'Item: groupName: ${item.groupName}, typeNo: ${item.typeNo}, groupId: ${item.groupId}');
    }

    // Iterate over each group to aggregate the data
    for (var groupName in _controllers.keys) {
      List<ListItem>? groupItems = groupedItems[groupName];
      if (groupItems == null) {
        print('Error: No items found for groupName: $groupName');
        continue;
      }

      for (int index = 0; index < _controllers[groupName]!.length; index++) {
        try {
          // Ensure the index is within bounds
          if (index >= groupItems.length) {
            throw Exception(
                'Item not found for groupName: $groupName at index: $index');
          }

          ListItem item = groupItems[index];

          details.add({
            "CheckID": 0,
            "GroupID": item.groupId,
            "TypeNo": item.typeNo,
            "ValueBit": 1,
            "Value": _buttonSelections[groupName]![index] ?? '',
            "valuedetail": _controllers[groupName]![index].text,
          });
        } catch (e) {
          print('Error: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
          return; // Exit the function if there's an error
        }
      }
    }

    // Create JSON data
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 12,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Repair Coil 0.1",
      "FurnaceNo": 1,
      "HFT": "2 T",
      "Note": "ทดสอบ App",
      "Details": details
    };

    print('Posting data: $jsonData');

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
        Navigator.pop(
          context,
        );
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
      print('Error during post: $e'); // Additional error logging
    }
  }

  @override
  Widget build(BuildContext context) {
    ReportModel r = ModalRoute.of(context)!.settings.arguments as ReportModel;

    return Scaffold(
      backgroundColor: primarytitle,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
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
                  Map<String, List<ListItem>> groupedItems = {};
                  for (var item in snapshot.data!) {
                    if (groupedItems.containsKey(item.groupName)) {
                      groupedItems[item.groupName]!.add(item);
                    } else {
                      groupedItems[item.groupName] = [item];
                    }
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: groupedItems.entries.map((entry) {
                      String groupName = entry.key;
                      List<ListItem> items = entry.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                                letterSpacing: 0, fontSize: 16, color: icons),
                          ),
                          const SizedBox(height: 10),
                          ...items.asMap().entries.map((itemEntry) {
                            int index = itemEntry.key;
                            ListItem item = itemEntry.value;
                            return CardWithButtonsrepaircoil_0_1(
                              item: item,
                              index: index,
                              items: items,
                              controller: _controllers[groupName]![index],
                              onValueSelected: (selectedIndex, selectedValue,
                                  textFieldValue) {
                                _handleValueSelected(selectedIndex,
                                    selectedValue, textFieldValue, groupName);
                              },
                              initialSelectedValue:
                                  _buttonSelections[groupName]![index],
                            );
                          }).toList(),
                          const SizedBox(height: 20),
                        ],
                      );
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

  Widget _buildNextButton(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(80, 0, 80, 5),
      child: InkWell(
        onTap: () {
          print('Save button tapped');
          if (_validateFields()) {
            _sinteringItems.then((items) {
              String fullName = '${user.firstname} ${user.lastname}';
              _postData(items, r.repairid!, username: fullName);
            }).catchError((e) {
              print('Error fetching items: $e');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error fetching items: $e')),
              );
            });
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
