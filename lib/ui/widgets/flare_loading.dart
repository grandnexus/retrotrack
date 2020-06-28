import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class FlareLoading extends StatelessWidget {
  const FlareLoading();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 300,
      height: 300,
      child: FlareActor(
        'assets/RetroLoading.flr',
        animation: 'loading',
      ),
    );
  }
}
