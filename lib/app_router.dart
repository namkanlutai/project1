import 'package:engineer/pm_check/screens/mt_pim/screen_typepm.dart';
import 'package:engineer/screens/3_lining_installation/2_lining_home_screen.dart';
import 'package:engineer/screens/3_lining_installation/5_ramming.dart';
import 'package:engineer/screens/3_lining_installation/6_dimension_of_inside.dart';
import 'package:engineer/screens/6_changandbuild_ladle/changandbuild_ladle_home_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/coil/CoilCheckAntenna_3screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/coil/CoilCheckBottomStove_2screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/coil/CoilCheckMetalLeakageDetcor_4screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/coil/CoilCheckTopcasTable_1screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/coil/CoilFullFormBeforeAndAfter.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_1_con_beforeinstall_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_3_ramming_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_4_dimension_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_5_former_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_6_rammingofbottom_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_7_furnacebottom_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_8_rammingoftaper_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_9_summaryoflining_screen.dart';
import 'package:engineer/screens/time_input/addtime_screen.dart';
import 'package:engineer/screens/2_coil/CoilCheckAntenna_3screen.dart';
import 'package:engineer/screens/2_coil/CoilCheckBottomStove_2screen.dart';
import 'package:engineer/screens/2_coil/CoilCheckMetalLeakageDetcor_4screen.dart';
import 'package:engineer/screens/2_coil/CoilFullFormBeforeAndAfter.dart';
import 'package:engineer/screens/2_coil/coilhome_screen.dart';
import 'package:engineer/screens/2_coil/CoilCheckTopcasTable_1screen.dart';
import 'package:engineer/screens/home_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lining_2_insulation_screen.dart';
import 'package:engineer/screens/7_lining_installation_coil/lininghome_screen.dart';
import 'package:engineer/screens/pm_aluminum_furnace/pm_aluminum_FurnaceStructure1_screen.dart';
import 'package:engineer/screens/pm_aluminum_furnace/pm_aluminum_testrunning_screen.dart';
import 'package:engineer/screens/pm_aluminum_furnace/pm_aluminumchecklist_screen.dart';
import 'package:engineer/screens/pm_aluminum_furnace/pm_aluminumhome_screen.dart';
import 'package:engineer/screens/4_repair_coil/repair_coilcheck0_1_screen.dart';
import 'package:engineer/screens/4_repair_coil/repair_coilcheck0_2_screen.dart';
import 'package:engineer/screens/4_repair_coil/repair_coilcheck0_0screen.dart';
import 'package:engineer/screens/4_repair_coil/repair_coilcheck1_0_screen.dart';
import 'package:engineer/screens/4_repair_coil/repair_coilhome_screen.dart';
import 'package:engineer/screens/1_sintering/sinteringaftercheck_screen.dart';
import 'package:engineer/screens/1_sintering/sinteringchecklist_screen.dart';
import 'package:engineer/screens/login_screen.dart';
import 'package:engineer/screens/daily_report/memo_screen.dart';
import 'package:engineer/screens/daily_report/memoapprove_screen.dart';
import 'package:engineer/screens/daily_report/memoview_screen.dart';
import 'package:engineer/screens/profile.dart';
import 'package:engineer/screens/report_screen.dart';
import 'package:engineer/screens/signup_screen.dart';
import 'package:engineer/screens/1_sintering/sinteringhome_screen.dart';
import 'package:engineer/screens/time_input/time_screen.dart';
import 'package:engineer/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

import 'screens/3_lining_installation/3theconditionbefore_screen.dart';

class AppRouter {
  // Router Map Key
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String report = '/report';
  static const String time = '/time';
  static const String addtime = '/addtime';
  static const String memo = '/memo';
  static const String memoview = '/memoview';
  static const String memoapprove = '/memoapprove';
  static const String typm = '/pm_pim';
  static const String profile = '/profileuser';
  static const String lining = '/lining';
  static const String sinteringlist = '/sinteringlist';
  static const String sintering = '/sinteringhome';

  static const String coil = '/coilhome';
  static const String fullcoil = '/fullFormBeforeAndAfter';
  static const String topcastable = '/topcastableChecklist';
  static const String coilbutton = '/buttomChecklist';
  static const String coilantenna = '/CoilCheckAntenna';
  static const String coilMetal = '/CoilMetalLeakageDetcor';

  static const String fullcoil_lining = '/fullFormBeforeAndAfter_lining';
  static const String topcastable_lining = '/topcastableChecklist_lining';
  static const String coilbutton_lining = '/buttomChecklist_lining';
  static const String coilantenna_lining = '/CoilCheckAntenna_lining';
  static const String coilMetal_lining = '/CoilMetalLeakageDetcor_lining';

  static const String liningh = '/LiningHome';
  static const String liningbeforeinstall = '/liningcon_beforeinstall';
  static const String lininginsulation = '/lining_insulation';
  static const String liningramming = '/lining_ramming';
  static const String liningdimension = '/lining_dimension';
  static const String liningformer = '/lining_former';
  static const String liningrammingofbottom = '/lining_rammingofbottom';
  static const String liningfurnacebottom = '/lining_furnacebottom';
  static const String liningrammingoftaper = '/lining_rammingoftaper';
  static const String liningsummaryoflining = '/lining_summaryoflining';

  static const String aluminum = '/AluminumHome';
  static const String aluminumchecklist = '/Aluminumchecklist';
  static const String aluminumfurnacestructure1 = '/FurnaceStructure1';
  static const String aluminumfurnacetest = '/aluminumfurnacetest';
  static const String repaircoilhome = '/repair_coilhome';
  static const String repaircoilcheck0 = '/repair_coilcheck0';
  static const String repaircoilcheck0_1 = '/repair_coilcheck0_1';
  static const String repaircoilcheck0_2 = '/repair_coilcheck0_2';
  static const String repaircoilcheck1_0 = '/repair_coilcheck1_0_screen';

  static const String dismantlebuildladle = '/dismantleandbuild_ladle_home';
  static const String insulation = '/insulation'; //surasit หน้า 4
  static const String selectcheckmegaohmscreen =
      '/selectcheckmegaohmscreen'; //surasit หน้า11
// page kanlutai
  static const String conditionbefore = '/conditionbeforescreen';

  static const String lining_ramminghome_2 = '/lining_ramminghome';
  static const String rammingscreen_3 = '/ramming3screen';

  static const String dimension_of_furnace_inside_6 = '/6_dimension_of_inside';
//Router Map
  static get routes => {
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const SignUpScreen(),
        home: (context) => const HomeScreen(),
        report: (context) => const ReportScreen(),
        time: (context) => const TimeScreen(),
        addtime: (context) => AddTimeScreen(),
        memo: (context) => const MemoScreen(),
        memoview: (context) => const MemoviewScreen(),
        memoapprove: (context) => const MemoApproveScreen(),
        typm: (context) => const typepm(),
        profile: (context) => const profileuser(),

        lining: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return titilelining(timestamp: args['timestamp']);
        },
        sinteringlist: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return SinteringChecklist(timestamp: args['timestamp']);
        },
        sintering: (context) => const sinteringhome(),
        coil: (context) => const coilhome(),
        topcastable: (context) => const topcastableChecklist(),
        fullcoil: (context) => const fullFormBeforeAndAfter(),
        coilbutton: (context) => const buttomChecklist(),
        coilantenna: (context) => const CoilCheckAntenna(),
        coilMetal: (context) => const CoilMetalLeakageDetcor(),
        topcastable_lining: (context) => const topcastableChecklist_lining(),
        fullcoil_lining: (context) => const fullFormBeforeAndAfter_lining(),
        coilbutton_lining: (context) => const buttomChecklist_lining(),
        coilantenna_lining: (context) => const CoilCheckAntenna_lining(),
        coilMetal_lining: (context) => const CoilMetalLeakageDetcor_lining(),
        liningh: (context) => const LiningHome(),
        liningbeforeinstall: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return liningcon_beforeinstall(timestamp: args['timestamp']);
        },
        lininginsulation: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_insulation(timestamp: args['timestamp']);
        },
        liningramming: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_ramming(timestamp: args['timestamp']);
        },
        liningdimension: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_dimension(timestamp: args['timestamp']);
        },
        liningformer: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_former(timestamp: args['timestamp']);
        },
        liningrammingofbottom: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_rammingofbottom(timestamp: args['timestamp']);
        },
        liningfurnacebottom: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_furnacebottom(timestamp: args['timestamp']);
        },
        liningrammingoftaper: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_rammingoftaper(timestamp: args['timestamp']);
        },
        liningsummaryoflining: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return lining_summaryoflining(timestamp: args['timestamp']);
        },
        aluminum: (context) => const AluminumHome(),
        aluminumchecklist: (context) => const Aluminumchecklist(),
        aluminumfurnacestructure1: (context) => const FurnaceStructure1(),
        repaircoilhome: (context) => const repair_coilhome(),
        repaircoilcheck0: (context) => const repair_coilcheck(),
        repaircoilcheck0_1: (context) => const repair_coilcheck0_1(),
        repaircoilcheck0_2: (context) => const repair_coilcheck0_2(),
        repaircoilcheck1_0: (context) => const repair_coilcheck1_0_screen(),
        aluminumfurnacetest: (context) => const AluminumFurnaceTestRunning(),
        //chang and build ladle
        dismantlebuildladle: (context) => const dismantleandbuild_ladle_home(),
        // changandbuildladle: (context) {
        //   final args = ModalRoute.of(context)!.settings.arguments
        //       as Map<String, dynamic>;
        //   return changandbuild_ladle_home(timestamp: args['timestamp']);
        // },
        conditionbefore: (context) => const ConditionBeforeScreen(),
        // rammingscreen_3: (context) => const rammingscreen(),
        lining_ramminghome_2: (context) => const lining_ramminghome(),

        lining_ramminghome_2: (context) => const lining_ramminghome(),
        rammingscreen_3: (context) => const ramming3screen(),

        dimension_of_furnace_inside_6: (context) =>
            const DimensionOfInsideScreen6(),
      };
}
