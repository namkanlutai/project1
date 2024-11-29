class CheckList {
  int checkID;
  int typeNo;
  int groupId;
  String repairID;
  DateTime startTime;
  double voltage;
  double current;
  double hv;
  double kw;
  double kwH;
  double hz;
  double f;
  double g;
  double t1;
  double tu;
  double tg;
  double timeOn;
  double timeOff;
  double setemp;
  double actual;
  double kage1;
  double kage3;
  double kage4;
  double coil;
  double yoke;
  double feeder;
  double invPs;
  double tr;
  double m;
  String detailValue;

  CheckList({
    required this.checkID,
    required this.repairID,
    required this.typeNo,
    required this.groupId,
    required this.startTime,
    required this.voltage,
    required this.current,
    required this.hv,
    required this.kw,
    required this.kwH,
    required this.hz,
    required this.f,
    required this.g,
    required this.t1,
    required this.tu,
    required this.tg,
    required this.timeOn,
    required this.timeOff,
    required this.setemp,
    required this.actual,
    required this.kage1,
    required this.kage3,
    required this.kage4,
    required this.coil,
    required this.yoke,
    required this.feeder,
    required this.invPs,
    required this.tr,
    required this.m,
    required this.detailValue,
  });

  CheckList copyWith({
    int? checkID,
    int? typeNo,
    int? groupId,
    String? repairID,
    DateTime? startTime,
    double? voltage,
    double? current,
    double? hv,
    double? kw,
    double? kwH,
    double? hz,
    double? f,
    double? g,
    double? t1,
    double? tu,
    double? tg,
    double? timeOn,
    double? timeOff,
    double? setemp,
    double? actual,
    double? kage1,
    double? kage3,
    double? kage4,
    double? coil,
    double? yoke,
    double? feeder,
    double? invPs,
    double? tr,
    double? m,
    String? detailValue,
  }) {
    return CheckList(
      checkID: checkID ?? this.checkID,
      repairID: repairID ?? this.repairID,
      typeNo: typeNo ?? this.typeNo,
      groupId: groupId ?? this.groupId,
      startTime: startTime ?? this.startTime,
      voltage: voltage ?? this.voltage,
      current: current ?? this.current,
      hv: hv ?? this.hv,
      kw: kw ?? this.kw,
      kwH: kwH ?? this.kwH,
      hz: hz ?? this.hz,
      f: f ?? this.f,
      g: g ?? this.g,
      t1: t1 ?? this.t1,
      tu: tu ?? this.tu,
      tg: tg ?? this.tg,
      timeOn: timeOn ?? this.timeOn,
      timeOff: timeOff ?? this.timeOff,
      setemp: setemp ?? this.setemp,
      actual: actual ?? this.actual,
      kage1: kage1 ?? this.kage1,
      kage3: kage3 ?? this.kage3,
      kage4: kage4 ?? this.kage4,
      coil: coil ?? this.coil,
      yoke: yoke ?? this.yoke,
      feeder: feeder ?? this.feeder,
      invPs: invPs ?? this.invPs,
      tr: tr ?? this.tr,
      m: m ?? this.m,
      detailValue: detailValue ?? this.detailValue,
    );
  }

  // เพิ่มฟังก์ชัน fromJson
  factory CheckList.fromJson(Map<String, dynamic> json) {
    return CheckList(
      checkID: json['checkID'] != null
          ? json['checkID'] as int
          : 0, // ตรวจสอบค่า null
      repairID: json['repairID'] ??
          '', // ตรวจสอบค่า null และตั้งค่าดีฟอลต์เป็น string ว่าง
      typeNo: json['typeNo'] != null ? json['typeNo'] as int : 0,
      groupId: json['groupId'] != null ? json['groupId'] as int : 0,
      startTime: json['StratTime'] != null
          ? DateTime.parse(json['StratTime'])
          : DateTime.now(),
      voltage: json['voltage'] != null ? json['voltage'].toDouble() : 0.0,
      current: json['current'] != null ? json['current'].toDouble() : 0.0,
      hv: json['hv'] != null ? json['hv'].toDouble() : 0.0,
      kw: json['kw'] != null ? json['kw'].toDouble() : 0.0,
      kwH: json['kwH'] != null ? json['kwH'].toDouble() : 0.0,
      hz: json['hz'] != null ? json['hz'].toDouble() : 0.0,
      f: json['f'] != null ? json['f'].toDouble() : 0.0,
      g: json['g'] != null ? json['g'].toDouble() : 0.0,
      t1: json['t1'] != null ? json['t1'].toDouble() : 0.0,
      tu: json['tu'] != null ? json['tu'].toDouble() : 0.0,
      tg: json['tg'] != null ? json['tg'].toDouble() : 0.0,
      timeOn: json['timeOn'] != null ? json['timeOn'].toDouble() : 0.0,
      timeOff: json['timeOff'] != null ? json['timeOff'].toDouble() : 0.0,
      setemp: json['setemp'] != null ? json['setemp'].toDouble() : 0.0,
      actual: json['actual'] != null ? json['actual'].toDouble() : 0.0,
      kage1: json['kage1'] != null ? json['kage1'].toDouble() : 0.0,
      kage3: json['kage3'] != null ? json['kage3'].toDouble() : 0.0,
      kage4: json['kage4'] != null ? json['kage4'].toDouble() : 0.0,
      coil: json['coil'] != null ? json['coil'].toDouble() : 0.0,
      yoke: json['yoke'] != null ? json['yoke'].toDouble() : 0.0,
      feeder: json['feeder'] != null ? json['feeder'].toDouble() : 0.0,
      invPs: json['invPs'] != null ? json['invPs'].toDouble() : 0.0,
      tr: json['tr'] != null ? json['tr'].toDouble() : 0.0,
      m: json['m'] != null ? json['m'].toDouble() : 0.0,
      detailValue:
          json['detailValue'] ?? '', // ตรวจสอบค่า null และตั้งค่าดีฟอลต์
    );
  }
}
