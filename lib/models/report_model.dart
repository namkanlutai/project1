import 'dart:convert';

// Function to decode JSON into a List of ReportModel
List<ReportModel> reportModelFromJson(String str) => List<ReportModel>.from(
    json.decode(str).map((x) => ReportModel.fromJson(x)));

// Function to encode a List of ReportModel into JSON
String reportModelToJson(List<ReportModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportModel {
  String? repairid;
  String? jobid;
  int? jobtypeid;
  String? customerid;
  String? shortname;
  String? companyName;
  DateTime? dateCallJob;
  DateTime? datePlanFinish;
  String? contactperson;
  int? busmappingid;
  DateTime? planfromWorktime;
  DateTime? plantoWorktime;
  String? employeecode;
  String? firstname;
  String? lastname;
  String? repairEmpName;
  bool? isleader;
  int? jtId;
  String? jtName;
  String? repairdetail;
  String? description;
  String? companyContact1;
  String? companyContact2;
  String? companyContact3;
  String? companyContact4;
  String? companyContact5;

  ReportModel({
    this.repairid,
    this.jobid,
    this.jobtypeid,
    this.customerid,
    this.shortname,
    this.companyName,
    this.dateCallJob,
    this.datePlanFinish,
    this.contactperson,
    this.busmappingid,
    this.planfromWorktime,
    this.plantoWorktime,
    this.employeecode,
    this.firstname,
    this.lastname,
    this.repairEmpName,
    this.isleader,
    this.jtId,
    this.jtName,
    this.repairdetail,
    this.description,
    this.companyContact1,
    this.companyContact2,
    this.companyContact3,
    this.companyContact4,
    this.companyContact5,
  });

  // Factory constructor to create ReportModel from JSON
  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        repairid: json["RepairID"] as String?,
        jobid: json["JobID"] as String?,
        jobtypeid: json["JobTypeID"] as int?,
        customerid: json["CustomerID"] as String?,
        shortname: json["ShortName"] as String?,
        companyName: json["CompanyName"] as String?,
        dateCallJob: json["DateCallJob"] != null &&
                json["DateCallJob"].toString().isNotEmpty
            ? DateTime.parse(json["DateCallJob"])
            : null,
        datePlanFinish: json["DatePlanFinish"] != null &&
                json["DatePlanFinish"].toString().isNotEmpty
            ? DateTime.parse(json["DatePlanFinish"])
            : null,
        contactperson: json["ContactPerson"] as String?,
        busmappingid: json["BusMappingID"] as int?,
        planfromWorktime: json["PlanFromWorkTime"] != null &&
                json["PlanFromWorkTime"].toString().isNotEmpty
            ? DateTime.parse(json["PlanFromWorkTime"])
            : null,
        plantoWorktime: json["PlanToWorkTime"] != null &&
                json["PlanToWorkTime"].toString().isNotEmpty
            ? DateTime.parse(json["PlanToWorkTime"])
            : null,
        employeecode: json["EmployeeCode"] as String?,
        firstname: json["EmpEName"] as String?,
        lastname: json["EmpELName"] as String?,
        repairEmpName: json["RepairEmpName"] as String?,
        isleader: json["isLeader"] as bool?,
        jtId: json["JT_ID"] as int?,
        jtName: json["JT_Name"] as String?,
        repairdetail: json["RepairDetail"] as String?,
        description: json["Description"] as String?,
        companyContact1: json["CompanyContact1"] as String?,
        companyContact2: json["CompanyContact2"] as String?,
        companyContact3: json["CompanyContact3"] as String?,
        companyContact4: json["CompanyContact4"] as String?,
        companyContact5: json["CompanyContact5"] as String?,
      );

  factory ReportModel.fromMap(Map<String, dynamic> map) =>
      ReportModel.fromJson(map);

  // Method to convert ReportModel to JSON
  Map<String, dynamic> toJson() => {
        "RepairID": repairid,
        "JobID": jobid,
        "JobTypeID": jobtypeid,
        "CustomerID": customerid,
        "ShortName": shortname,
        "CompanyName": companyName,
        "DateCallJob": dateCallJob?.toIso8601String(),
        "DatePlanFinish": datePlanFinish?.toIso8601String(),
        "ContactPerson": contactperson,
        "BusMappingID": busmappingid,
        "PlanFromWorkTime": planfromWorktime?.toIso8601String(),
        "PlanToWorkTime": plantoWorktime?.toIso8601String(),
        "EmployeeCode": employeecode,
        "EmpEName": firstname,
        "EmpELName": lastname,
        "RepairEmpName": repairEmpName,
        "isLeader": isleader,
        "JT_ID": jtId,
        "JT_Name": jtName,
        "RepairDetail": repairdetail,
        "Description": description,
        "CompanyContact1": companyContact1,
        "CompanyContact2": companyContact2,
        "CompanyContact3": companyContact3,
        "CompanyContact4": companyContact4,
        "CompanyContact5": companyContact5,
      };

  Map<String, dynamic> toMap() => toJson();
}
