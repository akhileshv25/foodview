import 'package:flutter/material.dart';
import 'package:foodview/screens/profile_screen.dart';
import 'package:foodview/translation/language_service.dart';
import 'package:foodview/translation/trans_text.dart';

class LanguageSelectionPage extends StatefulWidget {
  const LanguageSelectionPage({super.key});

  @override
  State<LanguageSelectionPage> createState() => _LanguageSelectionPageState();
}

class _LanguageSelectionPageState extends State<LanguageSelectionPage> {
  final languageService = LanguageService();
  String? selectedLang;
  String searchQuery = "";

  final Map<String, Map<String, String>> allLanguages = {
    'en': {'name': 'English', 'native': 'English', 'flag': '🇺🇸'},
    'ta': {'name': 'Tamil', 'native': 'தமிழ்', 'flag': '🇮🇳'},
    'hi': {'name': 'Hindi', 'native': 'हिन्दी', 'flag': '🇮🇳'},
    'es': {'name': 'Spanish', 'native': 'Español', 'flag': '🇪🇸'},
    'fr': {'name': 'French', 'native': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'German', 'native': 'Deutsch', 'flag': '🇩🇪'},
    'zh-cn': {'name': 'Chinese', 'native': '中文', 'flag': '🇨🇳'},
  };

  @override
  void initState() {
    super.initState();
    selectedLang = languageService.selectedLang;
  }

  Future<void> onLanguageSelected(String langCode) async {
    await languageService.setLanguage(langCode);
    setState(() {
      selectedLang = langCode;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const ProfilePage(),
        transitionsBuilder: (_, animation, __, child) {
          const begin = Offset(-1.0, 0.0);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
          return SlideTransition(position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  List<MapEntry<String, Map<String, String>>> get filteredLanguages {
    if (searchQuery.trim().isEmpty) return allLanguages.entries.toList();
    return allLanguages.entries
        .where((entry) =>
            entry.value['name']!.toLowerCase().contains(searchQuery.toLowerCase()) ||
            entry.value['native']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const TransText('Select Language'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Language...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? Colors.grey[850] : Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredLanguages.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final entry = filteredLanguages[index];
                final code = entry.key;
                final lang = entry.value;
                final isSelected = selectedLang == code;

                return GestureDetector(
                  onTap: () => onLanguageSelected(code),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.purple[22] : (isDark ? Colors.grey[900] : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isSelected ? Colors.deepPurple : Colors.transparent, width: 2),
                    ),
                    child: Row(
                      children: [
                        Text(lang['flag']!, style: const TextStyle(fontSize: 26)),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            lang['name']!,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        Text(
                          lang['native']!,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
