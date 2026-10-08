import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/app_colors.dart';

class NetworkController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  final RxBool isConnected = true.obs;
  bool _snackbarShowing = false;

  @override
  void onInit() {
    super.onInit();
    _checkInitialConnection();
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected = results.any((r) => r != ConnectivityResult.none);

    if (!connected && isConnected.value) {
      isConnected.value = false;
      _showNoConnectionSnackbar();
    } else if (connected && !isConnected.value) {
      isConnected.value = true;
      _showBackOnlineSnackbar();
    }
  }

  void _showNoConnectionSnackbar() {
    if (_snackbarShowing) {
      Get.closeCurrentSnackbar();
    }

    _snackbarShowing = true;

    Get.rawSnackbar(
      messageText: const Text(
        'No internet connection. Viewing cached content.',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
      ),
      backgroundColor: AppColors.failTextColor,
      isDismissible: true,
      duration: const Duration(seconds: 4),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.wifi_off_rounded, color: Colors.white),
    );
  }

  void _showBackOnlineSnackbar() {
    if (_snackbarShowing) {
      Get.closeCurrentSnackbar();
    }

    _snackbarShowing = false;

    Get.rawSnackbar(
      messageText: const Text(
        'Back online! Syncing latest images...',
        style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500),
      ),
      backgroundColor: AppColors.sucTextColor,
      isDismissible: true,
      duration: const Duration(seconds: 3),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      icon: const Icon(Icons.wifi_rounded, color: Colors.white),
    );
  }

  @override
  void onClose() {
    _subscription.cancel();
    super.onClose();
  }
}
