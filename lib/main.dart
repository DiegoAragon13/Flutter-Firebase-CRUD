import 'package:marmotaphilp/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await signInAnonymously();//Auth anonima para falsear mis reglas sin modificarlas

  runApp(MyApp());
}

//iniciar sesión anónima y verificar en consola xd
Future<void> signInAnonymously() async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
    print('Usuario autenticado anonimamente: ${userCredential.user?.uid}');
  } catch (e) {
    print('Error al autenticar: $e');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme).copyWith(
          titleLarge: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.titleLarge,
            fontSize: 32,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          bodyLarge: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          bodyMedium: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.bodyLarge,
            fontSize: 18,
            color: Colors.black87,
            fontStyle: FontStyle.italic,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.yellow.shade300,
          brightness: Brightness.light,
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: GoogleFonts.lato(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            textStyle: GoogleFonts.lato(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
