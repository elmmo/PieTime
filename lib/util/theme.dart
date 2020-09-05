import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
// https://medium.com/flutter-community/dynamic-theming-with-flutter-78681285d85f

enum MyThemeKeys { LIGHT, DARK }

Color mutedRed = Color.fromARGB(255, 144, 35, 35);
Color primaryRed = Color.fromARGB(255, 244, 81, 81);
Color newTaskLight = Color.fromARGB(255, 54, 201, 182);

// Source: https://gist.github.com/mikemimik/5ac2fa98fe6d132098603c1bd40263d5
class CustomColor {
  CustomColor._();

  // static const Color newTask = Color.fromRGBO(6, 214, 160, 1);
  static const Color newTaskDark = Color.fromRGBO(7, 59, 76, 1);
  static const Color timerOverlay = Color(0xFF455A64);
  static const Color remainder = Color.fromRGBO(135, 142, 136, 1);
  static const Color defaultColor = Color.fromRGBO(209, 74, 74, 1);
  static const Color colorAccent = Color(0xff329FC4);
  static const Color colorAccentDark = Color(0xff2885A4);
  static const Color colorAccentLight = Color(0xff5DCAEE);

  // Default Slice Colors
  static const Map<int, Color> red = const <int, Color>{
    50: const Color.fromRGBO(249, 214, 214, 1),
    100: const Color.fromRGBO(248, 190, 190, 1),
    200: const Color.fromRGBO(243, 142, 142, 1),
    300: const Color.fromRGBO(240, 107, 106, 1),
    400: const Color.fromRGBO(238, 93, 93, 1),
    500: const Color.fromRGBO(209, 74, 74, 1),
    600: const Color.fromRGBO(192, 69, 68, 1),
    700: const Color.fromRGBO(167, 65, 65, 1),
    800: const Color.fromRGBO(149, 58, 58, 1),
    900: const Color.fromRGBO(125, 54, 54, 1),
  };
  static const Map<int, Color> purple = const <int, Color>{
    50: const Color.fromRGBO(219, 214, 231, 1),
    100: const Color.fromRGBO(197, 189, 221, 1),
    200: const Color.fromRGBO(154, 139, 196, 1),
    300: const Color.fromRGBO(128, 107, 181, 1),
    400: const Color.fromRGBO(111, 89, 171, 1),
    500: const Color.fromRGBO(100, 76, 151, 1),
    600: const Color.fromRGBO(93, 71, 142, 1),
    700: const Color.fromRGBO(86, 70, 129, 1),
    800: const Color.fromRGBO(78, 68, 117, 1),
    900: const Color.fromRGBO(65, 58, 99, 1),
  };
  static const Map<int, Color> blue = const <int, Color>{
    50: const Color.fromRGBO(199, 224, 242, 1),
    100: const Color.fromRGBO(173, 205, 237, 1),
    200: const Color.fromRGBO(112, 167, 223, 1),
    300: const Color.fromRGBO(69, 145, 215, 1),
    400: const Color.fromRGBO(51, 130, 209, 1),
    500: const Color.fromRGBO(38, 107, 181, 1),
    600: const Color.fromRGBO(38, 98, 169, 1),
    700: const Color.fromRGBO(36, 91, 146, 1),
    800: const Color.fromRGBO(32, 81, 131, 1),
    900: const Color.fromRGBO(32, 66, 111, 1),
  };
  static const Map<int, Color> green = const <int, Color>{
    50: const Color.fromRGBO(195, 239, 239, 1),
    100: const Color.fromRGBO(173, 231, 231, 1),
    200: const Color.fromRGBO(111, 214, 214, 1),
    300: const Color.fromRGBO(62, 203, 203, 1),
    400: const Color.fromRGBO(50, 196, 196, 1),
    500: const Color.fromRGBO(37, 169, 169, 1),
    600: const Color.fromRGBO(36, 153, 152, 1),
    700: const Color.fromRGBO(35, 137, 137, 1),
    800: const Color.fromRGBO(31, 123, 123, 1),
    900: const Color.fromRGBO(33, 98, 99, 1),
  };
  static const Map<int, Color> orange = const <int, Color>{
    50: const Color.fromRGBO(247, 225, 216, 1),
    100: const Color.fromRGBO(244, 207, 195, 1),
    200: const Color.fromRGBO(235, 170, 151, 1),
    300: const Color.fromRGBO(230, 146, 117, 1),
    400: const Color.fromRGBO(227, 134, 106, 1),
    500: const Color.fromRGBO(198, 111, 85, 1),
    600: const Color.fromRGBO(181, 101, 78, 1),
    700: const Color.fromRGBO(159, 94, 74, 1),
    800: const Color.fromRGBO(142, 84, 66, 1),
    900: const Color.fromRGBO(120, 72, 60, 1),
  };
  static const Map<int, Color> pink = const <int, Color>{
    50: const Color.fromRGBO(235, 214, 224, 1),
    100: const Color.fromRGBO(228, 194, 207, 1),
    200: const Color.fromRGBO(208, 149, 170, 1),
    300: const Color.fromRGBO(196, 118, 149, 1),
    400: const Color.fromRGBO(188, 103, 134, 1),
    500: const Color.fromRGBO(162, 82, 111, 1),
    600: const Color.fromRGBO(150, 76, 102, 1),
    700: const Color.fromRGBO(132, 72, 94, 1),
    800: const Color.fromRGBO(118, 64, 84, 1),
    900: const Color.fromRGBO(99, 55, 67, 1),
  };
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: CustomColor.colorAccent,
    primaryColorLight: CustomColor.blue[400],
    brightness: Brightness.light,
    accentColor: CustomColor.colorAccent,
    primaryColorDark: mutedRed,
    textTheme: GoogleFonts.iBMPlexSansTextTheme()
        .apply(displayColor: Colors.black, bodyColor: Colors.black87)
        .copyWith(
          headline1: TextStyle(color: Colors.black),
          headline3: TextStyle(color: CustomColor.colorAccent),
          headline5: TextStyle(color: Colors.grey[900], fontSize: 20),
          bodyText1: TextStyle(color: Colors.grey[900]),
          subtitle1: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w300),
          button: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
    backgroundColor: Colors.grey[200],
    errorColor: CustomColor.red[300],
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColorLight: CustomColor.colorAccent,
    buttonColor: CustomColor.colorAccent,
    primaryColor: Colors.grey[900],
    // primarySwatch: MaterialColor(CustomColor.red[100].value, CustomColor.red),
    brightness: Brightness.dark,
    cardColor: Colors.grey[800],
    canvasColor: Color.fromRGBO(69, 69, 69, 1),
    backgroundColor: Colors.grey[850],
    primaryColorDark: CustomColor.colorAccentDark,
    textTheme: GoogleFonts.iBMPlexSansTextTheme()
        .apply(displayColor: Colors.white, bodyColor: Colors.white70)
        .copyWith(
          headline1: TextStyle(color: Colors.white),
          headline3: TextStyle(color: CustomColor.colorAccentLight),
          headline5: TextStyle(color: Colors.grey[50], fontSize: 20),
          bodyText1: TextStyle(color: Colors.grey[200]),
          bodyText2: TextStyle(color: Colors.grey[400]),
          subtitle1: TextStyle(color: Colors.white),
          subtitle2: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w300),
          button: TextStyle(
              color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w600),
        ),
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      default:
        return darkTheme;
    }
  }
}

class _CustomTheme extends InheritedWidget {
  final CustomThemeState data;

  _CustomTheme({
    this.data,
    Key key,
    @required Widget child,
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_CustomTheme oldWidget) {
    return true;
  }
}

class CustomTheme extends StatefulWidget {
  final Widget child;
  final MyThemeKeys initialThemeKey;

  const CustomTheme({
    Key key,
    this.initialThemeKey,
    @required this.child,
  }) : super(key: key);

  @override
  CustomThemeState createState() => new CustomThemeState();

  static ThemeData of(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data.theme;
  }

  static CustomThemeState instanceOf(BuildContext context) {
    _CustomTheme inherited =
        (context.dependOnInheritedWidgetOfExactType<_CustomTheme>());
    return inherited.data;
  }
}

class CustomThemeState extends State<CustomTheme> {
  ThemeData _theme;

  ThemeData get theme => _theme;

  @override
  void initState() {
    _theme = MyThemes.getThemeFromKey(widget.initialThemeKey);
    super.initState();
  }

  void changeTheme(MyThemeKeys themeKey) {
    setState(() {
      _theme = MyThemes.getThemeFromKey(themeKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _CustomTheme(
      data: this,
      child: widget.child,
    );
  }
}
