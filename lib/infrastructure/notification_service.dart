import 'dart:developer' as developer;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform;
import 'package:flutter/material.dart' show TargetPlatform;
import 'package:onesignal_flutter/onesignal_flutter.dart';

// Initialize OneSignal with your App ID
const String oneSignalAppId = '37496b95-ee67-4f52-8727-de5d6e948c27';

// Initialize OneSignal SDK
Future<void> initializeOneSignal() async {
  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS)) {
    // Set log level
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    // Initialize OneSignal
    OneSignal.initialize(oneSignalAppId);
  }
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  bool _isInitialized = false;

  factory NotificationService() => _instance;

  NotificationService._internal();

  bool get _isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
  bool get _isIos => !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  Future<void> init(String? userId) async {
    print('Initializing OneSignal for user: $userId');
    if (userId == null) {
      developer.log('Cannot initialize OneSignal: userId is null',
          error: 'userId is null');
      return;
    }
    if (_isAndroid || _isIos) {
      try {
        if (_isInitialized) return;

        // Initialize OneSignal if not already initialized
        await initializeOneSignal();

        // Set the external user ID for this user
        await OneSignal.login(userId);

        // Request permission for notifications
        await OneSignal.Notifications.requestPermission(true);

        // Clear any existing notifications
        await OneSignal.Notifications.clearAll();

        // Set up notification click handler
        OneSignal.Notifications.addClickListener(_handleNotificationClick);

        // Handle notifications received while app is in foreground
        OneSignal.Notifications.addForegroundWillDisplayListener((event) {
          // Process the notification
          developer.log(
              'Notification received in foreground: ${event.notification.title}');
          // Display the notification
          event.preventDefault();
          event.notification.display();
        });

        _isInitialized = true;
        developer.log('OneSignal initialized successfully for user: $userId');
      } catch (e) {
        developer.log('Error initializing OneSignal: $e', error: e);
      }
    }
  }

  void _handleNotificationClick(OSNotificationClickEvent event) {
    final notification = event.notification;
    developer.log("Notification clicked");
    developer.log("Notification title: ${notification.title}");
    developer.log("Notification body: ${notification.body}");
    developer
        .log("Notification additional data: ${notification.additionalData}");

    // You can add navigation logic here based on the notification data
    final additionalData = notification.additionalData;
    if (additionalData != null) {
      // Example: Handle deep links or specific actions based on additional data
      if (additionalData['type'] == 'alert') {
        // Navigate to alerts screen
      } else if (additionalData['type'] == 'meter_update') {
        // Navigate to specific meter
      }
    }
  }

  Future<void> dispose() async {
    if (_isInitialized && (_isAndroid || _isIos)) {
      await OneSignal.Notifications.clearAll();
      await OneSignal.logout();
      _isInitialized = false;
    }
  }
}
