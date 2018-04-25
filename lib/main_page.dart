import 'dart:async' show Future, StreamSubscription;
import 'dart:developer';
import 'dart:io'
    show
        HttpClient,
        HttpClientBasicCredentials,
        HttpClientCredentials,
        HttpStatus;

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show BaseClient, IOClient;

import 'constants.dart' as Constants;

typedef Future<bool> HttpAuthenticationCallback(
    Uri uri, String scheme, String realm);

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  String messageToDisplay = "";
  BuildContext scaffoldContext;
  bool lastConnectionStatus = false; //synonym to isConnected

  void resetDisplay() async {
    //Adding delay of 10 seconds
    await new Future.delayed(const Duration(seconds: 10));
    setState(() {
      messageToDisplay = "";
    });
  }

  HttpAuthenticationCallback _basicAuthenticationCallback(
          HttpClient client, HttpClientCredentials credentials) =>
      (Uri uri, String scheme, String realm) {
        client.addCredentials(uri, realm, credentials);
        return new Future.value(true);
      };

  BaseClient createBasicAuthenticationIoHttpClient(
      String userName, String password) {
    final credentials = new HttpClientBasicCredentials(userName, password);

    final client = new HttpClient();
    client.authenticate = _basicAuthenticationCallback(client, credentials);
    return new IOClient(client);
  }

  void triggeDoorOpenRequest() async {
    if (!lastConnectionStatus) {
      handleInternetConnectivity(lastConnectionStatus);
    } else {
      String responseBody = "";

      try {
        final http = createBasicAuthenticationIoHttpClient(
            Constants.API_AUTHORIZATION_USERNAME,
            Constants.API_AUTHORIZATION_PASSWORD);

        var response = await http.post(Constants.MAIN_URL);

        log("Successful response: " + response.body);

        if (response.statusCode == HttpStatus.OK) {
          log("Successful http call."); // Perhaps handle it somehow
          responseBody = Constants.SUCCESS_OPEN_DOOR_MSG;
        } else {
          log("Failed http call."); // Perhaps handle it somehow
          responseBody = Constants.FAILURE_OPEN_DOOR_MSG;
        }
      } catch (exception) {
        log(exception.toString());
        responseBody = Constants.FAILURE_OPEN_DOOR_MSG;
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
          title: const Text(Constants.APP_TITLE),
        ),
        body: new Builder(builder: (BuildContext context) {
          scaffoldContext = context;
          return getMainBodyWidget();
        }));
  }

  Widget getMainBodyWidget() {
//       return getCenterAlignedLayout();
    return getStackedLayout();
  }

  AspectRatio getStackedLayout() {
    return new AspectRatio(
        aspectRatio: 1.0, child: new Stack(children: getStackedChildrenList()));
  }

  Center getCenterAlignedLayout() {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: getCenteredChildrenList(),
      ),
    );
  }

  List<Widget> getCenteredChildrenList() {
    return [
      getTextWidgetForMsg(),
      new RaisedButton(
          child: const Text(Constants.OPEN_DOOR_BUTTON_LABEL,
              style: const TextStyle(fontSize: 30.0, color: Colors.blue)),
          onPressed: () => triggeDoorOpenRequest(),
          padding: new EdgeInsets.all(20.0)),
    ];
  }

  List<Widget> getStackedChildrenList() {
    return [
      new Positioned(left: 50.0, top: 40.0, child: getTextWidgetForMsg()),
      new Positioned(left: 80.0, top: 150.0, child: getCircleWidget()),
      new Positioned(
          left: 120.0,
          top: 230.0,
          child: new Center(
              child: new Container(
                  width: 120.0,
                  alignment: AlignmentDirectional.center,
                  child: new GestureDetector(
                    onLongPress: triggeDoorOpenRequest,
                    child: new Text(Constants.OPEN_DOOR_LONG_PRESS_LABEL,
                        textAlign: TextAlign.center,
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.red)),
                  ))))
    ];
  }

  Text getTextWidgetForMsg() {
    return new Text('$messageToDisplay',
        style: new TextStyle(
            fontSize: 30.0, fontStyle: FontStyle.normal, color: Colors.yellow));
  }

  Container getCircleWidget() {
    return new Container(
      child: new GestureDetector(
        onLongPress: triggeDoorOpenRequest,
      ),
      width: 200.0,
      height: 200.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        boxShadow: [
          new BoxShadow(
            offset: new Offset(0.0, 5.0),
            blurRadius: 30.0,
          )
        ],
      ),
    );
  }

  void handleInternetConnectivity(bool isConnected) {
    String displayMessage = "";
    switch (isConnected) {
      case true:
        displayMessage = Constants.SUCCESS_INTERNET_MSG;
        break;
      case false:
        displayMessage = Constants.FAILURE_INTERNET_MSG;
        break;
    }

    resetDisplay();
    createSnackBar(displayMessage);
  }

  void createSnackBar(String message) {
    final snackBar =
        new SnackBar(content: new Text(message), backgroundColor: Colors.red);

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(scaffoldContext).showSnackBar(snackBar);
  }
}
