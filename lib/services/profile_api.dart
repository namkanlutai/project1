import 'dart:convert';
import 'package:engineer/models/fetchCreditbalance_model.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfileApi with ChangeNotifier {
  Map<String, String> _setHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<CreditBalance?> getCreditAmount(int employeeCode) async {
    try {
      final response = await http.get(
        Uri.parse('$baseURLAPI/Credit/Balance?Employeecode=$employeeCode'),
        headers: _setHeaders(),
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final jsonData = json.decode(response.body);
          return CreditBalance.fromJson(jsonData);
        } else {
          return null;
        }
      } else {
        debugPrint('Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Exception: $e');
      return null;
    }
  }
}
