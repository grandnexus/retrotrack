import 'package:flutter/material.dart';

class RetroBackButton extends StatelessWidget {
  const RetroBackButton({
    @required this.text,
    @required this.onPressed,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2.0,
      ),
      padding: const EdgeInsets.all(0.0),
      onPressed: onPressed,
      child: Icon(
        Icons.arrow_back,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
