import 'package:engineer/pm_check/models/fetch_listMachine.dart';
import 'package:engineer/pm_check/models/fetch_listRepairPim.dart';
import 'package:engineer/pm_check/models/fetch_listStandards.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class AppController extends GetxController {
  RxList tapOnes = <bool>[].obs;
  RxList tapTwos = <bool>[].obs;
  RxList tapThrees = <bool>[].obs;

  RxList listOnes = <List<bool>>[].obs;
  RxList listTwos = <List<bool>>[].obs;
  RxList listThrees = <List<bool>>[].obs;

  RxList machineModels = <MachineModel>[].obs;
  RxInt indexBody = 0.obs;
  RxList listStandardsModels = <List<StandardsModel>>[].obs;

  RxList displayValidates = <List<bool>>[].obs;

  RxBool showErrorValidate = false.obs;
  RxBool checkValidate = true.obs;

  //Repair PIM

  RxList getRepairPim = <GetRepair_Pim>[].obs;
}
