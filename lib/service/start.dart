import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_provider.dart';
import 'home.dart';
import 'login.dart';


class Start extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider<FirebaseProvider>(create: (_) => FirebaseProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart_Refrigerator',
        home: HomePage(),
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.yellow[50],
          primaryColor: Colors.yellow[50],
          accentColor: const Color(0xffffdfdf),
        ),
        initialRoute: '/login',
        onGenerateRoute: _getRoute,
      ),
    );
  }

  Route<dynamic> _getRoute(RouteSettings settings) {
    if (settings.name != '/login') {
      return null;
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (BuildContext context) => LoginPage(),
      fullscreenDialog: true,
    );
  }
}
