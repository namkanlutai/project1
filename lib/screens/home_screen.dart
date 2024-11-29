import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/jobdetail_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  DateTime currentDateTime = DateTime.now();
  List<JobDetailModel> details =
      []; // Assuming you have this model or adjust as necessary

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primarytitle,
      body: Column(
        children: [
          ComponentHeader(user: user, isHome: true),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            width: 400,
            height: 100,
            decoration: BoxDecoration(
              color: primarytitle,
              boxShadow: const [
                BoxShadow(
                  color: divider,
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
              borderRadius: BorderRadius.circular(24.0),
              shape: BoxShape.rectangle,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.time);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: FaIcon(
                            FontAwesomeIcons.userClock,
                            size: 35,
                            color: button,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'Job',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: icons,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AppRouter.report);
                    },
                    child: const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: FaIcon(
                            FontAwesomeIcons.fileExport,
                            size: 35,
                            color: button,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'Report',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: icons,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.typm,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: FaIcon(
                            FontAwesomeIcons.solidCalendarCheck,
                            size: 35,
                            color: button,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'PM Check',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: icons,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(
                      context,
                      AppRouter.profile,
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: FaIcon(
                            FontAwesomeIcons.userCog,
                            size: 35,
                            color: button,
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: icons,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add the calendar section below the Row widget
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
            child: Container(
              color:
                  bgprimary, // Set the background color for the entire section
              child: Column(
                children: [
                  // Display current date, month, and year at the top
                  Text(
                    DateFormat('dd MMMM yyyy').format(currentDateTime),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textprimary, // Change text color to textprimary
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Calendar widget
                  TableCalendar<JobDetailModel>(
                    firstDay: DateTime.utc(2023, 1, 1),
                    lastDay: DateTime.utc(2025, 12, 31),
                    focusedDay: currentDateTime,
                    eventLoader: (day) {
                      return details.where((detail) {
                        final planDate =
                            DateTime.tryParse(detail.plandate ?? '');
                        return planDate != null && isSameDay(planDate, day);
                      }).toList();
                    },
                    calendarFormat: CalendarFormat.month,
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: const TextStyle(
                        color:
                            textprimary, // Set header text color to textprimary
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      leftChevronIcon: const Icon(
                        Icons.chevron_left,
                        color:
                            textprimary, // Set color for the left chevron icon to textprimary
                      ),
                      rightChevronIcon: const Icon(
                        Icons.chevron_right,
                        color:
                            textprimary, // Set color for the right chevron icon to textprimary
                      ),
                    ),
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                          color:
                              textprimary), // Set weekday text color to textprimary
                      weekendStyle: TextStyle(
                          color:
                              textprimary), // Set weekend text color to textprimary
                    ),
                    calendarStyle: CalendarStyle(
                      defaultTextStyle: const TextStyle(
                        color:
                            textprimary, // Set default day text color to textprimary
                      ),
                      weekendTextStyle: const TextStyle(
                        color:
                            textprimary, // Set weekend day text color to textprimary
                      ),
                      outsideTextStyle: const TextStyle(
                        color:
                            textprimary, // Set outside month day text color to textprimary
                      ),
                      todayTextStyle: const TextStyle(
                        color:
                            textprimary, // Set today's text color to textprimary
                      ),
                      selectedTextStyle: const TextStyle(
                        color:
                            textprimary, // Set selected day text color to textprimary
                      ),
                      todayDecoration: const BoxDecoration(
                        color:
                            icon, // Set color for today's background to textprimary
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: textprimary.withOpacity(
                            0.5), // Set color for selected day with opacity
                        shape: BoxShape.circle,
                      ),
                    ),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        currentDateTime = focusedDay;
                        showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            List<JobDetailModel> selectedDayDetails =
                                details.where((detail) {
                              final planDate =
                                  DateTime.tryParse(detail.plandate ?? '');
                              return planDate != null &&
                                  isSameDay(planDate, selectedDay);
                            }).toList();
                            return ListView.builder(
                              itemCount: selectedDayDetails.length,
                              itemBuilder: (context, index) {
                                JobDetailModel det = selectedDayDetails[index];
                                return ListTile(
                                  title: Text(
                                    'Repair ID: ${det.repairid ?? 'N/A'}',
                                    style: const TextStyle(
                                        color:
                                            textprimary), // Set text color to textprimary
                                  ),
                                  subtitle: Text(
                                    'Location: ${det.worklocation ?? 'Unknown location'}',
                                    style: const TextStyle(
                                        color:
                                            textprimary), // Set text color to textprimary
                                  ),
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.addtime,
                                      arguments: det,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
