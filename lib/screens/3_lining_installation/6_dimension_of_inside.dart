import 'package:engineer/components/button_component.dart';
import 'package:engineer/components/list_text_feild.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/models/user_model.dart';
import 'package:engineer/services/authenticate_api.dart';
import 'package:engineer/services/form_all_api.dart';
import 'package:engineer/themes/colors.dart';
import 'package:engineer/themes/styles.dart';
import 'package:flutter/material.dart';

class DimensionOfInsideScreen6 extends StatefulWidget {
  const DimensionOfInsideScreen6({super.key});

  @override
  State<DimensionOfInsideScreen6> createState() =>
      _DimensionOfInsideScreen6State();
}

class _DimensionOfInsideScreen6State extends State<DimensionOfInsideScreen6> {
  UserModel user = UserModel(); // API user
  AuthenticateApi authenticateApi = AuthenticateApi(); // API module

  // List fetching
  final ApiService _apiService = ApiService();
  Future<List<ListItem>>? _sinteringItems;

  @override
  void initState() {
    super.initState();
    _sinteringItems = _apiService.fetchListItem('28'); // Fetching FormID = 28
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          color: bluedark,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Dimension of Furnace Inside',
            style: AppTextStyle.headerTitle),
        backgroundColor: bgprimary,
      ),
      backgroundColor: bgprimary,
      body: FutureBuilder<List<ListItem>>(
        future: _sinteringItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No items found.'));
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(child: Text('No type names available.'));
          }

          // Filter items by groupId
          final group89Items =
              items.where((item) => item.groupId == 89).toList();
          final group90Items =
              items.where((item) => item.groupId == 90).toList();

         return ListView(
  padding: const EdgeInsets.all(8.0),
  children: [
    if (group89Items.isNotEmpty)
      _buildCardWithInput(
        title: 'Dimension of Furnace Inside',
        groupItems: group89Items,
        showSTD: true, // Show STD for group89Items
      ),
    if (group90Items.isNotEmpty)
      _buildCardWithInput(
        title: 'ตำแหน่งติดตั้ง 1st Antenna',
        groupItems: group90Items,
        showSTD: false, // Hide STD for group90Items
      ),
    Align(
      alignment: Alignment.center, // จัดปุ่มให้อยู่ตรงกลาง
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // ความกว้าง 50% ของหน้าจอ
        child: CustomButton(
          label: 'Save',
          onPressed: () {
            // Add save logic here
          },
          backgroundColor: bluedark,
          textColor: textprimary,
          borderRadius: 16.0,
        ),
      ),
    ),
  ],
);

        },
      ),
    );
  }
}

Widget _buildCardWithInput({
  required String title,
  required List<ListItem> groupItems,
  required bool showSTD,
}) {
  // Map ListItem to menuItems format
  List<Map<String, dynamic>> menuItems = groupItems.map((item) {
    String displayTitle = showSTD
        ? "Position: ${item.typeName} (STD: ${item.stdValueMin.toInt() ?? "N/A"})"
        : "Position: ${item.typeName}";

    return {
      "title": displayTitle,
      "inputType": item.typeValue,
    };
  }).toList();

  return Container(
    margin: const EdgeInsets.all(8.0),
    decoration: BoxDecoration(
      color: bgprimary, // Background color
      borderRadius: BorderRadius.circular(16.0), // Rounded corners
    ),
    padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(title, style: AppTextStyle.title),
        const SizedBox(height: 8.0),
        Image.network(
          'https://via.placeholder.com/300', // Replace this with your desired image URL
          fit: BoxFit.cover,
          width: double.infinity, // Ensures it takes up full width
          height: 150, // Adjust height as needed
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Text(
                'Failed to load image',
                style: TextStyle(color: Colors.red),
              ),
            );
          },
        ),
        const SizedBox(height: 8.0),
        ListInputNum(menuItems: menuItems),
      ],
    ),
  );
}
