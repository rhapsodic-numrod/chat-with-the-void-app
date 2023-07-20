import 'package:flutter/material.dart';

SizedBox addWidth(double width) => SizedBox(width: width,);
SizedBox addHeight(double height) => SizedBox(height:height);

void closeKeyBoard(BuildContext context){
  FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
}