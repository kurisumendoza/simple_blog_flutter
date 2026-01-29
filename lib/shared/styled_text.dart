import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key, this.isSmall, this.isItalic});

  final String text;
  final bool? isSmall;
  final bool? isItalic;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: isSmall == true
            ? Theme.of(context).textTheme.bodySmall
            : Theme.of(context).textTheme.bodyMedium,
        fontStyle: isItalic == true ? FontStyle.italic : FontStyle.normal,
      ),
    );
  }
}

class StyledHeading extends StatelessWidget {
  const StyledHeading(this.text, {super.key, this.maxLines});

  final String text;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.headlineMedium,
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
