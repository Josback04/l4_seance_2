import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:l4_seance_2/auth_provider.dart';
import 'package:l4_seance_2/view/login_page%20copy.dart';
import 'package:provider/provider.dart';
import 'cart_provider.dart';
import 'view/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      home: SignInScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
