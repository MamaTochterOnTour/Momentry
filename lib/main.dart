import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:app_links/app_links.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'firebase_options.dart';
import 'pages/login_page.dart';
import 'pages/post_detail_page.dart';
import 'reiseplanung/reiseplanung_page.dart';
import 'pages/main_navigation.dart';
import 'pages/user_profil_page.dart';

import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/dark_mode_provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'l10n/s.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'providers/language_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final RouteObserver<ModalRoute<void>> routeObserver =
    RouteObserver<ModalRoute<void>>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  debugPrint('📩 Background: ${message.messageId}');
}

Future<void> initDeepLinks() async {
  final appLinks = AppLinks();

  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null) _handleDeepLink(initialUri);

  appLinks.uriLinkStream.listen((Uri uri) {
    _handleDeepLink(uri);
  });
}

void _handleDeepLink(Uri uri) {
  if (uri.pathSegments.isEmpty) return;

  final postId = uri.pathSegments.last;

  navigatorKey.currentState?.push(
    MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  await initializeDateFormatting('de_DE', null);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Permissions
  await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'Wichtige Benachrichtigungen',
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  final revenueCatApiKey = defaultTargetPlatform == TargetPlatform.iOS
      ? 'appl_gmnyKKlTRKodMPplBKxcOZakfCp'
      : 'goog_NfVXmTIFmqrGxsuyGWDsWhqxnbf';

  try {
    await Purchases.configure(PurchasesConfiguration(revenueCatApiKey));
  } catch (_) {}

  FirebaseMessaging.onMessage.listen((message) {
    final context = navigatorKey.currentContext;
    if (message.notification != null && context != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(content: Text(message.notification!.body ?? 'Neue Nachricht')),
      );
    }
  });

  // ✅ TOKEN LOGIC FIXED (overwrite always safe)
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await Purchases.logIn(user.uid);

      Future<void> saveToken(String token) async {
        await FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
      }

      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) await saveToken(token);

      FirebaseMessaging.instance.onTokenRefresh.listen(saveToken);
    }

    // ✅ PUSH NAVIGATION FIXED (no nested listener)
    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      final data = message.data;

      switch (data["type"]) {
        case "like":
        case "comment":
          final postId = data["postId"];
          if (postId == null) return;

          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
          );
          break;

        case "reply":
          final postId = data["postId"];
          if (postId == null) return;

          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
          );
          break;

        // 🔥 NEU: Kommentar-Like
        case "comment_like":
        case "reply_like":
          final postId = data["postId"];
          if (postId == null) return;

          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
          );
          break;

        case "follow":
          final followerId = data["followerId"];
          if (followerId == null) return;

          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => OtherUserProfilePage(userId: followerId),
            ),
          );
          break;
      }
    });
  });

  timeago.setLocaleMessages('de', timeago.DeMessages());
  await initDeepLinks();

  FirebaseMessaging.instance.getInitialMessage().then((message) async {
    if (message == null) return;

    final data = message.data;

    switch (data["type"]) {
      case "like":
      case "comment":
        final postId = data["postId"];
        if (postId == null) return;

        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => PostDetailPage(postId: postId)),
        );
        break;

      case "countdown_end":
        final snapshot = await FirebaseFirestore.instance
            .collection('trips')
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final tripId = snapshot.docs.first.id;

          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => TripDetailPage(tripId: tripId)),
          );
        }
        break;
    }
  });

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(darkModeProvider).value ?? false;
    final language = ref.watch(languageProvider);

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'MamaTochterOnTour',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      navigatorObservers: [routeObserver],
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale(language),
      supportedLocales: const [Locale('en'), Locale('de')],
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const MainNavigationPage(),
    );
  }
}
