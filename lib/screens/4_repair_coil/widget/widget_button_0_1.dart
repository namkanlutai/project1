import 'package:flutter/material.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/themes/colors.dart';

class CardWithButtonsrepaircoil_0_1 extends StatefulWidget {
  final ListItem item;
  final int index;
  final TextEditingController controller;
  final List<ListItem> items;
  final Function(int index, String selectedValue, String textFieldValue)
      onValueSelected;
  final String? initialSelectedValue;

  const CardWithButtonsrepaircoil_0_1({
    Key? key,
    required this.item,
    required this.index,
    required this.items,
    required this.controller,
    required this.onValueSelected,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  _CardWithButtonsState createState() => _CardWithButtonsState();
}

class _CardWithButtonsState extends State<CardWithButtonsrepaircoil_0_1> {
  List<TextEditingController> _controllers = [];
  List<String> _remarks = [];
  String? _selectedButtonValue;

  @override
  void initState() {
    super.initState();
    _selectedButtonValue = widget.initialSelectedValue;
    _addRemarkField(); // Initialize with one text field
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose(); // Dispose controllers when done
    }
    super.dispose();
  }

  void _addRemarkField() {
    setState(() {
      _controllers.add(TextEditingController());
      _remarks.add('');
    });
  }

  void _removeRemarkField(int index) {
    setState(() {
      _controllers[index].dispose();
      _controllers.removeAt(index);
      _remarks.removeAt(index);
      _updateRemarks(); // Update the callback with the current remarks
    });
  }

  void _updateRemarks() {
    // Add numbering to each remark
    String numberedRemarks = _remarks.asMap().entries.map((entry) {
      int index = entry.key + 1; // Index + 1 for 1-based numbering
      String remark = entry.value;
      return '$index.$remark';
    }).join(' ');

    widget.onValueSelected(
        widget.index, _selectedButtonValue ?? '', numberedRemarks);
  }

  @override
  Widget build(BuildContext context) {
    int itemNumber = widget.index + 1;
    List<String> messages = ['Good', 'NG'];

    return Card(
      color: primaryText,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '$itemNumber. ${widget.item.typeName}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: icons,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (widget.item.stdValueMin != null ||
                    widget.item.stdValueMax != null)
                  Flexible(
                    child: Text(
                      '     Standard: ${widget.item.stdValueMin ?? "N/A"} - ${widget.item.stdValueMax ?? "N/A"}  ${widget.item.unitId ?? ""}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: icons,
                      ),
                    ),
                  ),
              ],
            ),
            //const SizedBox(height: 8),
            // Dynamically created TextFields
            Column(
              children: List.generate(_controllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controllers[index],
                          style: const TextStyle(
                            fontSize: 16,
                            color: icons,
                          ),
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          minLines: 1,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              ),
                            ),
                            labelText: 'Result ${index + 1}',
                            labelStyle: const TextStyle(
                              color: icons,
                            ),
                            hintText: 'Input Result',
                            hintStyle: const TextStyle(
                              color: icons,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 10),
                            isDense: true,
                            suffixText: widget.item.unitId ?? '',
                            suffixStyle: const TextStyle(
                              fontSize: 16,
                              color: icons,
                            ),
                          ),
                          onChanged: (value) {
                            _remarks[index] = value;
                            _updateRemarks(); // Update the callback with the current remarks
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          _removeRemarkField(index);
                        },
                      ),
                    ],
                  ),
                );
              }),
            ),
            //const SizedBox(
            //height: 15), // Add space between TextField and buttons
            Row(
              children: [
                // Add Remark Button
                TextButton.icon(
                  onPressed: _addRemarkField,
                  icon: const Icon(Icons.add, color: icons),
                  label: const Text(
                    'Add Result',
                    style: TextStyle(color: icons),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                // Buttons Section
                Wrap(
                  spacing: 10.0,
                  runSpacing: 10.0,
                  children: List.generate(
                    2, // Number of buttons
                    (btnIndex) {
                      String buttonText;
                      String buttonValue;
                      Color buttonColor;

                      if (btnIndex == 0) {
                        buttonText = 'Good';
                        buttonValue = '1'; // Good = 1
                        buttonColor = _selectedButtonValue == '1'
                            ? Colors.green
                            : divider;
                      } else {
                        buttonText = 'No Good';
                        buttonValue = '2'; // No Good = 2
                        buttonColor =
                            _selectedButtonValue == '2' ? Colors.red : divider;
                      }

                      return InkWell(
                        onLongPress: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(messages[btnIndex]),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 150,
                          height: 40,
                          child: FloatingActionButton.extended(
                            heroTag:
                                '${widget.index}_btn_$btnIndex', // Make heroTag unique
                            onPressed: () {
                              setState(() {
                                _selectedButtonValue = buttonValue;
                                widget.onValueSelected(widget.index,
                                    buttonValue, _remarks.join('; '));
                              });
                            },
                            label: Text(
                              buttonText,
                              style: const TextStyle(fontSize: 14),
                            ),
                            icon: Icon(
                              btnIndex == 1 ? Icons.thumb_down : Icons.thumb_up,
                              size: 20,
                            ),
                            backgroundColor: buttonColor, // Updated color
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
