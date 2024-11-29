import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/services/form_all_api.dart';

class ConditionBeforeScreen extends StatefulWidget {
  const ConditionBeforeScreen({super.key});

  @override
  State<ConditionBeforeScreen> createState() => _ConditionBeforeScreenState();
}

class _ConditionBeforeScreenState extends State<ConditionBeforeScreen> {
  final ApiService _apiService = ApiService();
  Future<List<ListItem>>? _sinteringItems;

  @override
  void initState() {
    super.initState();
    _sinteringItems = _apiService.fetchListItem('25'); // รหัส TypeNo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgprimary,
      appBar: AppBar(
        backgroundColor: bgprimary,
        leading: const Icon(Icons.arrow_back_ios_new, color: bluedark),
        title: const Text('The Condition Before Installation'),
      ),
      body: FutureBuilder<List<ListItem>>(
        future: _sinteringItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 48),
                  Text(
                    'Error loading data.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Text(
                    snapshot.error.toString(),
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No items found.'));
          }

          // จัดกลุ่มข้อมูลตาม groupNo
          final groupedItems = _groupItemsByGroupNo(snapshot.data!);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: groupedItems.entries.map((entry) {
                final groupNo = entry.key;
                final groupItems = entry.value;
                final groupName =
                    entry.value.first.typeName ?? 'Group $groupNo';

                return _buildGroupCard(groupNo, groupItems, groupName);
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  /// แยกข้อมูลตาม `groupNo`
  Map<int, List<ListItem>> _groupItemsByGroupNo(List<ListItem> items) {
    final Map<int, List<ListItem>> groupedItems = {};

    for (var item in items) {
      groupedItems.putIfAbsent(item.groupId ?? 0, () => []).add(item);
    }
    return groupedItems;
  }

  /// สร้าง Card สำหรับแต่ละกลุ่ม
  Widget _buildGroupCard(
      int groupNo, List<ListItem> groupItems, String groupName) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 8.0), // Add padding above and below the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the group name outside the card, above it
          Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0), // Add space below the group name
            child: Text(
              '$groupName', // Show the group name
              style: const TextStyle(
                fontSize: 20, // Adjust the font size
                fontWeight: FontWeight.bold, // Bold for emphasis
                color: Colors.white, // White text for contrast
              ),
            ),
          ),
          // Card containing the group items
          Card(
            color: bgcard,
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mapping groupItems to ListView with dividers
                  Column(
                    children: [
                      for (var i = 0; i < groupItems.length; i++)
                        Column(
                          children: [
                            _buildDetailItem(groupItems[i]),
                            if (i != groupItems.length - 1)
                              const Divider(
                                color: greydark,
                                thickness: 0.5,
                              ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// สร้าง UI สำหรับแต่ละ Detail Item
  Widget _buildDetailItem(ListItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // เพิ่มระยะห่างบนล่าง
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // จัดตำแหน่งให้เหมาะสม
        children: [
          // Left: Text displaying the item details
          Expanded(
            child: Text(
              item.typeName ?? '',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          // Right: TextFormField for user input without SizedBox
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            width: 100, // กำหนดความกว้างของช่องกรอกข้อมูล
            padding: const EdgeInsets.only(
                left: 8.0), // เพิ่มระยะห่างระหว่างข้อความและ input field
            child: TextFormField(
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                suffixText: _getUnitSymbol(item.unitId),
                suffixStyle: const TextStyle(color: Colors.white, fontSize: 14),
                hintStyle: const TextStyle(
                    color: Colors.white), // Set hint text color to black
              ),
              style: const TextStyle(color: Colors.white),
              // Text color inside input field
            ),
          )
        ],
      ),
    );
  }

  /// ฟังก์ชันเพื่อกำหนด Unit Symbol ตาม unitId
  String _getUnitSymbol(String? unitId) {
    if (unitId == 'Megaohms') {
      return 'Ω'; // Ω symbol for Megaohm
    } else if (unitId == 'kilogram per square centimeter') {
      return 'kg /cm²'; // kg /cm² symbol for kilogram per square centimeter
    }
    return unitId ?? ''; // Return the unitId if no match
  }
}
