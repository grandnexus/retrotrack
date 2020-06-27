import 'package:flutter/material.dart';

class RetroBody extends StatelessWidget {
  const RetroBody({@required this.child}) : assert(child != null);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(color: Theme.of(context).primaryColor),
            top: BorderSide(color: Theme.of(context).primaryColor),
            right: BorderSide(color: Theme.of(context).primaryColor),
            bottom: BorderSide(color: Theme.of(context).primaryColor),
          ),
        ),
        child: child,
      ),
    );
  }
}
