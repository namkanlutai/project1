import 'package:flutter/material.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/themes/colors.dart';

class CardWithButtons extends StatefulWidget {
  final ListItem item;
  final int index;
  final List<ListItem> items;
  final Function(int index, String selectedValue, String textFieldValue)
      onValueSelected;
  final TextEditingController controller;
  final String?
      initialSelectedValue; // Add this parameter to pass the initial selected value

  const CardWithButtons({
    Key? key,
    required this.item,
    required this.index,
    required this.items,
    required this.onValueSelected,
    required this.controller,
    this.initialSelectedValue, // Add this parameter to the constructor
  }) : super(key: key);

  @override
  _CardWithButtonsState createState() => _CardWithButtonsState();
}

class _CardWithButtonsState extends State<CardWithButtons> {
  int? _selectedButtonIndex;

  @override
  void initState() {
    super.initState();
    // Initialize the selected button based on the initialSelectedValue
    if (widget.initialSelectedValue != null &&
        widget.initialSelectedValue!.isNotEmpty) {
      _selectedButtonIndex =
          5 - int.parse(widget.initialSelectedValue!); // Reverse index logic
    }
  }

  Color _getButtonColor(int btnIndex) {
    if (_selectedButtonIndex == btnIndex) {
      if (btnIndex == 0 || btnIndex == 1) {
        return Colors.green; // For buttons 5 and 4
      } else if (btnIndex == 2 || btnIndex == 3) {
        return Colors.yellow; // For buttons 3 and 2
      } else if (btnIndex == 4) {
        return Colors.red; // For button 1
      } else if (btnIndex == 5) {
        return Colors.orange; // For N/A button
      }
    }
    return divider; // Default color when not selected
  }

  @override
  Widget build(BuildContext context) {
    int itemNumber = widget.index + 1;
    List<String> messages = [
      'No need for repair / replacement',
      'Confirmation required at next annual inspection',
      'Consideration for repair / replacement within 1 year',
      'Need for repair / replacement within 6 months',
      'Need for immediate repair / replacement',
      'N/A'
    ];

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
            const SizedBox(height: 5),
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
            const SizedBox(height: 15),
            Wrap(
              spacing: 5.0,
              runSpacing: 10.0,
              children: List.generate(
                6,
                (btnIndex) {
                  String buttonText;
                  String buttonValue;

                  if (btnIndex < 5) {
                    int reverseIndex = 5 - btnIndex;
                    buttonText = '$reverseIndex';
                    buttonValue = '$reverseIndex';
                  } else {
                    buttonText = 'N/A';
                    buttonValue = '0';
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
                      width: 55,
                      height: 40,
                      child: FloatingActionButton.extended(
                        heroTag: 'btn_$btnIndex',
                        onPressed: () {
                          setState(() {
                            _selectedButtonIndex = btnIndex;
                            widget.onValueSelected(widget.index, buttonValue,
                                widget.controller.text);
                          });
                        },
                        label: Text(
                          buttonText,
                          style: const TextStyle(fontSize: 14),
                        ),
                        icon: Icon(
                          btnIndex == 5
                              ? Icons.block
                              : Icons.add_reaction_outlined,
                          size: 20,
                        ),
                        backgroundColor: _getButtonColor(btnIndex),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 400,
                    child: TextField(
                      controller: widget.controller,
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
                        labelText: 'Remark',
                        labelStyle: const TextStyle(
                          color: icons,
                        ),
                        hintText: 'Input Remark',
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
                        widget.onValueSelected(
                            widget.index,
                            _selectedButtonIndex != null
                                ? '${5 - _selectedButtonIndex!}'
                                : '',
                            value);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
