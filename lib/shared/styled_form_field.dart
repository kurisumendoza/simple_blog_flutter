import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_blog_flutter/shared/styled_text.dart';
import 'package:simple_blog_flutter/theme.dart';

class StyledFormField extends StatelessWidget {
  const StyledFormField({
    super.key,
    required this.label,
    this.maxLength,
    this.validator,
    this.color,
    this.minLength = 5,
  });

  final String label;
  final int? maxLength;
  final FormFieldValidator<String>? validator;
  final Color? color;
  final int minLength;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLength: maxLength,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
      decoration: InputDecoration(
        label: StyledText(label),
        labelStyle: TextStyle(),
        counterStyle: TextStyle(color: color ?? AppColors.accent),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return '$label is required';
            }
            if (value.length < (minLength)) {
              return '$label should be at least $minLength characters';
            }

            return null;
          },
    );
  }
}
