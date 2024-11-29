import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/pm_check/screens/mt_pim/pim_sceenchecklist.dart';
import 'package:engineer/pm_check/utility/app%20_apiurl.dart';
import 'package:engineer/pm_check/utility/app_controller.dart';
import 'package:engineer/pm_check/utility/app_service.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectMachine extends StatefulWidget {
  const SelectMachine({super.key});
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SelectMachine> {
  UserModel user = UserModel();
  final AuthenticateApi authenticateApi = AuthenticateApi();
  final AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
    getUser();
    AppService().readGetJobRepairPM().then((value) {
      print(
          '##---test  test-------body-----1111----- ${appController.getRepairPim.length}');
    });
  }

  Future<void> getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            const SizedBox(height: 15),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "    Select Machine",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(1),
              child: Obx(
                () => appController.getRepairPim.isEmpty
                    ? SizedBox()
                    : Container(
                        height: 400, // Set a fixed height for the list
                        child: ListView.builder(
                          itemCount: appController.getRepairPim.length,
                          itemBuilder: (context, index) {
                            final machine = appController.getRepairPim[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 25, 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color.fromARGB(255, 245, 245, 245),
                                  shadowColor:
                                      const Color.fromARGB(255, 41, 43, 42),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(1.0),
                                  ),
                                  minimumSize: const Size(80, 80),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CheckListScreenPim(),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 1.0),
                                      leading: Container(
                                        padding:
                                            const EdgeInsets.only(right: 4.0),
                                        decoration: const BoxDecoration(
                                          border: Border(
                                            right: BorderSide(
                                                width: 1.0, color: Colors.grey),
                                          ),
                                        ),
                                        child: const Icon(Icons.comment_sharp,
                                            size: 25.0, color: Colors.red),
                                      ),
                                      title: Text(
                                        'McID: ${machine.McID}',
                                        style: const TextStyle(
                                            fontSize: 15, color: Colors.black),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('McName: ${machine.McName}'),
                                          Text('Location: ......'),
                                          Text('Detail: ${machine.MT_Detail}'),
                                        ],
                                      ),
                                      trailing: const Icon(
                                        Icons.keyboard_arrow_right,
                                        color: Colors.blue,
                                        size: 35.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
