import 'dart:convert';

class GetRepair_Pim {
  final String MT_ID;
  final String MT_Date;
  final String McID;
  final String McName;
  final int CompanyID;
  final String MT_Detail;
  final String MT_Engineer;
  GetRepair_Pim({
    required this.MT_ID,
    required this.MT_Date,
    required this.McID,
    required this.McName,
    required this.CompanyID,
    required this.MT_Detail,
    required this.MT_Engineer,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'MT_ID': MT_ID,
      'MT_Date': MT_Date,
      'McID': McID,
      'McName': McName,
      'CompanyID': CompanyID,
      'MT_Detail': MT_Detail,
      'MT_Engineer': MT_Engineer,
    };
  }

  factory GetRepair_Pim.fromMap(Map<String, dynamic> map) {
    return GetRepair_Pim(
      MT_ID: (map['MT_ID'] ?? '') as String,
      MT_Date: (map['MT_Date'] ?? '') as String,
      McID: (map['McID'] ?? '') as String,
      McName: (map['McName'] ?? '') as String,
      CompanyID: (map['CompanyID'] ?? 0) as int,
      MT_Detail: (map['MT_Detail'] ?? '') as String,
      MT_Engineer: (map['MT_Engineer'] ?? '') as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory GetRepair_Pim.fromJson(String source) =>
      GetRepair_Pim.fromMap(json.decode(source) as Map<String, dynamic>);
}
