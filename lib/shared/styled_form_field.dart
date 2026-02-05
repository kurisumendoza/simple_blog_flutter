import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class StyledFormField extends StatelessWidget {
  StyledFormField({
    super.key,
    required this.label,
    required this.onSaved,
    this.maxLength,
    this.validator,
    this.color,
    this.isEmail = false,
    this.isPassword = false,
    this.minLength = 5,
    this.lines = 1,
    this.isUpdate = false,
    this.isOptional = false,
    this.initialValue,
  });

  final String label;
  final FormFieldSetter<String> onSaved;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final Color? color;
  final bool isPassword;
  final bool isEmail;
  final int minLength;
  final int lines;
  final bool isUpdate;
  final bool isOptional;
  final String? initialValue;

  final _emailRe = RegExp(
    r'''^(?:(?:[^<>()\[\]\\.,;:\s@"']+(?:\.[^<>()\[\]\\.,;:\s@"']+)*)|".+")@(?:\[[0-9.]+\]|(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,})$''',
  );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      maxLength: maxLength,
      minLines: lines,
      maxLines: lines,
      obscureText: isPassword,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      decoration: InputDecoration(
        label: StyledText(label),
        labelStyle: TextStyle(),
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: color ?? AppColors.accent),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.text),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.accent, width: 2),
        ),
      ),
      validator:
          validator ??
          (value) {
            if (!isOptional) {
              if (value == null || value.isEmpty) {
                return '$label is required';
              }

              if (value.length < (minLength)) {
                return '$label should be at least $minLength characters';
              }
              if (isEmail && !_emailRe.hasMatch(value)) {
                return 'Enter a valid email address';
              }
            }

            return null;
          },
      onSaved: onSaved,
    );
  }
}
