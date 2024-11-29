import 'package:engineer/themes/styles.dart';
import 'package:flutter/material.dart';
import 'package:engineer/themes/colors.dart';

class ListInputNum extends StatefulWidget {
  final List<Map<String, dynamic>> menuItems;

  const ListInputNum({
  Key? key,
  required this.menuItems,
}) : super(key: key);


  @override
  _ListInputNumState createState() => _ListInputNumState();
}

class _ListInputNumState extends State<ListInputNum> {
  int? selectedIndex; // Tracks the selected index
  List<TextEditingController> controllers = []; // Controllers for TextFields

  @override
  void initState() {
    super.initState();
    // Initialize a TextEditingController for each menu item
    controllers = widget.menuItems.map((_) => TextEditingController()).toList();
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: bgcard,
        borderRadius: BorderRadius.circular(10.0), // Rounded edges for the whole container
      ),
      child: ListView.separated(
        itemCount: widget.menuItems.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(            
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Row(             
              children: [
                Expanded(
                  child: Text(
                    "${widget.menuItems[index]["title"]}",
                    style: AppTextStyle.content,
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: TextField(
                    textAlign: TextAlign.end,
                    controller: controllers[index],
                    style: const TextStyle(color: textprimary),
                    keyboardType: widget.menuItems[index]["inputType"] == "v"
                        ? TextInputType.number // Numeric input
                        : TextInputType.text, // Text input
                    decoration: InputDecoration(
                      hintText: widget.menuItems[index]["inputType"] == "v"
                          ? 'Enter number'
                          : 'Enter text',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(
          color: greydark,
          thickness: 0.5,
          height: 0, // Set height to 0 to remove vertical spacing
          indent: 0, // No left margin
          endIndent: 0, // No right margin
        ),
      ),
    );
  }
}
