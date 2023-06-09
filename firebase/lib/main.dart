import 'package:firebase/coins/provider/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'coins/screens/homeScreen.dart';
import 'coins/screens/loginAndSignScreen.dart';
import 'coins/screens/loadingScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
          create: (_) => Auth(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (ctx, auth, _) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: auth.isAuth!
            ? const HomeScreen()
            : FutureBuilder(
                future: auth.tryAuthLogin(),
                builder: (ctx, snapShot) =>
                    (snapShot.connectionState == ConnectionState.waiting)
                        ? const LoadingScreen()
                        : LoginAndSignScreen(),
              ),
      ),
    );
  }
}
