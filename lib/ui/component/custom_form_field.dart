import 'package:flutter/material.dart';

typedef MyValidator = String? Function(String?)?;
class CustomFormField extends StatelessWidget {
 String label;
 IconButton? suffix;
 bool isPassword;
 TextEditingController controller;
 TextInputType textInputType;
 int lines;
 MyValidator validator;
  CustomFormField({required this.label,this.isPassword = false,required this.controller,
    this.suffix,this.textInputType = TextInputType.text,this.lines = 1,required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: suffix,
      ),
      obscureText: isPassword,
      controller: controller,
      keyboardType: textInputType,
      minLines: lines,
      maxLines: lines,
      validator: validator,
    );
  }
}
