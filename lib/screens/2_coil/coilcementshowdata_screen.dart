import 'dart:convert';
import 'package:engineer/models/fetchvaluesinteringcheck.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class coilcementshowdata extends StatefulWidget {
  final String repairID;
  const coilcementshowdata({Key? key, required this.repairID})
      : super(key: key);

  @override
  _SimpleDataTableState createState() => _SimpleDataTableState();
}

class _SimpleDataTableState extends State<coilcementshowdata> {
  late Future<List<CheckList>> _checkListFuture;

  @override
  void initState() {
    super.initState();
    _checkListFuture = fetchCheckListData(widget.repairID);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    displayCheckListData(widget.repairID);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  Future<List<CheckList>> fetchCheckListData(String repairID) async {
    try {
      final response = await http
          .get(Uri.parse(
              'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetValueCheckListSintering?repairID=${widget.repairID}&IDFromID=4'))
          .timeout(Duration(seconds: 10)); // Set a timeout for the request

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((item) => CheckList.fromJson(item)).toList();
      } else {
        // Handle HTTP errors
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any other errors
      throw Exception('Failed to load data due to an error: $e');
    }
  }

  Future<void> displayCheckListData(String repairID) async {
    try {
      List<CheckList> allData = await fetchCheckListData(repairID);

      // Filter data by RepairID
      List<CheckList> filteredData =
          allData.where((item) => item.repairID == repairID).toList();

      // Count the occurrences of CheckID
      int checkIDCount = filteredData.length;

      // Display the count
      print('+++++++++++++++++++++Number of CheckID $repairID: $checkIDCount');

      // Display the filtered data
      for (var checkList in filteredData) {
        print('Check ID: ${checkList.checkID}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'การตรวจสอบค่า Mega ohm ของ Coil cement และ top castable|| Repair: ${widget.repairID}'),
      ),
      body: FutureBuilder<List<CheckList>>(
        future: _checkListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical, // Enable vertical scrolling
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Enable horizontal scrolling
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text('ความสูง')), // Sequential number column
                    //DataColumn(label: Text('CheckID')),
                    DataColumn(label: Text('StartTime')),
                    DataColumn(label: Text('Voltage')),
                    DataColumn(label: Text('Current')),
                    DataColumn(label: Text('HV')),
                    DataColumn(label: Text('kw')),
                    DataColumn(label: Text('kw_h')),
                    DataColumn(label: Text('Hz')),
                    DataColumn(label: Text('f')),
                    DataColumn(label: Text('g')),
                    DataColumn(label: Text('T1')),
                    DataColumn(label: Text('Tu')),
                    DataColumn(label: Text('Tg')),
                    DataColumn(label: Text('TimeOn')),
                    DataColumn(label: Text('TimeOff')),
                    DataColumn(label: Text('Setemp')),
                    DataColumn(label: Text('Actual')),
                    DataColumn(label: Text('kage_1')),
                    DataColumn(label: Text('kage_3')),
                    DataColumn(label: Text('kage_4')),
                    DataColumn(label: Text('Coil')),
                    DataColumn(label: Text('Yoke')),
                    DataColumn(label: Text('Feeder')),
                    DataColumn(label: Text('INV_PS')),
                    DataColumn(label: Text('TR')),
                    DataColumn(label: Text('M')),
                    DataColumn(label: Text('DetailValue')),
                  ],
                  rows: snapshot.data!.asMap().entries.map(
                    (entry) {
                      final index = entry.key;
                      final data = entry.value;
                      final DateFormat formatter = DateFormat('yy-MM-dd HH:mm');
                      final String formattedStartTime =
                          formatter.format(data.startTime);

                      return DataRow(
                        cells: [
                          DataCell(Text(
                              (index + 1).toString())), // Sequential number
                          //DataCell(Text(data.checkID.toString())),
                          DataCell(Text(formattedStartTime)),
                          DataCell(Text(data.voltage.toString())),
                          DataCell(Text(data.current.toString())),
                          DataCell(Text(data.hv.toString())),
                          DataCell(Text(data.kw.toString())),
                          DataCell(Text(data.kwH.toString())),
                          DataCell(Text(data.hz.toString())),
                          DataCell(Text(data.f.toString())),
                          DataCell(Text(data.g.toString())),
                          DataCell(Text(data.t1.toString())),
                          DataCell(Text(data.tu.toString())),
                          DataCell(Text(data.tg.toString())),
                          DataCell(Text(data.timeOn.toString())),
                          DataCell(Text(data.timeOff.toString())),
                          DataCell(Text(data.setemp.toString())),
                          DataCell(Text(data.actual.toString())),
                          DataCell(Text(data.kage1.toString())),
                          DataCell(Text(data.kage3.toString())),
                          DataCell(Text(data.kage4.toString())),
                          DataCell(Text(data.coil.toString())),
                          DataCell(Text(data.yoke.toString())),
                          DataCell(Text(data.feeder.toString())),
                          DataCell(Text(data.invPs.toString())),
                          DataCell(Text(data.tr.toString())),
                          DataCell(Text(data.m.toString())),
                          DataCell(Text(data.detailValue)),
                        ],
                      );
                    },
                  ).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
