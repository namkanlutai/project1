// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ListItem {
  final int groupId;
  final String groupName;
  final int pageStep;
  final int typeNo;
  final int fromId;
  final String typeName;
  final dynamic stdValueMin;
  final dynamic stdValueMax;
  final String typeValue;
  final dynamic unitId;
  final bool active;
  final String detailValue;

  ListItem({
    required this.groupId,
    required this.groupName,
    required this.pageStep,
    required this.typeNo,
    required this.fromId,
    required this.typeName,
    this.stdValueMin,
    this.stdValueMax,
    required this.typeValue,
    this.unitId,
    required this.active,
    required this.detailValue,
  });

  factory ListItem.fromJson(Map<String, dynamic> json) {
    return ListItem(
      groupId: json['GroupID'] ?? 0,
      groupName: json['GroupName'] ?? '',
      pageStep: json['PageStep'] ?? 0,
      typeNo: json['TypeNo'] ?? 0,
      fromId: json['FromID'] ?? 0,
      typeName: json['TypeName'] ?? '',
      stdValueMin: json['StdValueMin'] ?? 0.0,
      stdValueMax: json['StdValueMax'] ?? 0.0,
      typeValue: json['TypeValue'] ?? '',
      unitId: json['UnitID'] ?? '',
      active: json['Active'] ?? false,
      detailValue: json['DetailValue'] ?? '',
    );
  }
}
