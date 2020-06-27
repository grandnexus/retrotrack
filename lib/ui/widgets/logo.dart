import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        'Retrotrack'.toUpperCase(),
        style: GoogleFonts.pressStart2p(
          textStyle: Theme.of(context).textTheme.headline5,
        ),
      ),
    );
  }
}
