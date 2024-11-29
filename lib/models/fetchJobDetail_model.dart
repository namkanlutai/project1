class JobDetailModelByJobID {
  final String repairID;
  final String task_EN;
  final String customerName;
  final String repairDetail;
  final String repairEmpName;
  final String remark;
  final String jobID;
  final String workLocation;
  final String activityTypeGroupEngName;
  final String truckID;
  final String productionLine;
  final String repairMainDetial;

  JobDetailModelByJobID({
    required this.repairID,
    required this.task_EN,
    required this.customerName,
    required this.repairDetail,
    required this.repairEmpName,
    required this.remark,
    required this.jobID,
    required this.workLocation,
    required this.activityTypeGroupEngName,
    required this.truckID,
    required this.productionLine,
    required this.repairMainDetial,
  });

  // Factory method to create an instance from JSON
  factory JobDetailModelByJobID.fromJson(Map<String, dynamic> json) {
    return JobDetailModelByJobID(
      repairID: json['RepairID'] ?? '',
      task_EN: json['Task_EN'] ?? '',
      customerName: json['CustomerName'] ?? '',
      repairDetail: json['RepairDetail'] ?? '',
      repairEmpName: json['RepairEmpName'] ?? '',
      remark: json['Remark'] ?? '',
      jobID: json['JobID'] ?? '',
      workLocation: json['WorkLocation'] ?? '',
      activityTypeGroupEngName: json['ActivityTypeGroupEngName'] ?? '',
      truckID: json['TruckID'] ?? '',
      productionLine: json['ProductionLine'] ?? '',
      repairMainDetial: json['RepairMainDetial'] ?? '',
    );
  }

  // Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'RepairID': repairID,
      'Task_EN': task_EN,
      'CustomerName': customerName,
      'RepairDetail': repairDetail,
      'RepairEmpName': repairEmpName,
      'Remark': remark,
      'JobID': jobID,
      'WorkLocation': workLocation,
      'ActivityTypeGroupEngName': activityTypeGroupEngName,
      'TruckID': truckID,
      'ProductionLine': productionLine,
      'RepairMainDetial': repairMainDetial,
    };
  }
}
