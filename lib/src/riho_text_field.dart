import 'package:flutter/material.dart';

/// A custom text form field widget designed for versatility and reusability across your app.
class RihoTextField extends StatelessWidget {
  /// TextEditingController for editing the text shown in the TextFormField.
  final TextEditingController controller;

  /// Validator function to provide field validation support.
  final FormFieldValidator? validator;

  /// Determines if the text field has a border on all sides.
  final bool isFullBorder;

  /// The border radius of the text field, applicable to all sides.
  final double borderRadius;

  /// Whether the label is shown as floating label when the field is in focus.
  // final bool isFloating;

  /// Specifies if the field is for password input, hiding the text.
  final bool isPassword;

  /// The title label of the text field.
  final String heading;

  /// Placeholder text that appears when the field is empty.
  final String placeholder;

  /// Style of the border when the field is enabled.
  final BorderSide borderSide;

  /// Widget to display before the TextFormField.
  final Widget? prefixWidget;

  /// Widget to display after the TextFormField.
  final Widget? suffixWidget;

  /// Maximum number of lines the text field can support.
  final int? maxLine;

  /// Style applied to text and labels within the text field.
  final TextStyle? textStyle;

  /// Style applied to text and labels within the text field.
  final double? fontSize;

  /// Character limit for the description input.
  final int? descriptionCharacterLimit;

  /// Constructor for initializing the RihoTextField widget.
  const RihoTextField(
      {super.key,
      required this.controller,
      this.validator,
      this.isFullBorder = true,
      this.borderRadius = 0,
      // this.isFloating = true,
      this.isPassword = false,
      this.heading = "Feedback",
      this.placeholder = "",
      this.borderSide = const BorderSide(width: 1, color: Color(0xffc2c2c2)),
      this.prefixWidget,
      this.suffixWidget,
      this.maxLine = 3,
      this.textStyle = const TextStyle(),
      this.fontSize = 16,
      this.descriptionCharacterLimit = 500});

  /// Builds the widget for TextField.
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: (value) => validator!(value),
        style: textStyle!,
        obscureText: isPassword,
        maxLines: maxLine,
        maxLength: descriptionCharacterLimit,
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          isDense: true,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          errorMaxLines: 3,
          hintText: placeholder,
          // labelText: heading,
          errorStyle: textStyle!
              .copyWith(color: Colors.redAccent, fontSize: fontSize! - 2),
          labelStyle: textStyle!.copyWith(fontSize: fontSize),
          hintStyle: textStyle!.copyWith(
              fontWeight: FontWeight.w300,
              fontSize: fontSize! - 2,
              color: const Color(0xffc2c2c2)),
          prefixIcon: prefixWidget,
          suffixIcon: suffixWidget,
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(width: 1, color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: const BorderSide(width: 1, color: Colors.redAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: borderSide,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: borderSide,
          ),
        ));
  }
}
