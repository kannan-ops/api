
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';

import 'firebase_options.dart';


Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(create: (context)=>ThemePr(),
      child:  MyApp()));
}

class MyApp extends StatelessWidget {
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
    runApp(MyApp());
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var themePro = Provider.of<ThemePr>(context);
    return MaterialApp(

      debugShowCheckedModeBanner: false,


      home: CRDScreen(),
    );
  }
}
class ThemePr extends ChangeNotifier {
  bool darkmode = true;

  ThemePr() {
    loadTheme();
  }

  void update({required bool dark}) async {
    darkmode = dark;
    notifyListeners();
    final Prefs = await SharedPreferences.getInstance();
    await Prefs.setBool('isDarkMode', darkmode);
  }

  void loadTheme() async {
    final Prefs = await SharedPreferences.getInstance();
    darkmode = Prefs.getBool('isDarkMode') ?? true;
    notifyListeners();
  }
}



