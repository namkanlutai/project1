import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/report_model.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/screens/1_sintering/sinteringaftershowdata_screen.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:photo_view/photo_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class titilelining extends StatefulWidget {
  final DateTime timestamp;

  const titilelining({
    Key? key,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<titilelining> createState() => _titileliningState();
}

class _titileliningState extends State<titilelining> {
  UserModel user = UserModel();
  final AuthenticateApi authenticateApi = AuthenticateApi();
  final ApiService _apiService = ApiService();
  late Future<List<ListItem>> _sinteringItemsFuture;
  List<ListItem> sinteringItems = [];
  List<bool> _isFieldEmpty = []; // Updated to check field emptiness
  List<TextEditingController> _controllers = [];
  final TextEditingController _controllerRemark = TextEditingController();
  List<int> _buttonStates =
      []; // Use int to represent states: -1 (none), 0 (Not Normal), 1 (Normal)

  @override
  void initState() {
    super.initState();
    getUser();
    _sinteringItemsFuture = _fetchSinteringItems();
  }

  Future<void> getUser() async {
    try {
      user = await authenticateApi.getUser();
      setState(() {});
    } catch (e) {
      // Handle user fetch error
      print('Error fetching user: $e');
    }
  }

  Future<void> _postData(List<ListItem> items, String repairId,
      {String? username}) async {
    if (_controllers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No data to save')),
      );
      return;
    }

    bool hasError = false;
    String errorMessage = ""; // Keep track of error messages

    List<Map<String, dynamic>> details = [];
    for (int index = 0; index < items.length; index++) {
      final item = items[index];
      final textController = _controllers[index];
      final textValue = textController.text;

      // Debugging logs to help diagnose where the error occurs
      print(
          'Item $index - Button State: ${_buttonStates[index]}, Value: $textValue');

      // Check if the user has not selected "ปกติ" or "ผิดปกติ"
      if (_buttonStates[index] == -1) {
        hasError = true;
        errorMessage =
            'Error: Please select Normal or Not Normal for item ${index + 1}';
        print(errorMessage);
        break; // Stop the loop as an error was found
      }

      // Check if the first field is required
      if (index == 0 && textValue.isEmpty) {
        hasError = true;
        errorMessage = 'Error: Input value is missing for item ${index + 1}';
        print(errorMessage);
        break;
      }

      // Store the button state in "Value" and the input value in "valuedetail"
      final valueToSave =
          (_buttonStates[index] == 1 ? '1' : '2'); // Normal = 1, Not Normal = 2
      final detailValueToSave = textValue.isNotEmpty
          ? textValue
          : ""; // TextField value in valuedetail

      details.add({
        "CheckID": 0,
        "GroupID": item.groupId,
        "TypeNo": item.typeNo,
        "Value": valueToSave, // Store the button selection in "Value"
        "valuedetail":
            detailValueToSave, // Store the TextField input in "valuedetail"
      });
    }

    // If there's an error, display the appropriate error message
    if (hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
      return;
    }

    // Prepare the JSON data for posting
    Map<String, dynamic> jsonData = {
      "RepairID": repairId,
      "CheckID": 0,
      "FromID": 2,
      "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
      "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      "EngineerBy": username ?? 'Unknown',
      "CusCompanyName": username ?? 'Unknown',
      "TypeDetail": "Sintering",
      "FurnaceNo": 2,
      "HFT": "2 T",
      "Note": _controllerRemark.text,
      "Details": details,
    };

    try {
      print(jsonEncode(jsonData));

      final response = await http.post(
        Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(jsonData),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data saved successfully')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Failed to save data: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<List<ListItem>> _fetchSinteringItems() async {
    try {
      sinteringItems = await _apiService.fetchListSinteringtitile();
      _controllers =
          List.generate(sinteringItems.length, (_) => TextEditingController());
      _buttonStates =
          List.generate(sinteringItems.length, (_) => -1); // Initialize with -1
      _isFieldEmpty = List.generate(
          sinteringItems.length, (_) => false); // Initialize field emptiness
      return sinteringItems;
    } catch (e) {
      print('Error fetching sintering items: $e');
      return [];
    }
  }

  @override
  Widget _buildHeader(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: primarytitle,
          boxShadow: [
            BoxShadow(blurRadius: 0, color: divider, offset: Offset(0, 1))
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Inspaction After Sintering',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: icons),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                        child: Text(
                          'Repair : ${r.repairid!}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: icons),
                        ),
                      ),
                      Text(
                        DateFormat('EEE MMM, d, yyyy')
                            .format(r.planfromWorktime!),
                        style: const TextStyle(fontSize: 14, color: icons),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments;
    if (arguments == null || arguments is! Map<String, dynamic>) {
      return Scaffold(
        body: Center(
          child: Text('Error: Missing or incorrect arguments.'),
        ),
      );
    }
    final Map<String, dynamic> args = arguments as Map<String, dynamic>;
    final ReportModel r = args['report'];

    return Scaffold(
      backgroundColor: primarytitle,
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            _buildHeader(r),
            const SizedBox(height: 10),
            // ปรับปุ่ม image และ customer check ให้อยู่ใน Row เดียวกันและมีขนาดเท่ากัน
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(),
                          ),
                        );
                      },
                      icon: const Icon(FontAwesomeIcons.image, color: icons),
                      label:
                          const Text('image', style: TextStyle(color: icons)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(90, 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // เพิ่มระยะห่างระหว่างปุ่ม
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (r.repairid != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => showdatasinteringafter(
                                repairID: r.repairid!,
                              ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Repair ID is missing')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: button,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        minimumSize: const Size(90, 40),
                      ),
                      child: const Text('Customer Check'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'หมายเหตุ: ให้ทำการเช็คทุกๆ ด้านของ Lining',
              style: TextStyle(fontSize: 19, color: icons),
            ),
            FutureBuilder<List<ListItem>>(
              future: _sinteringItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No data available'));
                } else {
                  return _buildSinteringList(snapshot.data!);
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controllerRemark,
                style: const TextStyle(
                  fontSize: 16,
                  color: icons,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  labelText: 'Remarks',
                  labelStyle: TextStyle(
                    color: icons,
                  ),
                  hintText: 'Enter any additional remarks',
                  hintStyle: TextStyle(
                    color: icons,
                  ),
                ),
                maxLines: 3,
              ),
            ),
            _buildNextButton(r),
          ],
        ),
      ),
    );
  }

  Widget _buildSinteringList(List<ListItem> items) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        bool hasValidStdValues =
            (item.stdValueMin != null && item.stdValueMin != 0) ||
                (item.stdValueMax != null && item.stdValueMax != 0);

        return Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: primaryText,
          elevation: 4,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${index + 1}. ' + item.typeName,
                              style:
                                  const TextStyle(fontSize: 16, color: icons)),
                          const SizedBox(
                            height: 5,
                          ),
                          hasValidStdValues
                              ? Text(
                                  '      Standard: ${item.stdValueMin} - ${item.stdValueMax} ${item.unitId ?? ""}',
                                  style: const TextStyle(
                                      fontSize: 14, color: icons),
                                )
                              : const Text('      (เช็คการชำรุด)',
                                  style: TextStyle(fontSize: 14, color: icons)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _buttonStates[index] = 1; // Normal state selected
                          print('Item $index is Normal');
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonStates[index] == 1
                            ? Colors.green
                            : Colors.blueGrey,
                      ),
                      child: const Text('ปกติ'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _buttonStates[index] = 0; // Not Normal state selected
                          print('Item $index is Not Normal');
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _buttonStates[index] == 0
                            ? Colors.red
                            : Colors.blueGrey,
                      ),
                      child: const Text('ผิดปกติ'),
                    ),
                    const SizedBox(width: 10),
                    // Show TextField only when a button is pressed
                    if (_buttonStates[index] != -1 && hasValidStdValues)
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          style: const TextStyle(
                            fontSize: 18,
                            color: icons,
                            //fontFamily: 'MN KhaotomMat',
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Input Value',
                            labelStyle: const TextStyle(
                              color: icons,
                            ),
                            hintText: 'Enter Value',
                            hintStyle: const TextStyle(
                              color: icons,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 20,
                            ),
                            isDense: true,
                            suffixText: item.unitId ?? '',
                            suffixStyle: const TextStyle(
                              fontSize: 16,
                              color: icons,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _isFieldEmpty[index] = value.isEmpty;
                            });
                          },
                        ),
                      ),
                  ],
                ),
                //const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNextButton(ReportModel r) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(80, 0, 80, 5),
      child: InkWell(
        onTap: () async {
          try {
            final items = await _sinteringItemsFuture;
            String fullName = '${user.firstname} ${user.lastname}';
            await _postData(items, r.repairid!, username: fullName);
          } catch (e) {
            // Handle any errors that occur during the post
            print('Error: $e');
          }
        },
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
              color: button, borderRadius: BorderRadius.circular(30)),
          alignment: const AlignmentDirectional(0, 0),
          child:
              const Text('Save', style: TextStyle(color: icons, fontSize: 18)),
        ),
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(
          imageProvider: AssetImage('assets/images/lining.png'),
          minScale:
              PhotoViewComputedScale.contained * 0.8, // ตั้งค่าการซูมของภาพ
          maxScale:
              PhotoViewComputedScale.covered * 2.0, // ตั้งค่าการซูมสูงสุดของภาพ
          backgroundDecoration: const BoxDecoration(
            color: Colors.transparent, // กำหนดให้พื้นหลังเป็นโปร่งใส
          ),
        ),
      ),
    );
  }
}
