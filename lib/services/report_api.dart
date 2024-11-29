import 'package:engineer/models/report_model.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReportApi with ChangeNotifier {
  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };

  Future<List<ReportModel>> getReportList(int employeeCode) async {
    final response = await http.get(
      Uri.parse(
          '$baseURLAPI/Engineer/PendingReporting?employeeCode=$employeeCode'),
      headers: _setHeaders(),
    );
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        return reportModelFromJson(response.body);
      } else {
        return [];
      }
    } else {
      return [];
    }
  }
}
