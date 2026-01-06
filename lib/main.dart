import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:l4_seance_2/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:l4_seance_2/view/home_page.dart';
import 'package:l4_seance_2/view/login_page%20copy.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'view/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProviderr()),
      ChangeNotifierProvider(create: (_) => CartProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 184, 157, 25)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return HomePage();
          }

          return SignInScreen();
        },
      ),
    );
  }
}
