
import 'package:flutter/material.dart';

class LoginButtonComponent extends StatelessWidget {
  double width = double.infinity;
  double height = 45;
  bool isUpper = true;
  Color backColor = Colors.blue;
  Color textColor = Colors.white;
  double circular = 25;
  String buttonText = "Login";
  double textSize = 22;
  void Function()? function;

  LoginButtonComponent({
    super.key,
    this.width = double.infinity,
    this.height = 45,
    this.isUpper = true,
    this.backColor = Colors.blue,
    this.textColor = Colors.white,
    this.circular = 25,
    this.buttonText = "Login",
    this.textSize = 22,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backColor, borderRadius: BorderRadius.circular(circular)),
      width: width,
      height: height,
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpper ? buttonText.toUpperCase() : buttonText,
          style: TextStyle(color: textColor, fontSize: textSize),
        ),
      ),
    );
  }
}
