import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputComponent extends StatelessWidget {
  TextEditingController? con;
  String? lab;
  String hint = "";
  bool isObsecure = false;
  void Function(String)? oFS;
  void Function(String)? oC;
  TextInputType enter = TextInputType.visiblePassword;
  Icon? pre;
  IconData? suf;
  void Function()? suffunf;
  String? Function(String?)? validate;
  List<TextInputFormatter>? inputFormatters;
  String? initialValue;
  bool readOnly = false;

  InputComponent(
      {required this.con,
      required this.lab,
      this.hint = "",
      this.isObsecure = false,
      this.oFS,
      this.oC,
      this.enter = TextInputType.visiblePassword,
      required this.pre,
      this.suf,
      this.suffunf,
      this.validate,
      this.inputFormatters,
      this.initialValue,
      this.readOnly = false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validate,
      controller: con,
      obscureText: isObsecure,
      onFieldSubmitted: oFS,
      readOnly: readOnly,
      onChanged: oC,
      inputFormatters: inputFormatters,
      keyboardType: enter,
      initialValue: initialValue,
      decoration: InputDecoration(
          labelText: lab,
          hintText: hint,
          border: const OutlineInputBorder(),
          prefixIcon: pre,
          suffixIcon: IconButton(onPressed: suffunf, icon: Icon(suf))),
    );
  }
}
