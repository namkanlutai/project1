import 'package:http/http.dart' as http;
import 'dart:convert';

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
}

Future<List<CheckItem>> fetchCheckItems(String repairID, int fromID) async {
  final response = await http.get(Uri.parse(
      'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetValueCheckListFormEN?RepairID=$repairID&FromID=$fromID'));

  if (response.statusCode == 200) {
    List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((item) => CheckItem.fromJson(item)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}
