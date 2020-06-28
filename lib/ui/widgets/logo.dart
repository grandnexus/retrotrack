import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({this.color, this.bgColor});

  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: bgColor,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Text(
        'Retrotrack'.toUpperCase(),
        style: GoogleFonts.pressStart2p(
          textStyle: Theme.of(context).textTheme.headline5.copyWith(
                color: color,
              ),
        ),
      ),
    );
  }
}
