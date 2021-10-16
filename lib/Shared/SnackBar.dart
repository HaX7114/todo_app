
import 'package:flutter/material.dart';
import 'package:todo_app/MyWidgets/MyText.dart';

showSnackBar(context,text,color,{icon,iconColor}){
  return Scaffold.of(context)
      .showSnackBar(
      SnackBar(
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          content: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                MyText(text: text, size: 15.0,color: color,fontWeight: FontWeight.w400,),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  icon,
                  color: iconColor,
                )
              ],
            ),
          )
      )
  );
}