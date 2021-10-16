import 'package:flutter/material.dart';
import 'package:todo_app/Consts.dart';
import 'package:todo_app/MyWidgets/MyText.dart';


class MyButton extends StatelessWidget {
  final onPressed;
  final text;
  final textColor;
  final textSize;
  final fillColor;
  final fontWeight;
  final shadow;
  final borderRadius;


  const MyButton({Key? key,this.text,this.textSize,this.fontWeight,this.shadow,this.textColor,this.fillColor,this.borderRadius,this.onPressed}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      child: RawMaterialButton(
        elevation: shadow?? 0.0,
        onPressed: onPressed,
        child: MyText(
          text: text,
          size: textSize?? 15.0,
          fontWeight: fontWeight?? FontWeight.w600,
          color: textColor?? K_whiteColor,
        ),
        fillColor: fillColor?? K_pinkColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius?? K_radius)),
      ),
    );
  }
}
