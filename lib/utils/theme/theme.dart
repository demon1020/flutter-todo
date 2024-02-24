import '/core.dart';

class AppTheme {

  static ThemeData get lightTheme => _lightThemeData;
  static ThemeData get darkTheme => _darkThemeData;

  static final _lightThemeData = _getThemeData(AppColor.primary);
  static final _darkThemeData = _getThemeData(AppColor.primaryDark);

  static ThemeData _getThemeData(MaterialColor color) {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: color,
      // primarySwatch: color,
      fontFamily: GoogleFonts.nunito().fontFamily,
      appBarTheme: const AppBarTheme(
        elevation: 1,
      ),
    );
  }
}
