import 'dart:async' show Future, StreamSubscription;

import 'package:async_loader/async_loader.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hodor_mobile/network.dart';

import 'constants.dart' as Constants;

final GlobalKey<AsyncLoaderState> _asyncLoaderState =
    new GlobalKey<AsyncLoaderState>();

class MainPage extends StatefulWidget {
  MainPage({Key key}) : super(key: key);

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  String messageToDisplay = "";
  BuildContext scaffoldContext;
  bool lastConnectionStatus = false; //synonym to isConnected
  static bool didAppJustStart = false;

  //TODO reset is not working
  void resetDisplay() async {
    //Adding delay of 10 seconds
    await new Future.delayed(const Duration(seconds: 5));
    setState(() {
      messageToDisplay = "";
    });
  }

  AsyncLoader getAsyncLoader() {
    return new AsyncLoader(
      key: _asyncLoaderState,
      initState: () async => triggeDoorOpenRequest(),
      renderLoad: () => new CircularProgressIndicator(),
      renderError: ([error]) =>
          getTextWidgetForMsg(Constants.FAILURE_OPEN_DOOR_MSG),
      renderSuccess: ({data}) => getTextWidgetForMsg(data),
    );
  }

  void onPressedAction() {
    _asyncLoaderState.currentState.reloadState();
  }

  Future<String> triggeDoorOpenRequest() async {
    if (!didAppJustStart) {
      if (!lastConnectionStatus) {
        handleInternetConnectivity(lastConnectionStatus);
      } else {
        return new NetworkLayer().triggerPostAndGetResponse();
      }
    }

    didAppJustStart = false;
    return new Future<String>(() => "");
  }

  final Connectivity connectivity = new Connectivity();
  StreamSubscription<ConnectivityResult> connectivitySubscription;

  @override
  void initState() {
    super.initState();
    didAppJustStart = true;

    //// Checking Internet Connection
    connectivitySubscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        lastConnectionStatus = (result != ConnectivityResult.none);
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
    return getStackedLayout();
  }

  AspectRatio getStackedLayout() {
    return new AspectRatio(
        aspectRatio: 1.0, child: new Stack(children: getStackedChildrenList()));
  }

  List<Widget> getStackedChildrenList() {
    return [
      new Positioned(left: 80.0, top: 40.0, child: getAsyncLoader()),
      new Positioned(left: 80.0, top: 150.0, child: getCircleWidget()),
      new Positioned(
          left: 120.0,
          top: 230.0,
          child: new Center(
              child: new Container(
                  width: 120.0,
                  alignment: AlignmentDirectional.center,
                  child: new GestureDetector(
                    onLongPress: onPressedAction,
                    child: new Text(Constants.OPEN_DOOR_LONG_PRESS_LABEL,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            fontSize: 20.0,
                            color: Colors.red,
                            fontWeight: FontWeight.bold)),
                  ))))
    ];
  }

  Widget getTextWidgetForMsg(String data) {
    messageToDisplay = data;
    resetDisplay();
    return new Center(
        child: new Text('$messageToDisplay',
            softWrap: true,
            textAlign: TextAlign.left,
            style: new TextStyle(
                fontSize: 25.0,
                fontStyle: FontStyle.normal,
                color: Colors.yellow,
                fontWeight: FontWeight.bold)));
  }

  Container getCircleWidget() {
    return new Container(
      child: new GestureDetector(
        onLongPress: onPressedAction,
      ),
      width: 200.0,
      height: 200.0,
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue,
        boxShadow: [
          new BoxShadow(
            offset: new Offset(0.0, 5.0),
            blurRadius: 20.0,
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
