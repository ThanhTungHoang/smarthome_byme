// ignore_for_file: must_be_immutable

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextFieldAuth extends StatefulWidget {
  final TextEditingController contronller;
  final bool nextAction;
  late bool obscureText;
  final bool showIConHide;
  final Color kPrimaryColor;
  final Color kPrimaryLightColor;
  final String hintText;
  final double defaultPadding;
  final Icon iconLeft;
  final String textValidator;
  final bool typeEmail;
  final num? lengthValidation;
  TextFieldAuth({
    Key? key,
    required this.contronller,
    required this.nextAction,
    required this.obscureText,
    required this.kPrimaryColor,
    required this.hintText,
    required this.defaultPadding,
    required this.kPrimaryLightColor,
    required this.iconLeft,
    required this.typeEmail,
    required this.textValidator,
    required this.showIConHide,
    this.lengthValidation = 6,
  }) : super(key: key);

  @override
  State<TextFieldAuth> createState() => _TextFieldAuthState();
}

class _TextFieldAuthState extends State<TextFieldAuth> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.contronller,
      textInputAction:
          widget.nextAction ? TextInputAction.done : TextInputAction.next,
      obscureText: widget.obscureText,
      cursorColor: widget.kPrimaryColor,
      decoration: InputDecoration(
        hintText: widget.hintText,
        prefixIcon: Padding(
          padding: EdgeInsets.all(widget.defaultPadding),
          child: widget.iconLeft,
        ),
        suffixIcon: widget.showIConHide
            ? IconButton(
                icon: Icon(
                  widget.obscureText ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    widget.obscureText = !widget.obscureText;
                  });
                },
              )
            : null,
        filled: true,
        fillColor: widget.kPrimaryLightColor,
        iconColor: widget.kPrimaryColor,
        prefixIconColor: widget.kPrimaryColor,
        contentPadding: EdgeInsets.symmetric(
            horizontal: widget.defaultPadding, vertical: widget.defaultPadding),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          borderSide: BorderSide.none,
        ),
        errorStyle: const TextStyle(color: Colors.red, fontSize: 13),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        return widget.typeEmail
            ? value != null && !EmailValidator.validate(value)
                ? widget.textValidator
                : null
            : value != null && value.length < widget.lengthValidation!
                ? widget.textValidator
                : null;
      },
    );
  }
}
