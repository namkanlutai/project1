import 'package:engineer/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Utility {
  static Widget TextFormFieldChecklistRemark(
    String hint,
    TextEditingController controller,
    bool obscure,
    IconData? icons,
    double screenWidth,
    double screenHeight,
    bool isNumber,
  ) {
    return Container(
      width: screenWidth,
      margin: EdgeInsets.only(bottom: screenHeight / 50),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
                color: Colors.black26, blurRadius: 10, offset: Offset(2, 2))
          ]),
      child: Row(
        children: [
          Container(
            //alignment: Alignment.bottomLeft,
            width: screenWidth / 6,
            child: Icon(
              icons,
              color: primary,
              size: screenWidth / 15,
            ),
          ),
          Expanded(
            child: Visibility(
              child: Padding(
                padding: EdgeInsets.only(right: screenWidth / 12),
                child: TextFormField(
                  controller: controller,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: isNumber
                      ? const TextInputType.numberWithOptions(decimal: true)
                      : TextInputType.text,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: screenHeight / 100),
                      border: InputBorder.none,
                      hintText: hint),
                  maxLines: 2,
                  obscureText: obscure,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
