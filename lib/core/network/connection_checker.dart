import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract interface class ConnectionChecker {
  Future<bool> get isConnected;
}

class ConnectionCheckerimpl extends ConnectionChecker {
  final InternetConnection internetConnection;

  ConnectionCheckerimpl(this.internetConnection);
  @override
  Future<bool> get isConnected async =>
      await internetConnection.hasInternetAccess;
}
