import 'dart:io';
import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

abstract class IFirebaseMessagingService {
  Future<void> initialize();
  Future<String?> getFcmToken();
  Stream<RemoteMessage> get onMessageReceived;
}

@LazySingleton(as: IFirebaseMessagingService)
class FirebaseMessagingService implements IFirebaseMessagingService {
  final FirebaseMessaging _fcm;
  final StreamController<RemoteMessage> _messageStreamController = StreamController<RemoteMessage>.broadcast();

  FirebaseMessagingService() : _fcm = FirebaseMessaging.instance;

  @override
  Future<void> initialize() async {
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _messageStreamController.add(message);
    });

    _fcm.onTokenRefresh.listen((newToken) {
      _saveTokenToFirestore(newToken);
    });

    // Listen to authentication state changes to dynamically save token under the active user
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      final token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
    });
  }

  @override
  Future<String?> getFcmToken() async {
    try {
      final token = await _fcm.getToken();
      if (token != null) {
        _saveTokenToFirestore(token);
      }
      return token;
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveTokenToFirestore(String token) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid ?? 'anonymous_guest';
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tokens')
          .doc(token)
          .set({
        'token': token,
        'platform': Platform.operatingSystem,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
      print('[INFO] FCM Token successfully saved to Firestore for user: $userId');
    } catch (e) {
      print('[WARNING] Failed to save FCM Token to Firestore: $e');
    }
  }

  @override
  Stream<RemoteMessage> get onMessageReceived => _messageStreamController.stream;
}
