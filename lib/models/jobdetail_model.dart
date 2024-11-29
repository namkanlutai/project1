import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

List<JobDetailModel> jobDetailModelFromJson(String str) =>
    List<JobDetailModel>.from(
        json.decode(str).map((x) => JobDetailModel.fromJson(x)));

String jobDetailModelToJson(List<JobDetailModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JobDetailModel {
  int? programid;
  String? jobid;
  int? jobitem;
  String? detail;
  DateTime? fromworktime;
  DateTime? toworktime;
  DateTime? fromot;
  DateTime? toot;
  String? plandate;
  String? repairid;
  int? approvestatusid;
  DateTime? planfromworktime;
  DateTime? plantoworktime;
  DateTime? planfromot;
  DateTime? plantoot;
  String? empname;
  String? worklocation;
  String? truckid;
  int? isclose;
  int? employeecode;
  String? customername;
  String? vehicle;
  JobDetailModel({
    this.programid,
    this.jobid,
    this.jobitem,
    this.detail,
    this.fromworktime,
    this.toworktime,
    this.fromot,
    this.toot,
    this.plandate,
    this.repairid,
    this.approvestatusid,
    this.planfromworktime,
    this.plantoworktime,
    this.planfromot,
    this.plantoot,
    this.empname,
    this.worklocation,
    this.truckid,
    this.isclose,
    this.employeecode,
    this.customername,
    this.vehicle,
  });

  factory JobDetailModel.fromJson(Map<String, dynamic> json) {
    return JobDetailModel(
      programid: json['ProgramID'],
      jobid: json['JobID'],
      jobitem: json['JobItem'],
      detail: json['RepairDetail'],
      fromworktime: DateTime.parse(json['FromWorkTime']),
      toworktime: DateTime.parse(json['ToWorkTime']),
      fromot: DateTime.parse(json['FromOT']),
      toot: DateTime.parse(json['ToOT']),
      plandate: json['FromDate'],
      repairid: json['RepairID'],
      approvestatusid: json['ApproveStatusID'],
      planfromworktime: DateTime.parse(json['PlanFromWorkTime']),
      plantoworktime: DateTime.parse(json['PlanToWorkTime']),
      planfromot: DateTime.parse(json['PlanFromOT']),
      plantoot: DateTime.parse(json['PlanToOT']),
      empname: json['RepairEmpName'],
      worklocation: json['WorkLocation'],
      truckid: json['TruckID'],
      isclose: json['JobStatus'],
      employeecode: int.parse(json['EmployeeCode']),
      customername: json['CustomerName'],
      vehicle: json['TruckID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'ProgramID': programid,
        'JobID': jobid,
        'JobItem': jobitem,
        'RepairDetail': detail,
        'FromWorkTime': fromworktime,
        'ToWorkTime': toworktime,
        'FromOT': fromot,
        'ToOT': toot,
        'FromDate': plandate,
        'RepairID': repairid,
        'ApproveStatusID': approvestatusid,
        'PlanFromWorkTime': planfromworktime,
        'PlanToWorkTime': plantoworktime,
        'PlanFromOT': planfromot,
        'PlanToOT': plantoot,
        'RepairEmpName': empname,
        'WorkLocation': worklocation,
        'TruckID': truckid,
        'JobStatus': isclose,
        'EmployeeCode': employeecode,
        'CustomerName': customername,
      };
}

class JobProvider with ChangeNotifier {
  Future<bool> fetchTimeStampJob(JobDetailModel job) async {
    var apiUrl = 'https://iot.pinepacific.com/WebApi/api/Engineer/TimeStamp';
    final response = await http.post(Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<dynamic, String>{
          "ProgramID": job.programid.toString(),
          "JobID": job.jobid.toString(),
          "JobItem": job.jobitem.toString(),
          "approveStatusID": job.approvestatusid.toString(),
          "FromWorkTime": job.fromworktime.toString(),
          "ToWorkTime": job.toworktime.toString(),
          "FromOT": job.fromot.toString(),
          "ToOT": job.toot.toString(),
          "JobStatus": job.isclose.toString(),
          "NoteFromEmp": "",
        }));
    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<bool> fetchAddNewTimeStampJob(JobDetailModel job) async {
    var apiUrl = 'https://iot.pinepacific.com/WebApi/api/Engineer/NewTimestamp';

    // Safely handling potentially null values
    final repairEmpName = job.empname ?? ''; // Fallback to empty string if null
    final workLocation = job.worklocation ?? '';

    // Debugging: Print the data that will be sent
    debugPrint("Sending Data to API:");
    debugPrint("ProgramID: ${job.programid}");
    debugPrint("JobID: ${job.jobid}");
    debugPrint("JobItem: ${job.jobitem}");
    debugPrint("RepairDetail: ${job.detail}");
    debugPrint("EmployeeCode: ${job.employeecode}");
    debugPrint("RepairEmpName: $repairEmpName");
    debugPrint("workLocation: $workLocation");
    debugPrint("approveStatusID: ${job.approvestatusid}");
    debugPrint("FromWorkTime: ${job.fromworktime?.toString()}");
    debugPrint("ToWorkTime: ${job.toworktime?.toString()}");
    debugPrint("FromOT: ${job.fromot?.toString()}");
    debugPrint("ToOT: ${job.toot?.toString()}");
    debugPrint("JobStatus: ${job.isclose}");

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "ProgramID": job.programid.toString(),
        "JobID": job.jobid.toString(),
        "JobItem": job.jobitem.toString(),
        "RepairDetail": job.detail ?? "", // Providing a default empty string
        "EmployeeCode": job.employeecode.toString(),
        "RepairEmpName": repairEmpName,
        "workLocation": workLocation,
        "approveStatusID": job.approvestatusid.toString(),
        "FromWorkTime":
            job.fromworktime?.toString() ?? "", // Handle null DateTime
        "ToWorkTime": job.toworktime?.toString() ?? "", // Handle null DateTime
        "FromOT": job.fromot?.toString() ?? "", // Handle null DateTime
        "ToOT": job.toot?.toString() ?? "", // Handle null DateTime
        "JobStatus": job.isclose.toString(),
        "NoteFromEmp": "", // Assuming no additional note for now
      }),
    );

    // Checking the response status and handling errors
    if (response.statusCode == 200) {
      return true;
    } else {
      // Logging detailed error information
      debugPrint("API error: ${response.statusCode} - ${response.body}");
      throw Exception(
          'Failed to load data. Error code: ${response.statusCode}');
    }
  }
}
