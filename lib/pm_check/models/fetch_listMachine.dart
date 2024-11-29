// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MachineModel {
  final String McID;
  final String McName;
  final String McMixID;
  final int SetID;
  MachineModel({
    required this.McID,
    required this.McName,
    required this.McMixID,
    required this.SetID,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'McID': McID,
      'McName': McName,
      'McMixID': McMixID,
      'SetID': SetID,
    };
  }

  factory MachineModel.fromMap(Map<String, dynamic> map) {
    return MachineModel(
      McID: map['McID'] as String,
      McName: map['McName'] as String,
      McMixID: map['McMixID'] as String,
      SetID: map['SetID'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineModel.fromJson(String source) =>
      MachineModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
