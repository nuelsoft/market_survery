import 'package:flutter/material.dart';
import 'package:market_survey/core/core.dart';
import 'package:market_survey/ui/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  Future<SharedPreferences> spref() async {
    Manager.prefs = await SharedPreferences.getInstance();
    Manager.collector = Manager.prefs.get('collector');
    return Manager.prefs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: spref(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.data == null) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return MaterialApp(
            title: 'Market Survey App',
            theme: ThemeData(primarySwatch: Colors.brown),
            home: AppUI(),
          );
        }
      },
    );
  }
}
