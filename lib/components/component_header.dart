import 'package:engineer/app_router.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';

class ComponentHeader extends StatelessWidget {
  final UserModel user;
  final bool isHome;

  const ComponentHeader({Key? key, required this.user, required this.isHome})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600; // ตรวจสอบขนาดหน้าจอ

    return OrientationBuilder(
      builder: (context, orientation) {
        final isLandscape =
            orientation == Orientation.landscape; // ตรวจสอบหน้าจอเป็นแนวนอน

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
          height: isTablet ? 200 : 171, // ปรับความสูงตามอุปกรณ์
          decoration: const BoxDecoration(color: primarytitle),
          child: SingleChildScrollView(
            // แก้ปัญหาการล้นโดยใช้ SingleChildScrollView
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Main content: รูปโปรไฟล์และชื่อผู้ใช้
                    isLandscape
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildProfilePicture(screenWidth, isTablet),
                              const SizedBox(
                                  width: 15), // ระยะห่างระหว่างรูปกับชื่อ
                              _buildUserName(isTablet),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfilePicture(screenWidth, isTablet),
                              const SizedBox(height: 5),
                              _buildUserName(isTablet),
                            ],
                          ),
                    Spacer(), // ใช้ Spacer เพื่อจัดการการขยายพื้นที่
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: button,
                          ),
                          child: IconButton(
                            icon: isHome
                                ? const Icon(
                                    Icons.notifications,
                                    size: 28,
                                    color: background,
                                  )
                                : const Icon(
                                    Icons.arrow_back,
                                    size: 28,
                                    color: background,
                                  ),
                            onPressed: () {
                              if (!isHome) {
                                Navigator.pushReplacementNamed(
                                    context, AppRouter.home);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: button,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.logout_outlined,
                              size: 28,
                              color: background,
                            ),
                            onPressed: () async {
                              Navigator.pushReplacementNamed(
                                  context, AppRouter.login);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ฟังก์ชันสำหรับสร้างชื่อผู้ใช้โดยตัดให้เหลือ 18 ตัวอักษรในจอโทรศัพท์
  Widget _buildUserName(bool isTablet) {
    String fullName = '${user.firstname} ${user.lastname}';
    String displayName = fullName;

    // ถ้าหน้าจอเป็นโทรศัพท์ ให้ตัดชื่อที่เกิน 18 ตัวอักษร
    if (!isTablet && fullName.length > 15) {
      displayName = '${fullName.substring(0, 15)}...';
    }

    return Text(
      displayName,
      style: TextStyle(
        fontSize: isTablet ? 28.0 : 23.0, // ปรับขนาดตัวอักษร
        color: background,
      ),
    );
  }

  // ฟังก์ชันสำหรับสร้างรูปโปรไฟล์
  Widget _buildProfilePicture(double screenWidth, bool isTablet) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          width: isTablet ? screenWidth * 0.12 : screenWidth * 0.2,
          height: isTablet ? screenWidth * 0.12 : screenWidth * 0.2,
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: user.imageUrl != null && user.imageUrl!.isNotEmpty
              ? Image.network(
                  user.imageUrl!,
                  fit: BoxFit.cover,
                )
              : const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
