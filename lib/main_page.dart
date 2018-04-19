import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:connectivity/connectivity.dart';
import 'constants.dart';

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  String messageToDisplay = "";
  BuildContext scaffoldContext;
  bool lastConnectionStatus = false; //synonym to isConnected
  final client = new http.Client();

  void resetDisplay() async {
    //Adding delay of 10 seconds
    await new Future.delayed(const Duration(seconds: 10));
    setState(() {
      messageToDisplay = "";
    });
  }

  void triggeDoorOpenRequest() async {
    if (!lastConnectionStatus) {
      handleInternetConnectivity(lastConnectionStatus);
    } else {
      String responseBody = "";

      try {
        var response = await client.post(MAIN_URL);

        if (response.statusCode == HttpStatus.OK) {
          responseBody = SUCCESS_OPEN_DOOR_MSG;
        } else {
          log("Failed http call."); // Perhaps handle it somehow
          responseBody = FAILURE_OPEN_DOOR_MSG;
        }
      } catch (exception) {
        log(exception.toString());
        responseBody = FAILURE_OPEN_DOOR_MSG;
      }

      //Update UI state now
      setState(() {
        messageToDisplay = responseBody;
      });

      //reset so that user can clearly see change if button pressed again
      resetDisplay();
    }
  }

  final Connectivity connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();

    //// Checking Internet Connection
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        handleInternetConnectivity(
            lastConnectionStatus = (result != ConnectivityResult.none));
      });
    });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  //// Build function
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        backgroundColor: Colors.grey,
        appBar: new AppBar(
          title: const Text(APP_TITLE),
        ),
        body: new Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return getMainBodyWidget();
        }));
  }

  Widget getMainBodyWidget() {
       return  new Center(
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   new Text('$messageToDisplay',
                       style: new TextStyle(
                           fontSize: 30.0,
                           fontStyle: FontStyle.normal,
                           color: Colors.yellow)),
                   new RaisedButton(
                       child: const Text(OPEN_DOOR_BUTTON_LABEL,
                           style: const TextStyle(fontSize: 30.0, color: Colors.blue)),
                       onPressed: () => triggeDoorOpenRequest(),
                       padding: new EdgeInsets.all(20.0)),
                 ],
               ),
             );
  }

  void handleInternetConnectivity(bool isConnected) {
    String displayMessage = "";
    switch (isConnected) {
      case true:
        displayMessage = SUCCESS_INTERNET_MSG;
        break;
      case false:
        displayMessage = FAILURE_INTERNET_MSG;
        break;
    }

    resetDisplay();
    createSnackBar(displayMessage);
  }

  void createSnackBar(String message) {
    final snackBar = new SnackBar(content: new Text(message),
    backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}
