import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:online_college/providers/sign_in_provider.dart';
import 'package:provider/provider.dart';

import 'consts/route_name.dart';
import 'consts/routes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SignInProvider()),
      ],
      child: const MaterialApp(
        title: 'Online College',
        initialRoute: RoutesName.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
