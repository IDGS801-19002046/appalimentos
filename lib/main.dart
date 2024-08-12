import 'package:alimentosapp/firebase_options.dart';
import 'package:alimentosapp/pantallas/caja.dart';
import 'package:alimentosapp/pantallas/cocina.dart';
import 'package:alimentosapp/pantallas/host.dart';
import 'package:alimentosapp/pantallas/limpieza.dart';
import 'package:alimentosapp/pantallas/login.dart';
import 'package:alimentosapp/pantallas/mesero.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Cotton cute food",
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/host': (context) => const HostPage(),
        '/clean': (context) => const CleaningPage(),
        '/waiter': (context) => const WaiterPage(),
        '/kitchen': (context) => const KitchenPage(),
        '/payment': (context) => const PaymentPage()
      },
    );
  }
}
