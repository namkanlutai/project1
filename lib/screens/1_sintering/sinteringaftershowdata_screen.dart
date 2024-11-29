import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:signature/signature.dart';
import 'package:photo_view/photo_view.dart';

class showdatasinteringafter extends StatefulWidget {
  final String repairID;
  const showdatasinteringafter({Key? key, required this.repairID})
      : super(key: key);

  @override
  State<showdatasinteringafter> createState() => _titileliningState();
}

class _titileliningState extends State<showdatasinteringafter> {
  UserModel user = UserModel();
  final AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItemsFuture;
  List<ListItem> sinteringItems = [];
  List<bool> _isNormalStates = [];
  List<TextEditingController> _controllers = [];
  final TextEditingController _controllerRemark = TextEditingController();
  List<bool> _isFieldEmpty = []; // List for tracking empty fields
  List<int> requiredIndices = [0, 1, 2]; // Indices of required fields
  List<bool> antennaChecks = [false, false, false, false];
  List<TextEditingController> signatureControllers =
      List.generate(2, (_) => TextEditingController());
  final _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: textprimary, // Set pen color to textprimary
    exportBackgroundColor: Colors.white,
  );

  late Future<List<SinteringValue>> _sinteringValuesFuture;

  @override
  void initState() {
    super.initState();
    getUser();
    _sinteringItemsFuture = _fetchSinteringItems();
    _sinteringValuesFuture = _fetchSinteringValues();
  }

  Future<void> getUser() async {
    try {
      user = await authenticateApi.getUser();
      setState(() {});
    } catch (e) {
      print('Error fetching user: $e');
    }
  }

  Future<List<SinteringValue>> _fetchSinteringValues() async {
    final response = await http.get(Uri.parse(
        'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetValueCheckListSinteringAfter?RepairID=${widget.repairID}&FromID=2'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => SinteringValue.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sintering values');
    }
  }

  Future<List<ListItem>> _fetchSinteringItems() async {
    try {
      sinteringItems = await _apiService.fetchListSinteringtitile();
      _controllers =
          List.generate(sinteringItems.length, (_) => TextEditingController());
      _isNormalStates = List.generate(sinteringItems.length, (_) => false);
      _isFieldEmpty = List.generate(sinteringItems.length, (_) => false);
      return sinteringItems;
    } catch (e) {
      print('Error fetching sintering items: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgprimary, // Set background color to bgprimary
      appBar: AppBar(
        title: Text('RepairID: ${widget.repairID}'),
        backgroundColor: bgprimary, // Set background color for AppBar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ผลการตรวจเช็คผนัง Lining หลังจากการ Sintering',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textprimary), // Set text color to textprimary
              ),
              const SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenImage(
                            imagePath: 'assets/images/lining.png'),
                      ),
                    );
                  },
                  child: Image.asset(
                    'assets/images/lining.png',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _buildListViewSection(),
              _buildSignatureSection(),
              const SizedBox(height: 15),
              _buildSubmitButton(),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListViewSection() {
    return FutureBuilder<List<ListItem>>(
      future: _sinteringItemsFuture,
      builder: (context, itemSnapshot) {
        if (itemSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (itemSnapshot.hasError) {
          return Center(child: Text('Error: ${itemSnapshot.error}'));
        } else if (!itemSnapshot.hasData || itemSnapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          List<ListItem> sortedItems = itemSnapshot.data!;
          sortedItems.sort((a, b) => a.typeNo.compareTo(b.typeNo));

          return FutureBuilder<List<SinteringValue>>(
            future: _sinteringValuesFuture,
            builder: (context, valueSnapshot) {
              if (valueSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (valueSnapshot.hasError) {
                return Center(child: Text('Error: ${valueSnapshot.error}'));
              } else if (!valueSnapshot.hasData ||
                  valueSnapshot.data!.isEmpty) {
                return const Center(child: Text('No values available'));
              } else {
                List<SinteringValue> sortedValues = valueSnapshot.data!;
                sortedValues.sort((a, b) => a.typeNo.compareTo(b.typeNo));

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: sortedItems.length,
                  itemBuilder: (context, index) {
                    final item = sortedItems[index];
                    final value = sortedValues.firstWhere(
                      (v) => v.typeNo == item.typeNo,
                      orElse: () => SinteringValue(typeNo: item.typeNo),
                    );

                    String status;
                    if (value.value == 1) {
                      status = 'ปกติ';
                    } else if (value.value == 2) {
                      status = 'ผิดปกติ';
                    } else {
                      status = value.valueBit ? 'ปกติ' : 'ผิดปกติ';
                    }

                    Color textColor =
                        status == 'ปกติ' ? textprimary : Colors.red;

                    String detailText = '';
                    if (index == 0) {
                      detailText = '  || ค่า: ${value.valuedetail} mA';
                    }

                    return ListTile(
                      title: Text(
                        '${index + 1}. ${item.typeName}',
                        style: TextStyle(
                          color:
                              textColor, // Set text color based on the status
                        ),
                      ),
                      subtitle: value.value > 2
                          ? Text(
                              'สถานะ: $status    |    ค่า: ${value.value} ${item.unitId ?? ''}$detailText',
                              style: TextStyle(
                                color:
                                    textColor, // Set text color based on the status
                              ),
                            )
                          : Text(
                              'สถานะ: $status$detailText',
                              style: TextStyle(
                                color:
                                    textColor, // Set text color based on the status
                              ),
                            ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }

  Widget _buildSignatureSection() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ลายเซ็นลูกค้า',
              style: TextStyle(
                  fontSize: 16,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w800,
                  color: textprimary), // Set text color to textprimary
            ),
            ElevatedButton(
              onPressed: () {
                _controller.clear(); // ล้างลายเซ็นเมื่อกดปุ่ม
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // สีพื้นหลังปุ่มเป็นสีแดง
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'ลบลายเซ็น',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width:
              MediaQuery.of(context).size.width, // ตั้งขนาดตามความกว้างหน้าจอ
          height: 120, // กำหนดความสูงของช่องกรอกลายเซ็น
          decoration: BoxDecoration(
            border: Border.all(
              color: textprimary, // กำหนดสีกรอบให้เป็น textprimary
              width: 2.0, // ความหนาของกรอบ
            ),
            borderRadius: BorderRadius.circular(10), // มุมโค้งของกรอบ
          ),
          child: Signature(
            controller: _controller,
            backgroundColor: Colors.transparent, // สีพื้นหลังโปร่งใส
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        '  ผู้ตรวจสอบ: ${user.firstname} ${user.lastname}',
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w600, color: textprimary),
      ),
    ]);
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _submitForm();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: bluedark, // Set background color to bluedark
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 50, // เพิ่มความกว้างของปุ่ม
            vertical: 10, // เพิ่มความสูงของปุ่ม
          ),
          minimumSize: const Size(200, 60), // ตั้งค่าขนาดขั้นต่ำของปุ่ม
        ),
        child: const Text(
          'Save',
          style:
              TextStyle(color: textprimary, fontSize: 18), // เพิ่มขนาดตัวอักษร
        ), // Set text color to textprimary
      ),
    );
  }

  void _submitForm() {
    String customerSignature = signatureControllers[0].text;
    String inspectorSignature = signatureControllers[1].text;

    if (customerSignature.isEmpty || inspectorSignature.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอกข้อมูลลายเซ็นทั้งหมด')),
      );
      return;
    }

    print('Form submitted successfully.');
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: PhotoView(
          imageProvider: AssetImage(imagePath),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2.0,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black, // Set the background to black for better view
          ),
        ),
      ),
    );
  }
}

class SinteringValue {
  final int typeNo;
  final double value;
  final bool valueBit;
  final String valuedetail;

  SinteringValue({
    required this.typeNo,
    this.value = 0.0,
    this.valueBit = false,
    this.valuedetail = '',
  });

  factory SinteringValue.fromJson(Map<String, dynamic> json) {
    return SinteringValue(
      typeNo: json['TypeNo'],
      value: json['Value'] ?? 0.0,
      valueBit: json['ValueBit'] == true,
      valuedetail: json['valuedetail'] ?? '',
    );
  }
}
