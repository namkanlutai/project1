import 'package:engineer/models/fetchJobDetail_model.dart';
import 'package:engineer/models/jobdetail_model.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JobDetailApi {
  Map<String, String> _setHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  Future<List<JobDetailModel>> getJobDetails(
      String begindate, String enddate, int employeecode) async {
    final url =
        '$baseURLAPI/Engineer/GetService?beginDate=$begindate&endDate=$enddate&employeeCode=$employeecode';
    final response = await http.get(Uri.parse(url), headers: _setHeaders());

    debugPrint('Calling: $url');
    debugPrint('Status Code: ${response.statusCode}');
    debugPrint('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        try {
          return jobDetailModelFromJson(response.body);
        } catch (e) {
          debugPrint('Decoding Error: $e');
          throw Exception('Failed to decode job details.');
        }
      } else {
        debugPrint('Empty response from API.');
        return [];
      }
    } else {
      debugPrint(
          'API Error: ${response.statusCode} - ${response.reasonPhrase}');
      throw Exception('Failed to fetch job details.');
    }
  }

  // Modified method to handle multiple job details (for multiple employees)
  Future<List<JobDetailModelByJobID>?> getJobDetailByJobID(String jobId) async {
    try {
      final url = '$baseURLAPI/Engineer/GetServiceByJobId?JobID=$jobId';
      final response = await http.get(Uri.parse(url), headers: _setHeaders());

      debugPrint('Calling: $url');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          return jsonData
              .map((item) => JobDetailModelByJobID.fromJson(item))
              .toList();
        } else {
          debugPrint('No job details found.');
          return [];
        }
      } else {
        throw Exception(
            'Failed to fetch job details. Status: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching job details: $e');
      return null;
    }
  }
}
