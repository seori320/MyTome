import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  const UserPreferences({
    required this.fontSize,
    required this.useDarkTheme,
  });

  final double fontSize;
  final bool useDarkTheme;

  static const _fontSizeKey = 'reader_font_size';
  static const _darkThemeKey = 'reader_use_dark_theme';

  factory UserPreferences.defaults() {
    return const UserPreferences(fontSize: 18, useDarkTheme: false);
  }

  factory UserPreferences.fromPrefs(SharedPreferences prefs) {
    return UserPreferences(
      fontSize: prefs.getDouble(_fontSizeKey) ?? 18,
      useDarkTheme: prefs.getBool(_darkThemeKey) ?? false,
    );
  }

  UserPreferences copyWith({
    double? fontSize,
    bool? useDarkTheme,
  }) {
    return UserPreferences(
      fontSize: fontSize ?? this.fontSize,
      useDarkTheme: useDarkTheme ?? this.useDarkTheme,
    );
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, fontSize);
    await prefs.setBool(_darkThemeKey, useDarkTheme);
  }

  static Future<UserPreferences> load() async {
    final prefs = await SharedPreferences.getInstance();
    return UserPreferences.fromPrefs(prefs);
  }
}
