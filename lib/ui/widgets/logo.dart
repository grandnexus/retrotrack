import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class Logo extends StatelessWidget {
  const Logo({
    this.color,
    this.bgColor,
    this.showImage = false,
  });

  final Color color;
  final Color bgColor;
  final bool showImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      color: bgColor,
      padding: const EdgeInsets.all(16),
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          if (showImage) ...<Widget>[
            Container(
              width: 125.0,
              child: Image.asset('assets/logo.png'),
            ),
            const SizedBox(height: 10.0),
          ],
          Text(
            'Retrotrack'.toUpperCase(),
            style: GoogleFonts.pressStart2p(
              textStyle: Theme.of(context).textTheme.headline5.copyWith(
                    color: color,
                  ),
            ),
          )
        ],
      ),
    );
  }
}
