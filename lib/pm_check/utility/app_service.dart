import 'package:dio/dio.dart';
import 'package:engineer/pm_check/models/fetch_listMachine.dart';
import 'package:engineer/pm_check/models/fetch_listRepairPim.dart';
import 'package:engineer/pm_check/models/fetch_listStandards.dart';
import 'package:engineer/pm_check/utility/app%20_apiurl.dart';
import 'package:engineer/pm_check/utility/app_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AppService {
  AppController appController = Get.put(AppController());

//Get List Standard Machine
  Future<void> readGetMachineStdName() async {
    //get urlAPIgetMachine machine all
    await Dio().get(AppConstant.urlAPIgetMachineStd).then(
      (value) {
        print('-------------------Value from api------------------ $value');
        if (appController.machineModels.isNotEmpty) {
          appController.machineModels.clear();
          appController.tapOnes.clear();
          appController.tapTwos.clear();
          appController.tapThrees.clear();
        }
        // get machineModel
        for (var element in value.data) {
          MachineModel machineModel = MachineModel.fromMap(element);
          print('MachineModel------------------ ${machineModel.toMap()}');
          //Loop Machine แล้วมาเก็บไว้
          appController.machineModels.add(machineModel);
          bool? status = GetStorage().read('status');
          // print('status --> $status');

          if (!(status ?? false)) {
            appController.tapOnes.add(false);
            appController.tapTwos.add(false);
            appController.tapThrees.add(false);
          }
        }
      },
    );
  }
// //Get List Job By date and emp
//   Future<void> readGetJobRepairPM() async {
//     await Dio().get(AppConstant.urlAPIgetJobRepairPim).then((value) {
//       print('Value from api JobRepairPimmmmmm------------------ $value');
//       //if (appController.getRepairPim.isNotEmpty) {}
//       // get machineModel
//       // for (var element in value.data) {
//       //   GetRepair_Pim getRepair_Pim = GetRepair_Pim.fromMap(element);
//       //   print(
//       //       'MachineModel------------12121212------ ${getRepair_Pim.toMap()}');

//       // }
//     });
//   }

//Get List Job By date and emp
  // Future<void> readGetJobRepairPM() async {
  //   await Dio().get(AppConstant.urlAPIgetJobRepairPim).then(
  //     (value) {
  //       print('Value from api JobRepairPimmmmmm------------------ $value');
  //       for (var element in value.data) {
  //         GetRepair_Pim getRepair_Pim = GetRepair_Pim.fromMap(element);
  //         print(
  //             'MachineModel-----------------MachineModel------ ${getRepair_Pim.toMap()}');
  //       }
  //     },
  //   );

  // }

  Future<void> readGetJobRepairPM() async {
    try {
      var response = await Dio().get(AppConstant.urlAPIgetJobRepairPim);
      List<dynamic> data = response.data;
      appController.getRepairPim.clear();
      for (var element in data) {
        GetRepair_Pim getRepair_Pim = GetRepair_Pim.fromMap(element);
        print(
            'MachineModel-----------------MachineModel------ ${getRepair_Pim.toMap()}');
        appController.getRepairPim.add(getRepair_Pim);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

//Status CheckList
  Future<void> findStatus() async {
    if (GetStorage().read('status') ?? false) {
      for (var element in GetStorage().read('one')) {
        appController.tapOnes.add(element);
      }
      for (var element in GetStorage().read('two')) {
        appController.tapTwos.add(element);
      }
      for (var element in GetStorage().read('three')) {
        appController.tapThrees.add(element);
      }
    }
  }

//StandardModel
  Future<void> readStandardsModel() async {
    await Dio().get(AppConstant.urlAPIgetMachineStd).then(
      (value) {
        for (var element1 in value.data) {
          var standards = element1['Standards'];
          var standardsModels = <StandardsModel>[];
          var boolFalses = <bool>[];

          for (var element2 in standards) {
            StandardsModel standardsModel = StandardsModel.fromMap(element2);

            standardsModels.add(standardsModel);
            boolFalses.add(false);
          }
          appController.listStandardsModels.add(standardsModels);
          if (GetStorage().read('listOnes') == null) {
            //ทำงานครังแรกยังไม่เคยโหลดเลย

            //String startTime = changeTimeToString();

            //GetStorage().write('startTime', startTime);

            appController.listOnes.add(boolFalses);
            appController.listTwos.add(boolFalses);
            appController.listThrees.add(boolFalses);
            appController.displayValidates.add(boolFalses);

            // print('##8may ทำงานครังแรกยังไม่เคยโหลดเลย');
          }
        }
        if (appController.listOnes.isNotEmpty) {
          print('## at service listOnes --> ${appController.listOnes}');
          // print('##8may listTwos --> ${appController.listTwos}');
          // print('##8may listTheww --> ${appController.listThrees}');

          GetStorage().write('listOnes', appController.listOnes);
          GetStorage().write('listTwos', appController.listTwos);
          GetStorage().write('listThrees', appController.listThrees);
          GetStorage().write('displayValidate', appController.listThrees);
        }
      },
    );
  }

  String findValueFromIndex(
      {required int indexGroup, required int indexDetail}) {
    int value = 1;
    String valueString = value.toString();

    var listOnes = GetStorage().read('listOnes');
    var listTwos = GetStorage().read('listTwos');
    var listThrees = GetStorage().read('listThrees');

    var result = <bool>[];
    result.add(listOnes[indexGroup][indexDetail]);
    result.add(listTwos[indexGroup][indexDetail]);
    result.add(listThrees[indexGroup][indexDetail]);

    print('##11mayV2 result ---> $result');

    for (var element in result) {
      if (element) {
        valueString = value.toString();
      }
      value++;
    }

    return valueString;
  }

// Save Data CheckList
  Future<void> processSaveCheckList(String? remark) async {
    print('##11mayV2 listOnes --> ${GetStorage().read('listOnes')}');

    var details = <Map<String, dynamic>>[];

    for (var i = 0; i < appController.machineModels.length; i++) {
      int j = 0;
      for (var element in appController.listStandardsModels[i]) {
        // print('##11mayV2 element ---> ${element.toMap()}');

        // DetailForSaveModel detailForSaveModel = DetailForSaveModel(
        //     groupId: element.GroupID,
        //     typeId: element.TypeID,
        //     value: findValueFromIndex(indexGroup: i, indexDetail: j),
        //     stdValueMin: '0',
        //     stdValueMax: '0',
        //     strValue: '0');

        //ต้นฉบับ
        //details.add(detailForSaveModel.toMap());
        j++;
      }
    }

    // print('##11mayV2 ขนาดของ array details ---> ${details.length}');
    // print('##11mayV2 details --> $details');

    var testDetails = <Map<String, dynamic>>[];
    testDetails.add(details[0]);

    // DetailForPostModel detailForPostModel = DetailForPostModel(
    //     TruckID: truckId,
    //     CheckID: 0,
    //     StartTime: GetStorage().read('startTime'),
    //     EndTime: changeTimeToString(),
    //     EnterBy: username.toString(),
    //     Remark: remark.toString(),
    //     TripID: tripId,
    //     Details: details);

    //print('##detailForPost --> ${detailForPostModel.toMap()}');

    Dio dio = Dio();
    dio.options.headers['Content-Type'] = 'application/json';

    // await dio
    //     .post(AppConstant.urlAPIPostData, data: detailForPostModel.toMap())
    //     .then(
    //   (value) {
    //     print('##V2 Insert Success value --> $value');
    //   },
    // ).catchError(
    //   (onError) {
    //     print('##V2 onError --> $onError');
    //   },
    // );
  }

  // String findValueFromIndex(
  //     {required int indexGroup, required int indexDetail}) {
  //   int value = 1;
  //   String valueString = value.toString();

  //   var listOnes = GetStorage().read('listOnes');
  //   var listTwos = GetStorage().read('listTwos');
  //   var listThrees = GetStorage().read('listThrees');

  //   var result = <bool>[];
  //   result.add(listOnes[indexGroup][indexDetail]);
  //   result.add(listTwos[indexGroup][indexDetail]);
  //   result.add(listThrees[indexGroup][indexDetail]);

  //   print('##11mayV2 result ---> $result');

  //   for (var element in result) {
  //     if (element) {
  //       valueString = value.toString();
  //     }
  //     value++;
  //   }

  //   return valueString;
  // }

  // String changeTimeToString() {
  //   DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String result = dateFormat.format(DateTime.now());

  //   return result;
  // }
}
