import 'dart:convert';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/2_coil/coilcementshowdata_screen.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class repair_coilcheck0_2 extends StatefulWidget {
  const repair_coilcheck0_2({super.key});

  @override
  State<repair_coilcheck0_2> createState() => _TopcastableChecklistState();
}

class _TopcastableChecklistState extends State<repair_coilcheck0_2> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItems;
  List<TextEditingController> _controllers = [];
  List<bool> _isFieldEmpty = [];
  String? _selectedGroupName;

  @override
  void initState() {
    super.initState();
    getUser();

    // Send FromID to fetchListSintering
    _sinteringItems = _apiService.fetchListItem('13');

    _sinteringItems.then((items) {
      setState(() {
        _controllers = List.generate(
          items.length,
          (_) => TextEditingController(),
        );
        _isFieldEmpty = List.generate(items.length, (_) => false);

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
    List<int> requiredIndices = [0, 1, 2]; // 0-based index for 1, 2, 3, and 8
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
    // Create JSON data
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 13,
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
        bool isLastItem = index == items.length - 1;
        return {
          "CheckID": 0,
          "GroupID": items[index].groupId,
          "TypeNo": items[index].typeNo,
          "ValueBit": 1,
          "Value": textController.text,
          "valuedetail": isLastItem ? textController.text : "",
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
      backgroundColor: background,
      resizeToAvoidBottomInset: false,
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

  Widget _buildHeader(ReportModel r) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null && arguments is ReportModel) {
      r = arguments;
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error: No report data provided.'),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: background,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'กำหนดวางแผนการทำงาน (Schedule)',
                      style: TextStyle(
                        letterSpacing: 0,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (r.repairid != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => coilcementshowdata(
                              repairID: r.repairid!,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Repair ID is missing')),
                        );
                      }
                    },
                    child: const Text('Data Check'),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Center(
                child: Text(
                  'Detail',
                  style: const TextStyle(letterSpacing: 0, fontSize: 16),
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
                    // Filter out duplicate groupNames
                    List<String> uniqueGroupNames = snapshot.data!
                        .map((item) => item.groupName)
                        .toSet()
                        .toList();

                    return SizedBox(
                      height: 80.0,
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
                                width: 100.0,
                                //height: 50.0,
                                alignment: Alignment.center,

                                child: Text(
                                  groupName,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white,
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
            ],
          ),
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
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  // Wrap in Flexible to prevent overflow
                  child: SizedBox(
                    width: 300,
                    child: TextField(
                      controller: textController,
                      style: const TextStyle(
                        fontSize: 19,
                        color: primaryText,
                        fontFamily: 'MN KhaotomMat',
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: isLastItem
                          ? TextInputType.text
                          : TextInputType.number,
                      inputFormatters: isLastItem
                          ? null
                          : <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Input Value',
                        hintText: 'Input',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 10),
                        isDense: true,
                        suffixText: item.unitId ?? '', // Add unitId as suffix
                        suffixStyle: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
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
