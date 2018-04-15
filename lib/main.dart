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
  String textToShow = "";

  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Press the door now!";

      //add hiding code here

    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      backgroundColor: Colors.grey,
      appBar: new AppBar(
        title: const Text("Hodor : KI labs"),
      ),

      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new Text(
                textToShow,
            style: new TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal,
                color: Colors.yellow)),
            new RaisedButton(
              child: const Text("Open The Door",
                style: const TextStyle(fontSize: 30.0, color: Colors.blue)),
                onPressed: _updateText,
            padding: new EdgeInsets.all(20.0))
          ],
        ),
      ),
    );
  }
}
