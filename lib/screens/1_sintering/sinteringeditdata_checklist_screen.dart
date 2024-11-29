// import 'dart:convert';
// import 'package:engineer/components/component_header.dart';
// import 'package:engineer/models/report_model.dart';
// import 'package:engineer/models/sintering_model.dart';
// import 'package:engineer/models/user_model.dart';
// import 'package:engineer/screens/sintering/sinteringshowdata_screen.dart';
// import 'package:engineer/services/authenticate_api.dart';
// import 'package:engineer/services/form_all_api.dart';
// import 'package:engineer/themes/colors.dart';
// import 'package:engineer/utils/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';

// class Sinteringeditdata_Checklist extends StatefulWidget {
//   final DateTime timestamp;

//   const Sinteringeditdata_Checklist({
//     Key? key,
//     required this.timestamp,
//   }) : super(key: key);

//   @override
//   State<Sinteringeditdata_Checklist> createState() =>
//       _SinteringChecklistState();
// }

// class _SinteringChecklistState extends State<Sinteringeditdata_Checklist> {
//   UserModel user = UserModel();
//   AuthenticateApi authenticateApi = AuthenticateApi();
//   final ApiService _apiService = ApiService();
//   late Future<List<ListItem>> _sinteringItems;
//   List<TextEditingController> _controllers = [];
//   List<bool> _isFieldEmpty = [];
//   bool isDrawing = false;

//   // เพิ่มการประกาศ _controllerRemark ที่นี่
//   final TextEditingController _controllerRemark = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     getUser();

//     // Fetch the Sintering List
//     _sinteringItems = _apiService.fetchListItem('1');

//     _sinteringItems.then((items) {
//       setState(() {
//         _controllers = List.generate(
//           items.length,
//           (_) => TextEditingController(),
//         );
//         _isFieldEmpty = List.generate(items.length, (_) => false);
//       });
//     });
//   }

//   Future<void> getUser() async {
//     user = await authenticateApi.getUser();
//     setState(() {});
//   }

//   Future<void> _postData(List<ListItem> items, String repairId,
//       {String? username}) async {
//     // Create JSON data
//     Map<String, dynamic> jsonData = {
//       "RepairID": repairId,
//       "CheckID": 0,
//       "FromID": 1,
//       "DateTime": DateFormat('yyyy-MM-dd').format(DateTime.now()),
//       "StratTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(widget.timestamp),
//       "EndTime": DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
//       "EngineerBy": username ?? 'Unknown',
//       "CusCompanyName": username ?? 'Unknown',
//       "TypeDetail": "แบบฟอร์มการตรวจเช็คผนัง Lining หลังจากการ Sintering",
//       "FurnaceNo": 2,
//       "HFT": "2 T",
//       "Note": _controllerRemark.text, // ใช้ค่าใน _controllerRemark สำหรับ Note
//       "Details": List.generate(_controllers.length, (index) {
//         TextEditingController textController = _controllers[index];
//         return {
//           "CheckID": 0,
//           "GroupID": items[index].groupId,
//           "TypeNo": items[index].typeNo,
//           "ValueBit": 1,
//           "Value": textController.text,
//           "valuedetail": ''
//         };
//       })
//     };

//     try {
//       // Send the POST request
//       final response = await http.post(
//         Uri.parse(AppConstantPost.urlAPIPostDataByFormID),
//         headers: {
//           'Content-Type': 'application/json',
//         },
//         body: jsonEncode(jsonData),
//       );

//       // Check the response
//       if (response.statusCode == 200) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Data saved successfully')),
//         );

//         Navigator.pop(context);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text('Failed to save data: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
//   }

//   bool _validateFields() {
//     List<int> requiredIndices = [
//       0,
//       1,
//       2,
//       3,
//       4,
//       5,
//       15,
//       16,
//       17,
//       18
//     ]; // 0-based index for required fields
//     bool allValid = true;

//     for (int index in requiredIndices) {
//       if (_controllers[index].text.isEmpty) {
//         setState(() {
//           _isFieldEmpty[index] = true;
//         });
//         allValid = false;
//       } else {
//         setState(() {
//           _isFieldEmpty[index] = false;
//         });
//       }
//     }

//     if (!allValid) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please fill in all required fields.'),
//         ),
//       );
//     }

//     return allValid;
//   }

//   @override
//   void dispose() {
//     for (var controller in _controllers) {
//       controller.dispose();
//     }
//     _controllerRemark.dispose(); // Dispose _controllerRemark
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final arguments = ModalRoute.of(context)?.settings.arguments;
//     if (arguments == null || arguments is! Map<String, dynamic>) {
//       return Scaffold(
//         body: Center(
//           child: Text('Error: Missing or incorrect arguments.'),
//         ),
//       );
//     }

//     final Map<String, dynamic> args = arguments as Map<String, dynamic>;
//     final ReportModel r = args['report'];

//     return Scaffold(
//       backgroundColor: primarytitle, // Updated background color
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             ComponentHeader(user: user, isHome: false),
//             _buildHeader(r),
//             FutureBuilder<List<ListItem>>(
//               future: _sinteringItems,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const CircularProgressIndicator();
//                 } else if (snapshot.hasError) {
//                   return Text('Error: ${snapshot.error}');
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Text('No items found');
//                 } else {
//                   return Column(
//                     children: [
//                       ...snapshot.data!.asMap().entries.map((entry) {
//                         int index = entry.key;
//                         ListItem item = entry.value;
//                         return _buildCard(item, index);
//                       }).toList(),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: TextField(
//                           controller: _controllerRemark,
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: icons,
//                           ),
//                           decoration: const InputDecoration(
//                             border: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             enabledBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.white,
//                               ),
//                             ),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: BorderSide(
//                                 color: Colors.white,
//                                 width: 2.0,
//                               ),
//                             ),
//                             labelText: 'Remarks',
//                             labelStyle: TextStyle(
//                               color: icons,
//                             ),
//                             hintText: 'Enter any additional remarks',
//                             hintStyle: TextStyle(
//                               color: icons,
//                             ),
//                           ),
//                           maxLines: 3,
//                         ),
//                       ),
//                     ],
//                   );
//                 }
//               },
//             ),
//             const SizedBox(height: 15),
//             _buildNextButton(r),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(ReportModel r) {
//     return Padding(
//       padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 0),
//       child: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//           color: primarytitle,
//           boxShadow: [
//             BoxShadow(
//               blurRadius: 0,
//               color: divider,
//               offset: Offset(0, 1),
//             ),
//           ],
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(16),
//             topRight: Radius.circular(16),
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Sintering Check',
//                         style: TextStyle(
//                           letterSpacing: 0,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                           color: icons,
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       Text(
//                         'Repair : ${r.repairid!}     ||    CheckNo : 16',
//                         style: const TextStyle(
//                           letterSpacing: 0,
//                           fontWeight: FontWeight.bold,
//                           color: icons,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   if (r.repairid != null) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => SimpleDataTable(
//                           repairID: r.repairid!,
//                         ),
//                       ),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Repair ID is missing')),
//                     );
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: button,
//                 ),
//                 child: const Text(
//                   'Data CheckList',
//                   style: TextStyle(color: icons),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildCard(ListItem item, int index) {
//     TextEditingController textController = _controllers[index];
//     bool hasValidStdValues =
//         (item.stdValueMin != null && item.stdValueMin != 0) ||
//             (item.stdValueMax != null && item.stdValueMax != 0);

//     return Card(
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       color: primaryText,
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     '${index + 1}. ${item.typeName}',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: icons,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 5),
//             if (hasValidStdValues)
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   '     Standard : ${item.stdValueMin ?? "N/A"} - ${item.stdValueMax ?? "N/A"}',
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: icons,
//                   ),
//                 ),
//               ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   width: MediaQuery.of(context).size.width / 2,
//                   child: TextField(
//                     controller: textController,
//                     style: const TextStyle(
//                       fontSize: 16,
//                       color: icons,
//                     ),
//                     keyboardType:
//                         const TextInputType.numberWithOptions(decimal: true),
//                     inputFormatters: [
//                       FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
//                     ],
//                     decoration: InputDecoration(
//                       border: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                       enabledBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                         ),
//                       ),
//                       focusedBorder: const OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Colors.white,
//                           width: 2.0,
//                         ),
//                       ),
//                       labelText: 'Input Value',
//                       labelStyle: const TextStyle(
//                         color: icons,
//                       ),
//                       hintText: 'Enter Value',
//                       hintStyle: const TextStyle(
//                         color: icons,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(
//                         vertical: 12,
//                         horizontal: 20,
//                       ),
//                       isDense: true,
//                       suffixText: item.unitId ?? '', // Show unitId as suffix
//                       suffixStyle: const TextStyle(
//                         fontSize: 16,
//                         color: icons,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         _isFieldEmpty[index] = value.isEmpty;
//                       });
//                     },
//                     onEditingComplete: () {
//                       FocusScope.of(context)
//                           .nextFocus(); // Move to the next TextField
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             if (_isFieldEmpty[index])
//               const Padding(
//                 padding: EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   children: [
//                     Icon(Icons.warning, color: Colors.red, size: 16),
//                     SizedBox(width: 5),
//                     Text(
//                       'This field is required.',
//                       style: TextStyle(
//                         color: Colors.red,
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNextButton(ReportModel r) {
//     return Padding(
//       padding: const EdgeInsetsDirectional.fromSTEB(80, 0, 80, 5),
//       child: InkWell(
//         onTap: () {
//           if (_validateFields()) {
//             _sinteringItems.then((items) {
//               String fullName = '${user.firstname} ${user.lastname}';
//               _postData(items, r.repairid!, username: fullName);
//             });
//           }
//         },
//         child: Container(
//           width: double.infinity,
//           height: 60,
//           decoration: BoxDecoration(
//             color: button,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           alignment: const AlignmentDirectional(0, 0),
//           child: const Text(
//             'Save',
//             style: TextStyle(
//               color: icons,
//               fontSize: 18,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
