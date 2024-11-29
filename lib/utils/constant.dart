const baseURLAPI = 'https://iot.pinepacific.com/WebApi/api/';

class AppConstant {
  static String urlAPIgetListItem(String fromID) {
    return 'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetListSintering?FromID=$fromID';
  }

  static String urlAPIgetListSintering2 =
      'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetListSintering?FromID=2';

  static String urlAPIgetCreditBalance =
      'https://iot.pinepacific.com/WebApi/api/EngineerFrom/GetListSintering?FromID=2';
}

class AppConstantPost {
  static String urlAPIPostDataByFormID =
      'https://iot.pinepacific.com/WebApi/api/EngineerFrom/InserDTFromSintering';
}
