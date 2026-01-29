import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyledText extends StatelessWidget {
  const StyledText(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}

class StyledColoredText extends StatelessWidget {
  const StyledColoredText(this.text, {super.key, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodyMedium,
        color: color,
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

class StyledSmallText extends StatelessWidget {
  const StyledSmallText(this.text, {super.key, this.fontSize});

  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        textStyle: Theme.of(context).textTheme.bodySmall,
        fontStyle: FontStyle.italic,
        fontSize: fontSize ?? 12,
      ),
    );
  }
}

// for blog ownership
class StyledRichText extends StatelessWidget {
  const StyledRichText(this.text, {super.key, this.fontSize});

  final String text;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'by ',
        style: GoogleFonts.poppins(
          textStyle: Theme.of(context).textTheme.bodySmall,
          fontStyle: FontStyle.italic,
          fontSize: (fontSize ?? 14) - 2,
        ),
        children: <TextSpan>[
          TextSpan(
            text: text,
            style: GoogleFonts.poppins(
              textStyle: Theme.of(context).textTheme.bodySmall,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              fontSize: fontSize ?? 14,
            ),
          ),
        ],
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
