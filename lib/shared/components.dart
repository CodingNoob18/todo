import 'package:flutter/material.dart';

Widget defaultButton({
  Color color = Colors.blue,
  double wid = double.infinity,
  required String label,
  Function? onPress,
}) => Container(
color: color,
width: wid,
child: MaterialButton(
child: Text(
label,
style: TextStyle(
color: Colors.white,
fontSize: 20,
),
),
onPressed: (){onPress!();},
),
);


Widget defaultTFF({
  Function? onTap,
  required TextEditingController control,
  required TextInputType type,
  Function? validate,
  required label,
  required IconData preIcon,
  IconData? sufIcon,
  bool isPassword = false,
  Function? sufFun,
  bool keyBoard = true,
}) => TextFormField(
    obscureText: isPassword ,
    controller: control,
    keyboardType: type,
    validator: (s){
      validate!(s);
      },
    decoration: InputDecoration(
        enabled: keyBoard,
        prefixIcon: Icon(preIcon),
        suffixIcon: sufIcon != null ? IconButton(
            icon: Icon(sufIcon),
            onPressed:(){sufFun!();},
        ) : null,
        labelText: label,
        border: OutlineInputBorder(),
),
  onTap: (){onTap!();},
);