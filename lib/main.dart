import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Screens (to be implemented)
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/inventory_screen.dart';
// Providers (to be implemented)
import 'providers/auth_provider.dart';
import 'providers/inventory_provider.dart';

void main() {
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => InventoryProvider()),
      ],
      child: MaterialApp(
        title: 'Inventory Management',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFEAF7F1),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.teal[800],
            foregroundColor: Colors.white,
            elevation: 4, // subtle shadow
            shadowColor: Colors.black26, // soft shadow color
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[800],
              foregroundColor: Colors.white,
            ),
          ),
          cardColor: Colors.white,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/inventory': (context) => const InventoryScreen(),
        },
      ),
    );
  }
}
