import 'dart:async';
import 'dart:developer';
import 'dart:io'
    show
        HttpClient,
        HttpClientBasicCredentials,
        HttpClientCredentials,
        HttpStatus;

import 'package:http/http.dart' show BaseClient, IOClient;

import 'constants.dart' as Constants;
import 'network_config.dart' as NetworkConfig;

typedef Future<bool> HttpAuthenticationCallback(
    Uri uri, String scheme, String realm);

class NetworkLayer {
  HttpAuthenticationCallback _basicAuthenticationCallback(
          HttpClient client, HttpClientCredentials credentials) =>
      (Uri uri, String scheme, String realm) {
        client.addCredentials(uri, realm, credentials);
        return new Future.value(true);
      };

  BaseClient _createBasicAuthenticationIoHttpClient(
      String userName, String password) {
    final credentials = new HttpClientBasicCredentials(userName, password);

    final client = new HttpClient();
    client.authenticate = _basicAuthenticationCallback(client, credentials);
    return new IOClient(client);
  }

  BaseClient _getHttpClient() {
    return _createBasicAuthenticationIoHttpClient(
        NetworkConfig.API_AUTHORIZATION_USERNAME,
        NetworkConfig.API_AUTHORIZATION_PASSWORD);
  }

  Future<String> triggerPostAndGetResponse() async {
    String responseBody = "";
    try {
      var response = await _getHttpClient().post(NetworkConfig.MAIN_URL);

//    log("Successful response: " + response.body);

      if (response.statusCode == HttpStatus.OK) {
//      log("Successful http call."); // Perhaps handle it somehow
        responseBody = Constants.SUCCESS_OPEN_DOOR_MSG;
      } else {
//      log("Failed http call."); // Perhaps handle it somehow
        responseBody = Constants.FAILURE_OPEN_DOOR_MSG;
      }
    } catch (exception) {
      log(exception.toString());
      responseBody = Constants.FAILURE_OPEN_DOOR_MSG;
    }

    return new Future<String>(() => responseBody);
  }
}
