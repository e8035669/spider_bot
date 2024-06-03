import 'package:flutter/material.dart';

class CommonPage extends StatelessWidget {
  final Widget title;
  final Widget body;
  final List<Widget>? actions;
  const CommonPage(this.title, this.body, {super.key, this.actions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
        actions: actions,
      ),
      body: body,
    );
  }
}
