import 'dart:convert';
import 'package:intl/intl.dart'; // Import intl package

class UserModel {
  String? firstname;
  String? lastname;
  int? employeeCode;
  String? imageUrl;
  String? depid;
  DateTime? dateStartJob;

  UserModel({
    this.firstname,
    this.lastname,
    this.employeeCode,
    this.imageUrl,
    this.depid,
    this.dateStartJob,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    print('DepID: ${json['DepID']}'); // Log DepID
    print('Date_StartJob: ${json['Date_StartJob']}'); // Log Date_StartJob

    return UserModel(
      firstname: json['Firstname'] ?? '',
      lastname: json['LastName'] ?? '',
      employeeCode: json['EmployeeCode'] ?? 0,
      imageUrl: json['ImageUrl'] != null
          ? 'https://iot.pinepacific.com/picemp/${json['ImageUrl']}'
          : null,
      depid: json['DepID'] ?? 'N/A',
      dateStartJob: _parseCustomDate(json['Date_StartJob']),
    );
  }

  // Custom date parsing function
  static DateTime? _parseCustomDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return null;
    try {
      // Use intl package to parse the custom date format
      return DateFormat('M/d/yyyy h:mm:ss a').parse(dateStr);
    } catch (e) {
      print('Date parsing failed: $e'); // Log parsing error
      return null;
    }
  }

  // Convert UserModel instance to JSON map

  get username => null;
  // Convert UserModel instance to JSON map
  Map<String, dynamic> toJson() => {
        'firstname': firstname,
        'lastname': lastname,
        'employeeCode': employeeCode,
        //'imageUrl': imageUrl,  // Commented out as requested
      };
}

  // Preserve existing code - get username (if used in future)


  // Convert UserModel instance to JSON map

