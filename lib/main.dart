import 'package:engineer/app_router.dart';
import 'package:engineer/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic initRoute;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  initRoute = prefs.getBool('welcomeStatus') == true
      ? AppRouter.home
      : AppRouter.welcome;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showUpdateDialog();
    });
  }

  void _showUpdateDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'อัพเดตแอปพลิเคชัน',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'ขออภัยไม่สามารถใช้งานแอปพลิเคชันนี้ได้ กรุณาอัพเดทเวอร์ชั่นใหม่',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              const Divider(),
              TextButton(
                child: const Text(
                  'อัปเดตตอนนี้',
                  style: TextStyle(fontSize: 18),
                ),
                onPressed: () async {
                  const url =
                      'https://play.google.com/store/apps/details?id=com.pinepim.engineer.engineer';

                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'ไม่สามารถเปิดลิงก์ $url ได้';
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      title: 'Engineer App',
      initialRoute: initRoute,
      routes: AppRouter.routes,
    );
  }
}
