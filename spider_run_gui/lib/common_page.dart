import 'package:flutter/material.dart';

class CommonPage extends StatelessWidget {
  final Widget title;
  final Widget body;
  const CommonPage(this.title, this.body, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title,
      ),
      body: body,
    );
  }
}
