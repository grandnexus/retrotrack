import 'package:flutter/material.dart';

class RetroOutlineButton extends StatelessWidget {
  const RetroOutlineButton({
    @required this.text,
    @required this.onPressed,
  });

  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      borderSide: BorderSide(
        color: Theme.of(context).primaryColorLight,
      ),
      onPressed: onPressed,
      child: Text(text.toUpperCase()),
    );
  }
}
