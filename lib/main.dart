import 'package:fcm_config/fcm_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:machupichu/mailSignin/mailAuthenticate.dart';
import 'package:machupichu/main_page.dart';
import 'package:machupichu/services/sharedpref_helper.dart';
import 'package:machupichu/update/update.dart';
import 'services/auth.dart';

Future<void> _fcmBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  FCMConfig.instance.init(onBackgroundMessage:_fcmBackgroundHandler);
  String? hitokoto = await SharedPreferenceHelper().getUserHitokoto();
  runApp(MyApp(hitokoto == null ? null : hitokoto));
}

class MyApp extends StatefulWidget {
  String? hitokoto;
  MyApp(this.hitokoto);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 追加
      ],
      home: Stack(
        children: [
          FutureBuilder(
            future: AuthMethods().getCurrentUser(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              if (widget.hitokoto != null) {
                return MainPage(0 ,'a', 'a', 'a', 0, 0);
              } else {
                return mailAuthenticate();
              }
            },
          ),
          Updater(appStoreUrl: 'https://apps.apple.com/jp/app/id1594049158?mt=8', playStoreUrl: 'https: //play.google.com/store/apps/details?id=com.seyaken.machupichu',),
        ],
      ),
    );
  }
}
