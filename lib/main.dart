import 'dart:async';
import 'dart:io';


import 'package:ezapp/pages/elec_bill_calcul.dart';
import 'package:ezapp/utils/navigation_utils.dart';
import 'package:ezapp/widgets/page_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'managers/theme_manager.dart';

// void initFCM(String userId) async {
//   NotificationSettings settings = await FirebaseMessaging.instance
//       .requestPermission(
//         alert: true,
//         announcement: false,
//         badge: true,
//         carPlay: false,
//         criticalAlert: false,
//         provisional: false,
//         sound: true,
//       );
//
//   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//     String? token;
//     if (Platform.isAndroid) {
//       token = await FirebaseMessaging.instance.getToken();
//       print('Token Android: ' + token!);
//     }
//     if (Platform.isIOS) {
//       // token = await FirebaseMessaging.instance.getAPNSToken();
//       // print('Token iOS: ' + token!);
//     }
//     print("FCM Token: $token");
//
//     if (token != null) {
//       await FirebaseFirestore.instance.collection("users").doc(userId).update({
//         "fcm_token": token,
//       });
//     }
//   }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   NotificationService.showNotification(message);
// }

// late final List<CameraDescription> _cameras;

void main() async {
  // await dotenv.load(fileName: "assets/.env");

  WidgetsFlutterBinding.ensureInitialized();
  // _cameras = await availableCameras();
  //
  // Logger.logMap('Binding', 'INGGG');
  //
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Logger.logMap('Firebase', 'Init');
  //
  // await checksAuthState();
  //
  // await FirebaseAppCheck.instance.activate(
  //   androidProvider: AndroidProvider.debug,
  //   appleProvider: AppleProvider.debug,
  // );
  //
  // await Future.wait([
  //   NotificationService.initialize(),
  //   LocalizationManager.loadLanguage(),
  // ]);
  //
  // await BannerManager.fetchBanners();
  //
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Logger.logMap('Run', 'Run');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => NavigationUtils()),
      ],
      child: const MyApp(),
    ),
  );
}

// Future<void> checksAuthState() async {
//   User? user = await FirebaseAuth.instance.authStateChanges().first;
//   if (user == null) {
//     ///No user, build Login, ensure local customer clean
//   } else {
//     /// has user ,check whether local customer has profile
//     if (AuthManager.appUser == null) {
//       DocumentSnapshot<Map<String, dynamic>> userResponse =
//           await FirebaseFirestore.instance.doc('users/${user.uid}').get();
//       if (userResponse.exists && userResponse.data() != null) {
//         AuthManager.appUser = AppUser.fromDoc(userResponse.data());
//       } else {
//         AuthManager.appUser = null;
//       }
//     }
//     try {
//       String? token = await FirebaseMessaging.instance.getToken();
//       print('token is');
//       print(token);
//       if (token != null) {
//         await FirebaseFirestore.instance
//             .collection("users")
//             .doc(user.uid)
//             .update({"fcm_token": token});
//       }
//
//       FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
//         FirebaseFirestore.instance.collection("users").doc(user.uid).update({
//           "fcm_token": newToken,
//         });
//       });
//     } catch (e) {
//       print("Error getting FCM token: $e");
//     }
//   }
// }

// Future<String> _singleDeviceVerification() async {
//   try {
//     loading = true;
//     String deviceId = await DeviceInfoUtils.getDeviceId();
//     print('device id in main: ' + deviceId);
//
//     HttpsCallable deviceIdMatching = GeneralUtils.callable(
//       'deviceidmatching',
//     );
//
//     HttpsCallableResult deviceIdMatchingResult = await deviceIdMatching
//         .call({'deviceId': deviceId})
//         .catchError((err) {
//           hasError = true;
//           errorMessage = 'Cloud function error';
//           throw err.toString();
//         });
//
//     if (deviceIdMatchingResult.data['succeeded']) {
//       print('No device log in cur account');
//
//       UserCredential credential = await GeneralUtils.firebaseAuth
//           .signInWithCustomToken(deviceIdMatchingResult.data['message']);
//
//       if (credential.user != null) {
//         print('user is found');
//
//         DocumentReference<Map<String, dynamic>> userDoc = GeneralUtils
//             .firebaseFirestore
//             .collection('users')
//             .doc(credential.user!.uid);
//
//         await userDoc.update({
//           'last_updated': Timestamp.fromDate(DateTime.now()),
//         });
//         DocumentSnapshot<Map<String, dynamic>> userSnap = await userDoc.get();
//
//         AuthManager.appUser = AppUser.fromDoc(userSnap.data());
//
//         if (AuthManager.appUser != null) {
//           print('go home');
//           loading = false;
//           return '/home';
//         }
//       } else {
//         hasError = true;
//         errorMessage = 'User couldn\'t be found';
//       }
//     }
//
//     loading = false;
//     return '/boarding';
//   } catch (err) {
//     print('Catch error');
//     loading = false;
//     hasError = true;
//     errorMessage = err.toString();
//     return '/boarding';
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GoRouter _goRouter() => GoRouter(
    // navigatorKey: AuthManager.navKey,
    debugLogDiagnostics: true,
    redirect: (context, state) async {
      // Logger.logMap("auth", "GO ROUTER ${state.topRoute}");

      // QuerySnapshot<Map<String,dynamic>> snap6 = await FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm6",isGreaterThan: DateTime.now()).get();
      // QuerySnapshot<Map<String,dynamic>> snap12 =await  FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm12",isGreaterThan: DateTime.now()).get();
      // QuerySnapshot<Map<String,dynamic>> snap18 =await  FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm16",isGreaterThan: DateTime.now()).get();

      // List<QuerySnapshot<Map<String,dynamic>>> futures =    await Future.wait([
      //   FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm6",isGreaterThan: DateTime.now()).get(),
      //   FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm6",isGreaterThan: DateTime.now()).get(),
      //   FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").where("tm6",isGreaterThan: DateTime.now()).get()]);
      //
      //
      //
      //
      //
      //   await FirebaseFirestore.instance.collection("orders").where('user_id',isEqualTo: "self").where("status",isEqualTo: "G").get();
      //
      //   order.tm6
      //

      return null;
    },
    routes: [
      ShellRoute(
        pageBuilder: (context, state, child) {
          return CustomTransitionPage(
            key: state.pageKey,
            // barrierDismissible: false,
            barrierColor: Colors.grey,
            opaque: true,
            transitionDuration: Duration(milliseconds: 400),
            reverseTransitionDuration: Duration(milliseconds: 300),
            child: PageWrapper(child: child),
            transitionsBuilder:
                (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) {
                  const begin = Offset(1.0, 0.0); // from right
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(
                    begin: begin,
                    end: end,
                  ).chain(CurveTween(curve: curve));
                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
          );
        },

        routes: [
          GoRoute(
            path: '/elec_bill_calcul',
            builder: (context, state) => ElecBillCalcul(),
          ),

          // GoRoute(path: '/test', builder: (context, state) => TestPage()),
        ],
      ),
    ],
    initialLocation: '/elec_bill_calcul',
  );

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (BuildContext context, ThemeManager themeManager, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'EZ App',
          theme: themeManager.getTheme(),
          routerConfig: _goRouter(),
          builder: (context, child) {
            return child!;
          },
        );
      },
    );
  }
}
