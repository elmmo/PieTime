import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

// https://medium.com/flutter-community/dynamic-theming-with-flutter-78681285d85f
// https://medium.com/py-bits/turn-any-color-to-material-color-for-flutter-d8e8e037a837

enum MyThemeKeys { LIGHT, DARK, DARKER }

Color mutedRed = Color.fromARGB(255, 144, 35, 35);
Color primaryRed = Color.fromARGB(255, 244, 81, 81);
Color playButton = Color.fromARGB(255, 54, 201, 182);

class CustomColor {
  CustomColor._();
  static const Map<int, Color> red = const <int, Color>{
    // Append 0xFF to beginning of hex code
    50: const Color(0xFFF45151),
    100: const Color(0xFFF45151),
    200: const Color(0xFFF45151),
    300: const Color(0xFFF45151),
    400: const Color(0xFFF45151),
    500: const Color(0xFFF45151),
  };
}

class MyThemes {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryRed,
    brightness: Brightness.light,
    accentColor: Colors.redAccent,
    primaryColorDark: mutedRed,
    focusColor: playButton,
  );

  static final ThemeData darkTheme = ThemeData(
    primaryColor: primaryRed,
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    primaryColorDark: mutedRed,
    focusColor: playButton,
  );

  static final ThemeData darkerTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    accentColor: Colors.redAccent,
    primaryColorDark: mutedRed,
    focusColor: playButton,
  );

  static ThemeData getThemeFromKey(MyThemeKeys themeKey) {
    switch (themeKey) {
      case MyThemeKeys.LIGHT:
        return lightTheme;
      case MyThemeKeys.DARK:
        return darkTheme;
      case MyThemeKeys.DARKER:
        return darkerTheme;
      default:
        return lightTheme;
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
