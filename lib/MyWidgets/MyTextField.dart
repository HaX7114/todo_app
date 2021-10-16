import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/Consts.dart';

class MyTextField extends StatelessWidget {
  final labelText;
  final labelTextColor;
  final prifixIcon;
  final borderColor;
  final borderRadius;
  final validatorText;
  final TextEditingController textController;

  const MyTextField(
      {Key? key,
      required this.labelText,
      required this.borderColor,
      required this.validatorText,
      this.prifixIcon,
      required this.textController,
      this.borderRadius,
      this.labelTextColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      maxLength: 25,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorText;
        }
      },
      decoration: InputDecoration(
        labelStyle: GoogleFonts.poppins(
          color: labelTextColor ?? K_greyColor,
          fontSize: 13.0,
        ),
        prefixIcon: Icon(
          prifixIcon,
          color: borderColor,
        ),
        labelText: labelText,
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?? 20.0),
            borderSide: BorderSide(
              color: borderColor,
            )),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?? 20.0),
            borderSide: BorderSide(
              color: borderColor,
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?? 20.0),
            borderSide: BorderSide(
              color: borderColor,
            )),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius?? 20.0),
            borderSide: BorderSide(
              color: borderColor,
            )),
      ),
    );
  }
}
