
import 'package:flutter/material.dart';

import 'main_page.dart';

class HodorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Hodor',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MainPage()
    );
  }
}