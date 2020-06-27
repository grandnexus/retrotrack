import 'package:flutter/material.dart';

class Redirect extends StatefulWidget {
  const Redirect(this.routeName, {this.removeUntilRoot = false});

  final String routeName;
  final bool removeUntilRoot;

  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.removeUntilRoot) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          widget.routeName,
          (Route<void> route) => false,
        );
      } else {
        Navigator.pushReplacementNamed(context, widget.routeName);
      }
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
