import 'package:flutter/material.dart';

import 'package:flare_flutter/flare_actor.dart';

class FlareDanger extends StatelessWidget {
  const FlareDanger();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 32,
      height: 32,
      child: FlareActor(
        'assets/Danger.flr',
        animation: 'spin',
      ),
    );
  }
}
