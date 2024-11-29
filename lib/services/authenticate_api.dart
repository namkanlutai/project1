import 'dart:convert';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticateApi with ChangeNotifier {
  Map<String, String> _setHeaders() {
    return {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<UserModel> login(String username, String password) async {
    final response = await http.get(
      Uri.parse(
          '$baseURLAPI/Credit/authen?username=$username&password=$password'),
      headers: _setHeaders(),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print('Login Response: $result'); // Log the full response

      // Create UserModel instance from JSON
      UserModel user = UserModel.fromJson(result);
      print(
          'Parsed User: DepID - ${user.depid}, Start Date - ${user.dateStartJob}'); // Log parsed values

      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('employeeCode', result['EmployeeCode'] ?? 0);
      prefs.setString('firstname', result['Firstname'] ?? '');
      prefs.setString('lastname', result['LastName'] ?? '');
      prefs.setString('imageUrl', result['ImageUrl'] ?? '');
      prefs.setString('depid', result['DepID'] ?? 'N/A');
      prefs.setString('date_StartJob', result['Date_StartJob'] ?? '');

      notifyListeners();
      return user;
    } else {
      throw Exception('Failed to login');
    }
  }

  // Future<UserModel> login(String username, String password) async {
  //   final response = await http.get(
  //     Uri.parse(
  //         '$baseURLAPI/Credit/authen?username=$username&password=$password'),
  //     headers: _setHeaders(),
  //   );

  //   final prefs = await SharedPreferences.getInstance();
  //   if (response.statusCode == 200) {
  //     var result = jsonDecode(response.body);
  //     prefs.setInt('employeeCode', result['EmployeeCode'] ?? 0);
  //     prefs.setString('firstname', result['Firstname'] ?? '');
  //     prefs.setString('lastname', result['LastName'] ?? '');
  //     prefs.setString('imageUrl', result['ImageUrl'] ?? '');
  //     prefs.setString('depid', result['DepID'] ?? '');
  //     prefs.setString('date_StartJob', result['Date_StartJob'] ?? '');

  //     notifyListeners();

  //     // Directly parse JSON into UserModel
  //     return UserModel.fromJson(result);
  //   } else {
  //     throw Exception('Failed to login');
  //   }
  // }

  Future<UserModel> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return UserModel(
        firstname: prefs.getString('firstname') ?? '',
        lastname: prefs.getString('lastname') ?? '',
        employeeCode: prefs.getInt('employeeCode') ?? 0,
        imageUrl:
            'https://iot.pinepacific.com/picemp/${prefs.getString('imageUrl')}');
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.clear();
  }
}
