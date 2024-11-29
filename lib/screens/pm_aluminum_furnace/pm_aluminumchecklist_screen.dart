import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/pm_aluminum_furnace/widget_button.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class Aluminumchecklist extends StatefulWidget {
  const Aluminumchecklist({super.key});

  @override
  State<Aluminumchecklist> createState() => _TopcastableChecklistState();
}

class _TopcastableChecklistState extends State<Aluminumchecklist> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;
  String? _selectedGroupName;
  Map<String, List<TextEditingController>> _controllers = {};
  Map<String, List<String>> _inputValues =
      {}; // Store input values for each group
  Map<String, Map<int, String>> _buttonSelections =
      {}; // Store button selections by group and index

  @override
  void initState() {
    super.initState();
    getUser();

    // Send FromID to fetchListSintering
    _sinteringItems = _apiService.fetchListItem('10');
    _sinteringItems.then((items) {
      setState(() {
        for (var item in items) {
          if (!_controllers.containsKey(item.groupName)) {
            _controllers[item.groupName] = [];
            _inputValues[item.groupName] = [];
            _buttonSelections[item.groupName] =
                {}; // Initialize button selections
          }
          _controllers[item.groupName]!.add(TextEditingController());
          _inputValues[item.groupName]!.add('');
        }

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

  void _handleValueSelected(
      int index, String selectedValue, String textFieldValue) {
    setState(() {
      _buttonSelections[_selectedGroupName]![index] = selectedValue;
      _controllers[_selectedGroupName]![index].text = textFieldValue;
      _inputValues[_selectedGroupName]![index] = textFieldValue;
    });
  }

  bool _validateFields() {
    bool allValid = true;

    for (int i = 0; i < _controllers[_selectedGroupName]!.length; i++) {
      // Print debug information
      print(
          'Card $i - Selected Value: ${_buttonSelections[_selectedGroupName]![i]}');
      print(
          'Card $i - TextField Value: ${_controllers[_selectedGroupName]![i].text}');

      // Check if a button has been selected in each card (this is mandatory)
      if (_buttonSelections[_selectedGroupName]![i] == null ||
          _buttonSelections[_selectedGroupName]![i]!.isEmpty) {
        allValid = false;
        break; // Exit loop if any card has no selected value
      }
    }

    if (!allValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a button for each card.'),
        ),
      );
    }

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
    // Create JSON data
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 10,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Coil Metal",
      "FurnaceNo": 1,
      "HFT": "2 T",
      "Note": "ทดสอบ App",
      "Details":
          List.generate(_controllers[_selectedGroupName]!.length, (index) {
        return {
          "CheckID": 0,
          "GroupID": items[index].groupId,
          "TypeNo": items[index].typeNo,
          "ValueBit": 1,
          "Value": _buttonSelections[_selectedGroupName]![index] ??
              '', // Use the selected value here
          "valuedetail": _controllers[_selectedGroupName]![index]
              .text, // Save the text field value here
        };
      })
    };

    try {
      // Send the POST request
      final response = await http.post(
        Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(jsonData),
      );

      // Check the response
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
            const Center(
              child: Text(
                'Classification',
                style: TextStyle(letterSpacing: 0, fontSize: 16, color: icons),
              ),
            ),
            const SizedBox(height: 10),
            FutureBuilder<List<ListItem>>(
              future: _sinteringItems,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No group name found');
                } else {
                  List<String> uniqueGroupNames = snapshot.data!
                      .map((item) => item.groupName)
                      .toSet()
                      .toList();

                  return SizedBox(
                    height: 50.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children:
                          List.generate(uniqueGroupNames.length, (int index) {
                        String groupName = uniqueGroupNames.elementAt(index);
                        bool isSelected = _selectedGroupName == groupName;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGroupName = groupName;
                            });
                          },
                          child: Card(
                            color: isSelected ? button : primaryText,
                            child: Container(
                              width: 190.0,
                              height: 50.0,
                              alignment: Alignment.center,
                              child: Text(
                                groupName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      isSelected ? Colors.white : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
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
                  // Group items by groupName
                  Map<String, List<ListItem>> groupedItems = {};
                  for (var item in snapshot.data!) {
                    if (groupedItems.containsKey(item.groupName)) {
                      groupedItems[item.groupName]!.add(item);
                    } else {
                      groupedItems[item.groupName] = [item];
                    }
                  }

                  // Build UI for each group
                  return Column(
                    children: groupedItems.entries.map((entry) {
                      String groupName = entry.key;
                      List<ListItem> items = entry.value;

                      if (groupName != _selectedGroupName)
                        return SizedBox.shrink();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            groupName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          ...items.asMap().entries.map((itemEntry) {
                            int index = itemEntry.key;
                            ListItem item = itemEntry.value;
                            return CardWithButtons(
                              item: item,
                              index: index,
                              items: items,
                              controller:
                                  _controllers[_selectedGroupName]![index],
                              onValueSelected: _handleValueSelected,
                              initialSelectedValue:
                                  _buttonSelections[_selectedGroupName]![
                                      index], // Pass the initial selected value
                            );
                          }).toList(),
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
