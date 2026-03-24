import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shortflix/core/utils/print_debug.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl extends NetworkInfo {
  final Connectivity connectivity;
  final InternetConnection dataChecker;

  NetworkInfoImpl({required this.connectivity, required this.dataChecker});

  @override
  Future<bool> get isConnected async {
    connectivity.onConnectivityChanged.listen((event) {
      printDebug("connectivity status => ${event.toString().split('.').last}");
    });
    final result = await connectivity.checkConnectivity();
    //with connectivity we can check our data use mobile data or wifi or ethernet or none
    if (result.contains(ConnectivityResult.bluetooth) == false &&
        result.contains(ConnectivityResult.none) == false) {
      // With DataConnectionChecker (or InternetConnectionChecker) we can check clear connection with internet
      if (await dataChecker.hasInternetAccess) {
        // device is connected to the internet
        return true;
      } else {
        // device connected to Wi-Fi or mobile data or ethernet, but no real internet
        return false;
      }
    } else {
      // device not connected to any network
      return false;
    }
  }
}
