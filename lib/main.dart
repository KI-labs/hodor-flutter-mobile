import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new HodorApp());

class HodorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    http.read("https://www.w3.org/TR/PNG/iso_8859-1.txt").then(debugPrint);
    return new MaterialApp(
      title: 'Hodor',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: new MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  _MainPageState createState() => new _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Default placeholder text
  String textToShow = "I Like Flutter";

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(
        title: new Text("Hodor: Open Office Door"),
      ),
      body: new Center(
          child: new RaisedButton(
        onPressed: _updateText,
            padding: new EdgeInsets.only(left: 20.0, right: 20.0,
                top: 20.0, bottom: 20.0),
        child: new Text("Open The Door",
            style: new TextStyle(fontSize: 30.0, color: Colors.blue)),
      )),
    );
  }
}
