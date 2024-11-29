class CreditBalance {
  final int employeeCode;
  final String fullName;
  final double amount;
  final String lineID;

  CreditBalance({
    required this.employeeCode,
    required this.fullName,
    required this.amount,
    required this.lineID,
  });

  // Factory method to create an instance from JSON
  factory CreditBalance.fromJson(Map<String, dynamic> json) {
    return CreditBalance(
      employeeCode: json['EmloyeeCode'] ?? 0,
      fullName: json['FullName'] ?? '',
      amount: (json['Amount'] ?? 0).toDouble(),
      lineID: json['LineID'] ?? '',
    );
  }

  // Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'EmloyeeCode': employeeCode,
      'FullName': fullName,
      'Amount': amount,
      'LineID': lineID,
    };
  }
}
