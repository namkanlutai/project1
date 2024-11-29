import 'dart:convert';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class SimpleDataTable extends StatefulWidget {
  final String repairID;
  const SimpleDataTable({Key? key, required this.repairID}) : super(key: key);

  @override
  _SimpleDataTableState createState() => _SimpleDataTableState();
}

class _SimpleDataTableState extends State<SimpleDataTable> {
  late Future<List<CheckItem>> _checkListFuture;
  List<bool> _isEditingList = [];
  List<Map<String, dynamic>> editedValues = [];

  @override
  void initState() {
    super.initState();
    _checkListFuture = fetchCheckItems(widget.repairID, 1);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  void toggleEditing(int index) {
    setState(() {
      _isEditingList[index] = !_isEditingList[index];
    });
  }

  void saveEdit(int index, List<CheckItem> checkItems) {
    setState(() {
      _isEditingList[index] = false;
      checkItems[index] =
          checkItems[index].copyWith(dynamicFields: editedValues[index]);
    });
  }

  Widget buildDynamicTable(List<CheckItem> checkItems) {
    // Ensure that editing list is initialized with correct length
    if (_isEditingList.isEmpty) {
      _isEditingList = List.generate(checkItems.length, (_) => false);
      editedValues = List.generate(checkItems.length,
          (index) => Map.from(checkItems[index].dynamicFields));
    }

    final dynamicKeys = checkItems.isNotEmpty
        ? checkItems.first.dynamicFields.keys.toList()
        : [];

    final columns = [
      DataColumn(
        label: Text(
          'No.',
          style: TextStyle(color: textprimary), // สีตัวอักษร textprimary
        ),
      ),
      DataColumn(
        label: Text(
          'StartTime',
          style: TextStyle(color: textprimary), // สีตัวอักษร textprimary
        ),
      ),
      ...dynamicKeys.map((key) {
        return DataColumn(
          label: Tooltip(
            message: key, // Show full text on long press
            child: Text(
              key.length > 10 ? key.substring(0, 10) + '...' : key,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textprimary), // สีตัวอักษร textprimary
            ),
          ),
        );
      }).toList(),
      DataColumn(
        label: Text(
          'Actions',
          style: TextStyle(color: textprimary), // สีตัวอักษร textprimary
        ),
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return DataTable(
                headingRowHeight: 56,
                columnSpacing: 12.0,
                columns: columns,
                rows: checkItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  final DateFormat formatter = DateFormat('yy-MM-dd HH:mm');
                  final String formattedStartTime =
                      formatter.format(data.startTime);

                  return DataRow(
                    cells: [
                      DataCell(Text(
                        (index + 1).toString(),
                        style: TextStyle(
                            color: textprimary), // สีตัวอักษร textprimary
                      )),
                      DataCell(Text(
                        formattedStartTime,
                        style: TextStyle(
                            color: textprimary), // สีตัวอักษร textprimary
                      )),
                      ...dynamicKeys.map((key) {
                        return DataCell(
                          _isEditingList[index]
                              ? TextFormField(
                                  initialValue:
                                      editedValues[index][key].toString(),
                                  onChanged: (value) {
                                    setState(() {
                                      editedValues[index][key] = value;
                                    });
                                  },
                                  style: TextStyle(
                                    color:
                                        orangelight, // สีตัวอักษรตอน edit เป็น orangelight
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            textprimary, // เส้นใต้สี textprimary ตอนไม่ได้เลือก
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            textprimary, // เส้นใต้สี textprimary ตอนเลือกอยู่
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  editedValues[index][key].toString().length >
                                          10
                                      ? editedValues[index][key]
                                              .toString()
                                              .substring(0, 10) +
                                          '...'
                                      : editedValues[index][key].toString(),
                                  style: TextStyle(
                                      color:
                                          textprimary), // สีตัวอักษรปกติ textprimary
                                ),
                        );
                      }).toList(),
                      DataCell(
                        _isEditingList[index]
                            ? Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.save,
                                      color: bluedark, // สีไอคอนเป็น bluedark
                                    ),
                                    onPressed: () {
                                      saveEdit(index, checkItems);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: bluedark, // สีไอคอนเป็น bluedark
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isEditingList[index] = false;
                                      });
                                    },
                                  ),
                                ],
                              )
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: bluedark, // สีไอคอนเป็น bluedark
                                ),
                                onPressed: () {
                                  toggleEditing(index);
                                },
                              ),
                      ),
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          bgprimary, // เปลี่ยนสีพื้นหลังของ Scaffold ทั้งหมดเป็น bgprimary
      appBar: AppBar(
        backgroundColor: bgprimary, // กำหนดสีพื้นหลังของ AppBar
        title: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'CheckList Data Sintering', // ข้อความส่วนกลาง
                  style: TextStyle(
                    color: textprimary, // เปลี่ยนสีตัวอักษรถ้าต้องการ
                  ),
                ),
              ),
            ),
            Text(
              'Repair: ${widget.repairID}', // ข้อความที่ชิดขวา
              style: TextStyle(
                color: textprimary, // เปลี่ยนสีตัวอักษรถ้าต้องการ
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: bgprimary, // เปลี่ยนสีพื้นหลังของหน้าจอหลักเป็น bgprimary
        child: FutureBuilder<List<CheckItem>>(
          future: _checkListFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              return SingleChildScrollView(
                child: buildDynamicTable(snapshot.data!),
              );
            }
          },
        ),
      ),
    );
  }
}

class CheckItem {
  final int checkID;
  final String repairID;
  final DateTime startTime;
  final Map<String, dynamic> dynamicFields;

  CheckItem({
    required this.checkID,
    required this.repairID,
    required this.startTime,
    required this.dynamicFields,
  });

  factory CheckItem.fromJson(Map<String, dynamic> json) {
    return CheckItem(
      checkID: json['CheckID'],
      repairID: json['RepairID'],
      startTime: DateTime.parse(json['StratTime']),
      dynamicFields: Map<String, dynamic>.from(json)
        ..removeWhere(
            (key, _) => ['CheckID', 'RepairID', 'StratTime'].contains(key)),
    );
  }

  CheckItem copyWith({
    int? checkID,
    String? repairID,
    DateTime? startTime,
    Map<String, dynamic>? dynamicFields,
  }) {
    return CheckItem(
      checkID: checkID ?? this.checkID,
      repairID: repairID ?? this.repairID,
      startTime: startTime ?? this.startTime,
      dynamicFields: dynamicFields ?? this.dynamicFields,
    );
  }
}

Future<List<CheckItem>> fetchCheckItems(String repairID, int fromID) async {
  final url = Uri.parse(
      'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetValueCheckListFormEN?RepairID=$repairID&FromID=$fromID');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = jsonDecode(response.body);

      if (jsonResponse.isEmpty) {
        throw Exception('No data available from the server.');
      }

      return jsonResponse.map((item) => CheckItem.fromJson(item)).toList();
    } else {
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  } catch (error) {
    throw Exception('An error occurred while fetching data: $error');
  }
}
