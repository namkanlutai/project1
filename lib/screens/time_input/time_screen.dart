import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/jobdetail_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/jobdetail_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key});

  @override
  State<TimeScreen> createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  List<JobDetailModel> details = [];
  List<Appointment> appointments = [];
  List<JobDetailModel> selectedJobDetails = [];

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await authenticateApi.getUser();

    if (user != null && user.employeeCode != null) {
      JobDetailApi api = JobDetailApi();

      details = await api.getJobDetails(
        '2024-01-01',
        '2040-12-31',
        user.employeeCode!,
      );

      appointments = details.map((detail) {
        final date = DateTime.parse(detail.plandate ?? '');
        return Appointment(
          startTime: date,
          endTime: date.add(const Duration(hours: 1)),
          //subject: 'RepairID: ${detail.repairid ?? 'N/A'}',
          color: const Color.fromARGB(255, 233, 244, 200),
          notes: detail.jobid,
        );
      }).toList();

      setState(() {});
    } else {
      print('User or employeeCode is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgprimary,
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              ComponentHeader(user: user, isHome: false),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: SfCalendar(
                    view: CalendarView.month,
                    dataSource: MeetingDataSource(appointments),
                    monthViewSettings: MonthViewSettings(
                      appointmentDisplayMode:
                          MonthAppointmentDisplayMode.appointment,
                      showAgenda: false,
                      monthCellStyle: MonthCellStyle(
                        textStyle: TextStyle(
                          color: textprimary,
                          fontWeight: FontWeight.bold,
                        ),
                        todayTextStyle: TextStyle(
                          color: textprimary,
                          fontWeight: FontWeight.bold,
                        ),
                        leadingDatesTextStyle: TextStyle(
                          color: textprimary.withOpacity(0.5),
                        ),
                        trailingDatesTextStyle: TextStyle(
                          color: textprimary.withOpacity(0.5),
                        ),
                      ),
                    ),
                    headerStyle: CalendarHeaderStyle(
                      textStyle: TextStyle(
                        color: textprimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    viewHeaderStyle: ViewHeaderStyle(
                      dayTextStyle: TextStyle(
                        color: textprimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    todayHighlightColor: bluedark,
                    selectionDecoration: BoxDecoration(
                      color: textprimary.withOpacity(0.2),
                      border: Border.all(
                        color: textprimary,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    cellBorderColor: textprimary,
                    onTap: (CalendarTapDetails details) {
                      setState(() {
                        if (details.targetElement ==
                                CalendarElement.calendarCell &&
                            details.date != null) {
                          DateTime selectedDay = details.date!;
                          selectedJobDetails = this.details.where((detail) {
                            DateTime? planDate = detail.plandate != null
                                ? DateTime.parse(detail.plandate!)
                                : null;
                            return planDate != null &&
                                planDate.year == selectedDay.year &&
                                planDate.month == selectedDay.month &&
                                planDate.day == selectedDay.day;
                          }).map((detail) {
                            // ตรวจสอบเวลาและใช้ fallback ถ้าจำเป็น
                            detail.planfromworktime =
                                (detail.planfromworktime != null &&
                                        (detail.planfromworktime!.hour != 0 ||
                                            detail.planfromworktime!.minute !=
                                                0))
                                    ? detail.planfromworktime
                                    : detail.planfromot;

                            detail.plantoworktime =
                                (detail.plantoworktime != null &&
                                        (detail.plantoworktime!.hour != 0 ||
                                            detail.plantoworktime!.minute != 0))
                                    ? detail.plantoworktime
                                    : detail.plantoot;

                            return detail;
                          }).toList();
                        } else {
                          selectedJobDetails = [];
                        }
                      });
                    }),
              ),
              Container(
                color: bgsecondary,
                padding: const EdgeInsets.all(8.0),
                child: selectedJobDetails.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: selectedJobDetails.length,
                        itemBuilder: (context, index) {
                          final jobDetail = selectedJobDetails[index];
                          final planStart = jobDetail.planfromworktime != null
                              ? DateFormat('HH:mm')
                                  .format(jobDetail.planfromworktime!)
                              : 'N/A';
                          final planFinish = jobDetail.plantoworktime != null
                              ? DateFormat('HH:mm')
                                  .format(jobDetail.plantoworktime!)
                              : 'N/A';

                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: textprimary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Plan: $planStart - $planFinish',
                                        style: const TextStyle(
                                          color: textprimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Repair: ${jobDetail.repairid ?? 'N/A'}',
                                        style: const TextStyle(
                                          color: textprimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Location: ${jobDetail.worklocation ?? 'N/A'}',
                                        style: const TextStyle(
                                          color: textprimary,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Description: ${jobDetail.detail != null && jobDetail.detail!.isNotEmpty ? jobDetail.detail : 'No detail available'}',
                                        style: const TextStyle(
                                          color: textprimary,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pushNamed(
                                            context,
                                            AppRouter.addtime,
                                            arguments: jobDetail,
                                          );
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.userClock,
                                          color: jobDetail.approvestatusid == 3
                                              ? Colors.green.shade600
                                              : jobDetail.approvestatusid == 2
                                                  ? Colors.orange.shade600
                                                  : primaryDark,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No appointments for the selected date',
                          style: TextStyle(
                            color: textprimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Appointment> source) {
    appointments = source;
  }
}
