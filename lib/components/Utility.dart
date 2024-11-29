import 'dart:ui';

class Utiltiy {
  static Color floatingColor = const Color(0xFF0091EA);
  static Color primary = const Color(0xFFEEF444C);
  static Color complete = const Color.fromARGB(253, 63, 219, 76);
  static Color propose = const Color.fromARGB(253, 204, 118, 48);

  static DateTime convertStringToDateTime(String date) {
    var dt = date.split(' ');
    var mn = 1;
    switch (dt[1]) {
      case 'Jan':
        mn = 1;
        break;
      case 'Feb':
        mn = 2;
        break;
      case 'Mar':
        mn = 3;
        break;
      case 'Apr':
        mn = 4;
        break;
      case 'May':
        mn = 5;
        break;
      case 'Jun':
        mn = 6;
        break;
      case 'Jul':
        mn = 7;
        break;
      case 'Aug':
        mn = 8;
        break;
      case 'Sep':
        mn = 9;
        break;
      case 'Oct':
        mn = 10;
        break;
      case 'Nov':
        mn = 11;
        break;
      case 'Dec':
        mn = 12;
        break;
      default:
        mn = 1;
    }
    DateTime result = DateTime(int.parse(dt[2]), mn, int.parse(dt[0]));
    return result;
  }

  static int convertStringToMinutes(String timer, bool isMinutes) {
    if (timer == '--/--') timer = '00:00';
    var dt = timer.split(':');
    int result = isMinutes ? int.parse(dt[1]) : int.parse(dt[0]);
    return result;
  }
}
