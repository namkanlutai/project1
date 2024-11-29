import 'package:dio/dio.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/utils/constant.dart';

class ApiService {
  final Dio _dio = Dio();

// Future<List<SinteringItem>> fetchListSintering(String fromID) async {
//     try {
//       final response = await _dio.get(
//         AppConstant.urlAPIgetListSintering(fromID),
//       );
//       if (response.statusCode == 200) {
//         List<dynamic> data = response.data;
//         return data.map((json) => SinteringItem.fromJson(json)).toList();
//       } else {
//         print('Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return [];
//     }
//   }

//   Future<List<SinteringItem>> fetchListSinteringtitile() async {
//     try {
//       final response = await _dio.get(AppConstant.urlAPIgetListSintering2);
//       if (response.statusCode == 200) {
//         List<dynamic> data = response.data;
//         return data.map((json) => SinteringItem.fromJson(json)).toList();
//       } else {
//         print('Error: ${response.statusCode}');
//         return [];
//       }
//     } catch (e) {
//       print('Exception: $e');
//       return [];
//     }
//   }
// }

  Future<List<ListItem>> fetchListItem(String fromID) async {
    try {
      final response = await _dio.get(
        AppConstant.urlAPIgetListItem(fromID),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ListItem.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }

  Future<List<ListItem>> fetchListSinteringtitile() async {
    try {
      final response = await _dio.get(AppConstant.urlAPIgetListSintering2);
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((json) => ListItem.fromJson(json)).toList();
      } else {
        print('Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Exception: $e');
      return [];
    }
  }
}
