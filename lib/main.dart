import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_blog_mobile/model/PostProvider.dart';
import 'package:personal_blog_mobile/page/home/HomePage.dart';
import 'package:provider/provider.dart';

void main() {
  configLoading();
  runApp(MyApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.ring
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (c) => PostProvider(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(237, 237, 237, 1),
        ),
        onGenerateRoute: (settings) {
          return MaterialWithModalsPageRoute(
              settings: settings, builder: (context) => Container());
        },
        routes: {
          "/": (c) => CupertinoScaffold(
                body: HomePage(),
              )
        },
        builder: EasyLoading.init(),
      ),
    );
  }
}
