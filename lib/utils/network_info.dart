import 'package:connectivity_plus/connectivity_plus.dart';

/// For checking internet connectivity
abstract class NetworkInfoI {
  Future<bool> isConnected();
  Future<List<ConnectivityResult>> get connectivityResult;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class NetworkInfo implements NetworkInfoI {
  final Connectivity connectivity;
  NetworkInfo({required this.connectivity});

  /// Check whether internet is connected or not.
  @override
  Future<bool> isConnected() async {
    final results = await connectivity.checkConnectivity();
    return results.any((result) => result != ConnectivityResult.none);
  }

  /// Get the current connectivity status
  @override
  Future<List<ConnectivityResult>> get connectivityResult async {
    return connectivity.checkConnectivity();
  }

  /// Stream of connectivity changes
  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}
