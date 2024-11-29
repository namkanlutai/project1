// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class StandardsModel {
  final int MsNo;
  final String McID;
  final String MsDetail;
  final double MsMin;
  final double MsMax;
  final String UnitID;
  final int MsOrder;
  StandardsModel({
    required this.MsNo,
    required this.McID,
    required this.MsDetail,
    required this.MsMin,
    required this.MsMax,
    required this.UnitID,
    required this.MsOrder,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'MsNo': MsNo,
      'McID': McID,
      'MsDetail': MsDetail,
      'MsMin': MsMin,
      'MsMax': MsMax,
      'UnitID': UnitID,
      'MsOrder': MsOrder,
    };
  }

  factory StandardsModel.fromMap(Map<String, dynamic> map) {
    return StandardsModel(
      MsNo: (map['MsNo'] ?? 0) as int,
      McID: (map['McID'] ?? '') as String,
      MsDetail: map['MsDetail'] as String,
      MsMin: (map['MsMin'] ?? 0.0) as double,
      MsMax: (map['MsMax'] ?? 0.0) as double,
      UnitID: (map['UnitID'] ?? '') as String,
      MsOrder: (map['MsOrder'] ?? 0) as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StandardsModel.fromJson(String source) =>
      StandardsModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
