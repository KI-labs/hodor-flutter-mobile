import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String successMessage = "Now, Press the Door!";
const String failureMessage = "Network Error! Try Again";
const String url = 'https://dowerless-moose-6121.dataplicity.io/open';
const String buttonLabel = "Open The Door";

void main() => runApp(new HodorApp());

class HodorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  String messageToDisplay = "";

  void resetDisplay() async {
    //Adding delay of 10 seconds
      await new Future.delayed(const Duration(seconds: 10));
      setState(() {
        messageToDisplay = "";
      });
  }

  void triggeDoorOpenRequest() async {
    final client = new http.Client();
    String responseBody = "";

    try {
      var response = await client.post(url);

      if (response.statusCode == HttpStatus.OK) {
        responseBody = successMessage;
      } else {
        log("Failed http call."); // Perhaps handle it somehow
        responseBody = failureMessage;
      }
    } catch (exception) {
      log(exception.toString());
      responseBody = failureMessage;
    }

    //Update UI state now
    setState(() {
      messageToDisplay = responseBody;
    });

    //reset so that user can clearly see change if button pressed again
    resetDisplay();

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
            new Text('$messageToDisplay',
            style: new TextStyle(fontSize: 30.0, fontStyle: FontStyle.normal,
                color: Colors.yellow)),
            new RaisedButton(
              child: const Text(buttonLabel,
                style: const TextStyle(fontSize: 30.0, color: Colors.blue)),
                onPressed: () => triggeDoorOpenRequest(),
            padding: new EdgeInsets.all(20.0))
          ],
        ),
      ),
    );
  }
}