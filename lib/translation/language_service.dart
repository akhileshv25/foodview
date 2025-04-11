import 'package:translator/translator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  final _translator = GoogleTranslator();
  static const _langKey = 'selected_language';
  String _selectedLang = 'en';

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _selectedLang = prefs.getString(_langKey) ?? 'en';
  }

  Future<void> setLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
    _selectedLang = langCode;
  }

  String get selectedLang => _selectedLang;

  Future<String> translate(String text) async {
    if (_selectedLang == 'en') return text;
    final translation = await _translator.translate(text, to: _selectedLang);
    return translation.text;
  }
}
