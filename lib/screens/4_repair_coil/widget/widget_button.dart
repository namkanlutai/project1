import 'package:flutter/material.dart';
import 'package:engineer/models/sintering_model.dart';
import 'package:engineer/themes/colors.dart';

class CardWithButtonsrepaircoil extends StatefulWidget {
  final ListItem item;
  final int index;
  final List<ListItem> items;
  final Function(int index, String selectedValue, String textFieldValue)
      onValueSelected;
  final TextEditingController controller;
  final String? initialSelectedValue;

  const CardWithButtonsrepaircoil({
    Key? key,
    required this.item,
    required this.index,
    required this.items,
    required this.onValueSelected,
    required this.controller,
    this.initialSelectedValue,
  }) : super(key: key);

  @override
  _CardWithButtonsState createState() => _CardWithButtonsState();
}

class _CardWithButtonsState extends State<CardWithButtonsrepaircoil> {
  int? _selectedButtonIndex;
  bool _isTextFieldVisible = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialSelectedValue != null &&
        widget.initialSelectedValue!.isNotEmpty) {
      _selectedButtonIndex = 2 - int.parse(widget.initialSelectedValue!);
      _isTextFieldVisible = widget.initialSelectedValue == '1';
    }
  }

  Color _getButtonColor(int btnIndex) {
    if (_selectedButtonIndex == btnIndex) {
      if (btnIndex == 0) {
        return Colors.green;
      } else if (btnIndex == 1) {
        return Colors.orange;
      }
    }
    return divider;
  }

  @override
  Widget build(BuildContext context) {
    int itemNumber = widget.index + 1;
    List<String> messages = ['เลือกปัญหา', 'N/A'];

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
            // const SizedBox(height: 5),
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
            const SizedBox(height: 8),
            Row(
              children: [
                // Buttons Section
                Wrap(
                  spacing: 5.0,
                  runSpacing: 10.0,
                  children: List.generate(
                    2,
                    (btnIndex) {
                      String buttonText;
                      String buttonValue;

                      if (btnIndex < 1) {
                        int reverseIndex = 1 - btnIndex;
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
                          width: 70,
                          height: 30,
                          child: FloatingActionButton.extended(
                            heroTag: 'btn_$btnIndex',
                            onPressed: () {
                              setState(() {
                                _selectedButtonIndex = btnIndex;
                                _isTextFieldVisible = buttonValue == '1';
                                widget.onValueSelected(widget.index,
                                    buttonValue, widget.controller.text);
                              });
                            },
                            label: Text(
                              buttonText,
                              style: const TextStyle(fontSize: 14),
                            ),
                            icon: Icon(
                              btnIndex == 1
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

                // Spacing between buttons and TextField
                const SizedBox(width: 15),

                // Conditionally Visible TextField Section
                Visibility(
                  visible: _isTextFieldVisible,
                  child: Flexible(
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
                                  ? '${1 - _selectedButtonIndex!}'
                                  : '',
                              value);
                        },
                      ),
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
