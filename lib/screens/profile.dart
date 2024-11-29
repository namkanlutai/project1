import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:engineer/components/component_header.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/profile_api.dart';

class profileuser extends StatefulWidget {
  const profileuser({super.key});

  @override
  _ProfileUserState createState() => _ProfileUserState();
}

class _ProfileUserState extends State<profileuser> {
  UserModel user = UserModel();
  AuthenticateApi authenticateApi = AuthenticateApi();
  ProfileApi profileApi = ProfileApi();

  double? creditAmount;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  // Fetch user details and then fetch credit balance
  void getUser() async {
    user = await authenticateApi.getUser();
    setState(() {});

    // Check if the employee code is non-null before fetching the credit balance
    if (user.employeeCode != null) {
      fetchCreditBalance(user.employeeCode!);
    }
  }

  // Fetch the credit amount from ProfileApi
  void fetchCreditBalance(int employeeCode) async {
    final creditBalance = await profileApi.getCreditAmount(employeeCode);
    if (creditBalance != null) {
      setState(() {
        creditAmount = creditBalance.amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgprimary, // เปลี่ยนสีพื้นหลัง
      body: SingleChildScrollView(
        child: Column(
          children: [
            ComponentHeader(user: user, isHome: false),
            const SizedBox(height: 15),
            Center(
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // จัดให้อยู่ตรงกลางภายใน Row
                children: <Widget>[
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textprimary, // สีตัวอักษร
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            buildInfoRow(
                '   Name', '${user.firstname ?? ''} ${user.lastname ?? ''}'),
            buildInfoRow('   Employee Code', '${user.employeeCode ?? 'N/A'}'),
            buildInfoRow('   Division', '${user.depid ?? 'N/A'}'),
            buildInfoRow(
              '   Work Start',
              user.dateStartJob != null
                  ? user.dateStartJob!.toLocal().toString().split(' ')[0]
                  : 'N/A',
            ),
            buildInfoRow(
                '   Balance Credit', '${creditAmount ?? 'Loading...'} Baht'),
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              '$label: $value',
              style: TextStyle(fontSize: 18, color: textprimary), // สีตัวอักษร
            ),
          ],
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 16.0), // กำหนดระยะห่างจากขอบซ้าย-ขวา
          child: Divider(
            color: textsecondary,
            thickness: 0.5,
          ),
        ),
      ],
    );
  }
}
