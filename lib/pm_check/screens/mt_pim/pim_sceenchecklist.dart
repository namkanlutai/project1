import 'package:engineer/app_router.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/pm_check/screens/mt_pim/screen_selectjobmachin.dart';
import 'package:engineer/pm_check/utility/app_controller.dart';
import 'package:engineer/pm_check/utility/app_service.dart';
import 'package:engineer/pm_check/widgets/widget_button.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/getwidget.dart';

class CheckListScreenPim extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Click Color Card',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  AppController appController = Get.put(AppController());
  //List<TextEditingController> controllers = [];

  double screenHeight = 0;
  double screenWidth = 0;

  @override
  void initState() {
    super.initState();
    GetStorage().erase();
    getUser();

    appController.showErrorValidate.value = false;
    appController.checkValidate.value = true;
    AppService().readGetMachineStdName().then((value) {
      print(
          '##----------------wer-----body ${appController.machineModels.length}');
    });

    AppService().readStandardsModel();
  }

  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});
  }

  TextEditingController controllerRemark = TextEditingController();
  TextEditingController controllervalue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            const SizedBox(
              height: 15,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "   PM Check List",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Obx(
              () => appController.machineModels.isEmpty
                  ? const SizedBox()
                  : ListView(
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        // ignore: prefer_interpolation_to_compose_strings
                        Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          '   ' +
                              appController
                                  .machineModels[appController.indexBody.value]
                                  .McName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        GetStorage().read('listOnes') == null
                            ? const SizedBox(
                                child: Text('Have Null'),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                itemCount: appController
                                    .listStandardsModels[
                                        appController.indexBody.value]
                                    .length,
                                physics: const ScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var standardModel =
                                      appController.listStandardsModels[
                                          appController.indexBody.value][index];

                                  bool isMinMaxNull =
                                      standardModel.MsMin == 0.0 &&
                                          standardModel.MsMax == 0.0;
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            // ignore: prefer_interpolation_to_compose_strings
                                            '  ' +
                                                standardModel.MsOrder
                                                    .toString() +
                                                '. ' +
                                                standardModel.MsDetail.trim(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 5),
                                          isMinMaxNull
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Obx(
                                                      () => WidgetButton(
                                                        textStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        color: GetStorage().read(
                                                                    'listOnes')[
                                                                appController
                                                                    .indexBody
                                                                    .value][index]
                                                            ? Colors.green
                                                            : Colors.grey.shade300,
                                                        text: 'ปกติ',
                                                        onPressed: () {
                                                          var newListOnes =
                                                              GetStorage().read(
                                                                  'listOnes');

                                                          var result =
                                                              newListOnes[
                                                                  appController
                                                                      .indexBody
                                                                      .value];

                                                          result[index] =
                                                              !result[index];

                                                          newListOnes[
                                                                  appController
                                                                      .indexBody
                                                                      .value] =
                                                              result;

                                                          //ส่วนของ Two
                                                          var newListTwos =
                                                              GetStorage().read(
                                                                  'listTwos');

                                                          var blank =
                                                              newListTwos[
                                                                  appController
                                                                      .indexBody
                                                                      .value];

                                                          blank[index] = false;

                                                          //ส่วนของ Three
                                                          var newListThrees =
                                                              GetStorage().read(
                                                                  'listThrees');

                                                          var blankThree =
                                                              newListThrees[
                                                                  appController
                                                                      .indexBody
                                                                      .value];

                                                          blankThree[index] =
                                                              false;

                                                          saveListOneTwoThree();

                                                          processSaveChoose(
                                                              index: index);

                                                          setState(() {});
                                                        },
                                                      ),
                                                    ),
                                                    WidgetButton(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                      color: GetStorage().read(
                                                                  'listTwos')[
                                                              appController
                                                                  .indexBody
                                                                  .value][index]
                                                          ? Colors.red
                                                          : Colors
                                                              .grey.shade300,
                                                      text: 'ไม่ปกติ',
                                                      onPressed: () {
                                                        var newListTwos =
                                                            GetStorage().read(
                                                                'listTwos');

                                                        var result =
                                                            newListTwos[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        result[index] =
                                                            !result[index];

                                                        //ส่วนของ One
                                                        var newListOnes =
                                                            GetStorage().read(
                                                                'listOnes');

                                                        var blankTwo =
                                                            newListOnes[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        blankTwo[index] = false;

                                                        //ส่วนของ Three
                                                        var newListThrees =
                                                            GetStorage().read(
                                                                'listThrees');

                                                        var blankThree =
                                                            newListThrees[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        blankThree[index] =
                                                            false;

                                                        saveListOneTwoThree();

                                                        processSaveChoose(
                                                            index: index);

                                                        setState(() {});
                                                      },
                                                    ),
                                                    WidgetButton(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.black),
                                                      color: GetStorage().read(
                                                                  'listThrees')[
                                                              appController
                                                                  .indexBody
                                                                  .value][index]
                                                          ? Colors.amber
                                                          : Colors
                                                              .grey.shade300,
                                                      text: 'N/A',
                                                      onPressed: () {
                                                        var newListThrees =
                                                            GetStorage().read(
                                                                'listThrees');

                                                        var result =
                                                            newListThrees[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        result[index] =
                                                            !result[index];

                                                        //ส่วนของ One
                                                        var newListOnes =
                                                            GetStorage().read(
                                                                'listOnes');

                                                        var blankOne =
                                                            newListOnes[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        blankOne[index] = false;

                                                        //ส่วนของ Two
                                                        var newListTwos =
                                                            GetStorage().read(
                                                                'listTwos');

                                                        var blankTwo =
                                                            newListTwos[
                                                                appController
                                                                    .indexBody
                                                                    .value];

                                                        blankTwo[index] = false;

                                                        saveListOneTwoThree();

                                                        processSaveChoose(
                                                            index: index);

                                                        setState(() {});
                                                      },
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const SizedBox(width: 20),
                                                    Text(
                                                      'Std: ${standardModel.MsMin} - ${standardModel.MsMax} ${standardModel.UnitID}',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Flexible(
                                                      child: TextField(
                                                        // controller:
                                                        //     controllervalue,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          color: Color.fromARGB(
                                                              255, 8, 0, 251),
                                                          fontFamily:
                                                              'MN KhaotomMat',
                                                        ),
                                                        textAlign:
                                                            TextAlign.center,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              const OutlineInputBorder(),
                                                          labelText:
                                                              standardModel
                                                                  .MsDetail,
                                                          hintText:
                                                              'Input Value ',
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          isDense: true,
                                                        ),
                                                        // onChanged: (value) {
                                                        //   saveValueIfLengthCorrect(
                                                        //       index, value);
                                                        // },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      '${standardModel.UnitID}.',
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    const SizedBox(width: 20),
                                                  ],
                                                ),
                                          Obx(() => appController
                                                  .showErrorValidate.value
                                              ? GetStorage().read(
                                                          'displayValidate')[
                                                      appController.indexBody
                                                          .value][index]
                                                  ? const SizedBox()
                                                  : const Text(
                                                      'Please Choose Item',
                                                      style: TextStyle(
                                                          color:
                                                              GFColors.DANGER),
                                                    )
                                              : const SizedBox()),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: TextField(
                            controller: controllerRemark,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontFamily: 'MN KhaotomMat',
                            ),
                            textAlign: TextAlign.start,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Remark',
                              hintText: 'Input Remark ',
                              contentPadding: EdgeInsets.all(8),
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'Save',
            hoverElevation: 25,
            onPressed: () {
              appController.checkValidate.value = true;
              appController.showErrorValidate.value = true;
              var result = GetStorage().read('displayValidate');
              for (var element in result) {
                var result2 = element;

                print('## result2 ---> $result2');

                for (var element2 in result2) {
                  if (!element2) {
                    appController.checkValidate.value = false;
                  }
                }
              }

              if (appController.checkValidate.value) {
                //process upload Choose
                AppService()
                    .processSaveCheckList(controllerRemark.text)
                    .then((value) async {
                  await GetStorage().erase().then((value) {
                    Get.deleteAll().then((value) {
                      Get.deleteAll();
                      appController.showErrorValidate.value = false;
                      appController.checkValidate.value = true;
                      // AppService().readGetCheckGroup().then((value) {});
                      //AppService().readListDetails();

                      setState(() {});
                    });
                  });
                });

                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectMachine(),
                  ),
                );
              } else {
                Get.snackbar('UnComplete Data', 'Please Choose Every');
              }
            },
            tooltip: 'reduce',
            child:
                const Icon(Icons.save, color: Color.fromARGB(255, 251, 4, 4)),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10, 15, 10, 15),
          ),
        ],
      ),
    );
  }

  void saveListOneTwoThree({
    List<List<bool>>? newListOnes,
    List<List<bool>>? newListTwos,
    List<List<bool>>? newListThrees,
    //List<List<bool>>? newTextListValue,
  }) {
    GetStorage()
        .write('listOnes', newListOnes ?? GetStorage().read('listOnes'));
    GetStorage()
        .write('listTwos', newListOnes ?? GetStorage().read('listTwos'));
    GetStorage()
        .write('listThrees', newListOnes ?? GetStorage().read('listThrees'));
    // GetStorage().write('textListValue',
    //  newTextListValue ?? GetStorage().read('textListValue'));
  }

  void processSaveChoose({required int index}) {
    var result = GetStorage().read('displayValidate');
    var listOnes = GetStorage().read('listOnes');
    var listTwos = GetStorage().read('listTwos');
    var listThrees = GetStorage().read('listThrees');
    //var textListValue = GetStorage().read('textListValue');

    var chooses = <bool>[];
    chooses.add(listOnes[appController.indexBody.value][index]);
    chooses.add(listTwos[appController.indexBody.value][index]);
    chooses.add(listThrees[appController.indexBody.value][index]);
    //chooses.add(textListValue[appController.indexBody.value][index]);

    print('##11may choose ---> $chooses');

    result[appController.indexBody.value][index] = chooses.contains(true);
  }
}
