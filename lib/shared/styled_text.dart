import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.fontStyle,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final FontStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        color: color,
        fontSize: fontSize,
        fontStyle: fontStyle,
      ),
    );
  }
}

// for blog body preview in blog card
class StyledPreviewText extends StatelessWidget {
  const StyledPreviewText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: 4,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(
    this.text, {
    super.key,
    this.color,
    this.fontSize,
    this.maxLines,
  });

  final String text;
  final Color? color;
  final double? fontSize;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.headlineMedium,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}

class StyledTitle extends StatelessWidget {
  const StyledTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }
}
