import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:engineer/app_router.dart';
import 'package:engineer/components/Utility.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/fetchJobDetail_model.dart';
import 'package:engineer/models/jobdetail_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/jobdetail_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:android_intent_plus/android_intent.dart' as intent;

const platform = MethodChannel('com.pinepacific.engineer/line');

class AddTimeScreen extends StatefulWidget {
  @override
  State<AddTimeScreen> createState() => _AddTimeScreenState();
}

class _AddTimeScreenState extends State<AddTimeScreen> {
  bool switchValue = false;
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  String planStart = '', planFinish = '', checkIn = '', checkOut = '';
  DateTime? _checkInTime;
  DateTime? _checkOutTime;
  JobDetailModel job = JobDetailModel();
  String formDate = "";
  String toDate = "";
  JobProvider provider = JobProvider();
  JobDetailModelByJobID? jobDetail;
  bool isLoading = true;
  List<String> repairEmpNames = [];
  final JobDetailApi jobDetailApi = JobDetailApi(); // API instance
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    getUser();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        final JobDetailModel? job =
            ModalRoute.of(context)?.settings.arguments as JobDetailModel?;
        if (job != null) {
          fetchJobDetail(job.jobid!);
        }
        setState(() {
          formDate = DateFormat('dd MMM yyyy').format(DateTime.now());
          toDate = DateFormat('dd MMM yyyy').format(DateTime.now());
        });
      },
    );
  }

  Future<void> fetchJobDetail(String jobId) async {
    final List<JobDetailModelByJobID>? details =
        await jobDetailApi.getJobDetailByJobID(jobId);

    if (details != null && details.isNotEmpty) {
      setState(() {
        jobDetail = details
            .first; // Store the first job detail (assuming it's relevant)
        repairEmpNames = details
            .map((e) => e.repairEmpName) // Extract employee names
            .toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch job details')),
      );
    }
  }

  List<String> extractEmployeeNames() {
    if (jobDetail == null) return [];

    // Extract employee names from `jobDetail`. If multiple employees are fetched from the API, adjust this logic.
    return jobDetail!.repairEmpName
        .split(',')
        .map((e) => e.trim()) // Ensure no leading/trailing spaces.
        .toList();
  }

  Widget _buildEmployeeList(List<String> employeeNames) {
    if (employeeNames.isEmpty) {
      return const Text(
        'No employees assigned.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }
    return Text(employeeNames.join(', ')); // Join names with commas
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  void updateCheckInTime(DateTime newTime) {
    setState(() {
      _checkInTime = newTime;
      checkIn = DateFormat('HH:mm').format(_checkInTime!);
    });
  }

  void selectDates() async {
    // กำหนดค่าเริ่มต้นเป็นวันที่ปัจจุบันเสมอ
    DateTime initialFormDate = DateTime.now();
    DateTime initialToDate = DateTime.now();

    // ตรวจสอบและกำหนดค่า `initialFormDate` จาก `job.plandate`
    if (job.plandate != null) {
      try {
        DateTime parsedDate = DateTime.parse(job.plandate!);
        // ตรวจสอบว่าค่าไม่ใช่วันที่ก่อนปี 1970 และไม่มีปัญหา
        if (parsedDate.isAfter(DateTime(1970))) {
          initialFormDate = parsedDate;
        }
      } catch (e) {
        // หากเกิดข้อผิดพลาด ให้แสดงข้อความ debug และใช้วันที่ปัจจุบัน
        debugPrint('Invalid date parsed from job.plandate, using current date');
        initialFormDate = DateTime.now();
      }
    }

    // ตรวจสอบอีกครั้งว่า `initialFormDate` และ `initialToDate` ไม่ก่อนปี 1970
    if (initialFormDate.isBefore(DateTime(1970))) {
      initialFormDate = DateTime.now();
    }
    if (initialToDate.isBefore(DateTime(1970))) {
      initialToDate = DateTime.now();
    }

    // ใช้ `showOmniDateTimePicker` พร้อมกับการตรวจสอบที่ครอบคลุม
    DateTime? newFormDate = await showOmniDateTimePicker(
      context: context,
      initialDate: initialFormDate,
      type: OmniDateTimePickerType.date,
      is24HourMode: true,
      firstDate: DateTime(1970),
    );

    if (newFormDate != null) {
      setState(() {
        formDate = DateFormat('dd MMM yyyy').format(newFormDate);
        debugPrint("Selected formDate: $formDate");
      });
    }

    DateTime? newToDate = await showOmniDateTimePicker(
      context: context,
      initialDate: initialToDate,
      type: OmniDateTimePickerType.date,
      is24HourMode: true,
      firstDate: DateTime(1970),
    );

    if (newToDate != null) {
      setState(() {
        toDate = DateFormat('dd MMM yyyy').format(newToDate);
        debugPrint("Selected toDate: $toDate");
      });
    }
  }

  void updateCheckOutTime(DateTime newTime) {
    setState(() {
      _checkOutTime = newTime;
      checkOut = DateFormat('HH:mm').format(_checkOutTime!);
    });
  }

  void recordTime() async {
    if (_checkInTime == null || _checkOutTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select both Check In and Check Out times.')),
      );
      return;
    }

    try {
      setState(() {
        job.fromworktime = _checkInTime;
        job.toworktime = _checkOutTime;
        job.employeecode = user.employeeCode;
        job.isclose = switchValue ? 1 : 0;
        job.approvestatusid = 2; // Approved status
      });

      bool result = await provider.fetchTimeStampJob(job);

      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time recorded successfully.')),
        );
        Navigator.pushReplacementNamed(context, AppRouter.time);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to record time, please try again.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      debugPrint('Error in saving time: $e');
    }
  }

  void openLineApp() async {
    try {
      await platform.invokeMethod('openLineApp');
    } on PlatformException catch (e) {
      print("Failed to open Line app: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    job = ModalRoute.of(context)!.settings.arguments as JobDetailModel;
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    String repairMainDetial = jobDetail?.repairMainDetial ?? 'N/A';
    String repairEmpName = jobDetail?.repairEmpName ?? 'N/A';
    String truckID = jobDetail?.truckID ?? 'N/A';
    String remark = jobDetail?.remark ?? 'N/A';
    List<String> employeeList = repairEmpNames;
    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    bool isTablet = screenWidth >= 600;
    double fontSize = isTablet ? 24 : 18;
    double padding = isTablet ? 20 : 10;
    double containerHeight = isTablet ? 200 : 150;

    // Check if these values exist before rendering UI
    if (job.programid == null || job.jobid == null || job.jobitem == null) {
      debugPrint("Error: ProgramID, JobID, or JobItem is missing.");
      return Scaffold(
        body: Center(
          child: Text(
            'Error: Missing essential job details. Cannot proceed.',
            style: TextStyle(color: Colors.red, fontSize: 20),
          ),
        ),
      );
    }

    planStart = DateFormat('HH:mm').format(job.planfromworktime!);
    planFinish = DateFormat('HH:mm').format(job.plantoworktime!);
    planStart = planStart == '00:00'
        ? DateFormat('HH:mm').format(job.planfromot!)
        : planStart;
    planFinish = planFinish == '00:00'
        ? DateFormat('HH:mm').format(job.plantoot!)
        : planFinish;

    checkIn = _checkInTime != null
        ? DateFormat('HH:mm').format(_checkInTime!)
        : DateFormat('HH:mm').format(job.fromworktime!);
    checkOut = _checkOutTime != null
        ? DateFormat('HH:mm').format(_checkOutTime!)
        : DateFormat('HH:mm').format(job.toworktime!);

    return Scaffold(
      backgroundColor: bgprimary,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComponentHeader(user: user, isHome: false),
                const SizedBox(height: 16),
                buildInfoContainer(),
                const SizedBox(height: 16),
                buildTimeRow(),
                const SizedBox(height: 16),
                buildSwitchContainer(),
                const SizedBox(height: 16),
                buildConfirmButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoContainer() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 570),
      decoration: BoxDecoration(
        color: textsecondary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: primaryDark,
            offset: Offset(1, 1),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.calendarDay,
                color: primaryDark,
                size: 30,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  DateFormat('EEE, d MMM y')
                      .format(DateTime.parse(job.plandate!)),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: textprimary,
                  ),
                ),
              ),

              // IconButton(
              //   icon: const FaIcon(
              //     FontAwesomeIcons.line,
              //     color: Colors.green,
              //     size: 40,
              //   ),
              //   iconSize: 40,
              //   onPressed: () async {
              //     final Uri lineChatUrl =
              //         Uri.parse('line://msg/text/+66800528333');
              //     if (await canLaunchUrl(lineChatUrl)) {
              //       await launchUrl(lineChatUrl,
              //           mode: LaunchMode.externalApplication);
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //             content:
              //                 Text('ไม่สามารถเปิดแอปหรือหน้าเว็บ Line ได้')),
              //       );
              //     }
              //   },
              // ),
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.line,
                  color: Colors.green,
                  size: 40,
                ),
                onPressed: openLineApp, // เรียกใช้ฟังก์ชันเมื่อกดปุ่ม
              ),
              IconButton(
                icon: const Icon(
                  Icons.phone,
                  color: Colors.green,
                  size: 40,
                ),
                iconSize: 40,
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text('โทรหา Engineer Center 1'),
                            onTap: () async {
                              final Uri phoneUrl =
                                  Uri.parse('tel:0880880673'); //เบอร์พี่กิ๊บ
                              if (await canLaunchUrl(phoneUrl)) {
                                await launchUrl(phoneUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('ไม่สามารถโทรออกได้')),
                                );
                              }
                              Navigator.pop(context);
                            },
                          ),
                          Divider(),
                          ListTile(
                            leading: const Icon(Icons.phone),
                            title: const Text('โทรหา Center 2'),
                            onTap: () async {
                              final Uri phoneUrl =
                                  Uri.parse('tel:0634645054'); //เบอร์พี่ปุ๋ย
                              if (await canLaunchUrl(phoneUrl)) {
                                await launchUrl(phoneUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('ไม่สามารถโทรออกได้')),
                                );
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // IconButton(
              //   icon: const Icon(
              //     Icons.phone,
              //     color: Colors.green,
              //     size: 40,
              //   ),
              //   iconSize: 40,
              //   onPressed: () {},
              // ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Plan Work :', '$planStart - $planFinish'),
          _buildInfoRow('Repair No :', job.repairid ?? 'N/A'),
          _buildJobDetailInfo(job),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? 'Show Less' : 'Show More'),
          ),
          if (_isExpanded) ...[
            _buildInfoRowEnter(
                'Main Repair Detail :', jobDetail?.repairMainDetial ?? 'N/A'),
            _buildInfoRow('JobID :', job.jobid ?? 'N/A'),
            _buildCustomerInfo(job),
            _buildInfoRow('Place :', job.worklocation ?? 'N/A'),
            _buildInfoRow('Car :', jobDetail?.truckID ?? 'N/A'),
            const Text(
              'Team :',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            _buildEmployeeList(repairEmpNames),
            _buildInfoRowEnter('Remark :', jobDetail?.remark ?? 'N/A'),
            const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }

  Widget _buildJobDetailInfo(JobDetailModel? job) {
    if (job?.detail != null && job!.detail!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // จัดให้อยู่ชิดซ้าย
          children: [
            const Text(
              'Job Detail :',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4), // เพิ่มระยะห่างเล็กน้อย
            Text(
              job.detail!,
              textAlign: TextAlign.left, // จัดชิดซ้าย
              style: const TextStyle(fontSize: 14),
              overflow:
                  TextOverflow.visible, // ให้ข้อความขึ้นบรรทัดใหม่อัตโนมัติ
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // กรณีไม่มีข้อมูล ไม่แสดงอะไรเลย
    }
  }

  Widget _buildInCustomer(String title, String? value) {
    if (value == null || value.isEmpty) {
      return const SizedBox.shrink(); // ถ้าไม่มีข้อมูล ไม่แสดงอะไรเลย
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8), // เพิ่มระยะห่างระหว่าง Title และ Value
        Expanded(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis, // ตัดข้อความถ้ายาวเกิน
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomerInfo(JobDetailModel? job) {
    if (job?.customername != null && job!.customername!.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // จัดให้ชิดซ้าย-ขวา
          children: [
            const Text(
              'Customer',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                job.customername!,
                textAlign: TextAlign.right, // ชิดขวาสำหรับข้อมูล
                overflow: TextOverflow.ellipsis, // ตัดข้อความหากยาวเกิน
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // กรณีไม่มีข้อมูล แสดง widget เปล่า
    }
  }

  Widget buildTimeRow() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTimeContainer(
          'Check In',
          job.fromworktime,
          () async {
            DateTime initialDateTime =
                _checkInTime ?? job.fromworktime ?? DateTime.now();

            // ตรวจสอบว่า initialDateTime ไม่ใช่วันที่ก่อนปี 1970
            if (initialDateTime.isBefore(DateTime(1970))) {
              initialDateTime = DateTime.now();
            }

            DateTime? newDateTime = await showOmniDateTimePicker(
              context: context,
              initialDate: initialDateTime,
              type: OmniDateTimePickerType.dateAndTime,
              is24HourMode: true,
              firstDate: DateTime(1970),
            );
            if (newDateTime != null) {
              setState(() {
                _checkInTime = newDateTime;
                job.fromworktime = newDateTime;
                checkIn = DateFormat('HH:mm').format(newDateTime);
              });
            }
          },
        ),
        const SizedBox(width: 10),
        _buildTimeContainer(
          'Check Out',
          job.toworktime,
          () async {
            DateTime initialDateTime =
                _checkOutTime ?? job.toworktime ?? DateTime.now();

            // ตรวจสอบว่า initialDateTime ไม่ใช่วันที่ก่อนปี 1970
            if (initialDateTime.isBefore(DateTime(1970))) {
              initialDateTime = DateTime.now();
            }

            DateTime? newDateTime = await showOmniDateTimePicker(
              context: context,
              initialDate: initialDateTime,
              type: OmniDateTimePickerType.dateAndTime,
              is24HourMode: true,
              firstDate: DateTime(1970),
            );
            if (newDateTime != null) {
              setState(() {
                _checkOutTime = newDateTime;
                job.toworktime = newDateTime;
                checkOut = DateFormat('HH:mm').format(newDateTime);
              });
            }
          },
        ),
      ],
    );
  }

// ฟังก์ชันสำหรับตรวจสอบและคืนค่าที่ถูกต้อง
  DateTime _validDate(DateTime? date) {
    return date ?? DateTime.now(); // ใช้วันที่ปัจจุบันหากค่าเดิมเป็น null
  }

  Widget _buildTimeContainer(
      String title, DateTime? dateTime, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            color: primary,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: primaryLight,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: background,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    dateTime != null
                        ? DateFormat('dd MMM yyyy').format(dateTime)
                        : 'Select Date & Time',
                    style: const TextStyle(
                      color: background,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Text(
                    dateTime != null
                        ? DateFormat('HH:mm').format(dateTime)
                        : 'No Time Selected',
                    style: const TextStyle(
                      fontSize: 30,
                      letterSpacing: 0,
                      fontWeight: FontWeight.bold,
                      color: background,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildInfoRowEnter(String title, String? value) {
    if (value != null && value.isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ชิดซ้าย
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4), // ระยะห่างระหว่างหัวข้อและรายละเอียด
            Text(
              value,
              textAlign: TextAlign.left, // จัดชิดซ้าย
              style: const TextStyle(fontSize: 14),
              overflow:
                  TextOverflow.visible, // ให้ข้อความขึ้นบรรทัดใหม่ถ้ายาวเกิน
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink(); // ไม่แสดงอะไรเลยหากไม่มีข้อมูล
    }
  }

  Widget buildSwitchContainer() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
      child: Container(
        width: 355,
        height: 80,
        decoration: BoxDecoration(
          color: primary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              blurRadius: 4,
              color: primaryLight,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Column(
                mainAxisSize: MainAxisSize.min, // ปรับให้ขนาดเหมาะสม
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today  ' + DateFormat('HH:mm').format(DateTime.now()),
                    style: TextStyle(color: background, fontSize: 14),
                  ),
                  Text(
                    DateFormat('EEE ').format(DateTime.now()) +
                        DateFormat(' dd MMM yyyy').format(DateTime.now()),
                    style: const TextStyle(color: background, fontSize: 14),
                  ),
                  // Text(
                  //   DateFormat('dd MMM yyyy').format(DateTime.now()),
                  //   style: const TextStyle(color: background, fontSize: 14),
                  // ),
                  // Text(
                  //   DateFormat('HH:mm').format(DateTime.now()),
                  //   style: const TextStyle(color: background, fontSize: 14),
                  // ),
                ],
              ),
            ),
            const SizedBox(
              height: 60,
              child: VerticalDivider(
                thickness: 5,
                color: background,
              ),
            ),
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 9.0),
                  child: Text(
                    'Close Job',
                    style: TextStyle(
                      color: background,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Transform.scale(
                  scale: 1.6,
                  child: Switch.adaptive(
                    value: switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                    activeColor: accent,
                    activeTrackColor: success,
                    inactiveTrackColor: primaryText,
                    inactiveThumbColor: secondaryText,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getFormattedDateTime(String time) {
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(time));
    } catch (e) {
      return 'Select Date & Time';
    }
  }

  Widget buildConfirmButton() {
    return Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(200, 50),
          backgroundColor: bluedark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: recordTime,
        child: const Text(
          'Confirm',
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 2,
            color: textprimary,
          ),
        ),
      ),
    );
  }
}
