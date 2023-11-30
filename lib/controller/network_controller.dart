import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen(_updateConnactionStatus);
  }

  void _updateConnactionStatus(ConnectivityResult connectivityResult) {

      if (connectivityResult == ConnectivityResult.none) {
        Get.rawSnackbar(
          messageText: const Text(
            'Пожалуйста, подключитесь к интернету',
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13
            )
          ),
          isDismissible: false,
          duration: const Duration(days: 1),
          backgroundColor: const Color.fromARGB(228, 106, 145, 253),
          icon: const Icon(Icons.wifi_off, color: Colors.white, size: 33),
          snackStyle: SnackStyle.GROUNDED
        );
      } else {
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
      }
  }
}