
import 'package:flutter/material.dart';
import 'package:nike/data/favorite_manager.dart';
import 'package:nike/data/repo/auth_repository.dart';
import 'package:nike/data/repo/banner_repository.dart';
import 'package:nike/theme.dart';
import 'package:nike/ui/root.dart';

void main() async{
  await FavoriteManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  authRepository.loadAuthInfo();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    // productRepository.search("لوکس").then((value) {
    //   debugPrint(value.toString());
    // },).catchError((e){
    //   debugPrint(e.toString());
    // });

    bannerRepository.getAll().then((value) {
      debugPrint(value.toString());
    },).catchError((e){
      debugPrint(e.toString());
    });
    const defaultTextStyle = TextStyle(fontFamily: "iranYekan", color: LightThemeColors.primaryTextColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        hintColor: LightThemeColors.secendaryTextColor,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: LightThemeColors.primaryTextColor.withOpacity(0.1))
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:  BorderSide(color: LightThemeColors.primaryColor)
          )
        ),
        dividerColor: Colors.grey.withOpacity(0.5),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
        foregroundColor: LightThemeColors.primaryTextColor),
        snackBarTheme: SnackBarThemeData(contentTextStyle: defaultTextStyle.apply(color: Colors.white)),
        textTheme: TextTheme(
          bodyMedium: defaultTextStyle,
          titleLarge: defaultTextStyle.copyWith(fontWeight: FontWeight.bold,fontSize: 18),   //headline6
          bodySmall: defaultTextStyle.copyWith(fontSize: 12, color: LightThemeColors.secendaryTextColor),  //caption
          titleMedium: defaultTextStyle.apply(color: LightThemeColors.secendaryTextColor, //subtitle1
          
          )
          
        ),
        colorScheme: const ColorScheme.light(
          primary: LightThemeColors.primaryColor,
          secondary: LightThemeColors.secendayColor,
          onSecondary: Colors.white
          
        ),
        useMaterial3: true,
      ),
      home: const Directionality(
        textDirection: TextDirection.rtl,
        child: RootScreen()),
    );
  }
}

