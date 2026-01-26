import 'package:shared_preferences/shared_preferences.dart';

class DataManager {
  static late SharedPreferences _prefs;

  // Uygulama ilk açıldığında main.dart içinde çağrılacak
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // --- GENEL VERİ KAYDETME METODU ---
  // Bu metod hem yerel hafızaya yazar hem de ileride Google Cloud'a veri gönderir
  static Future<void> saveData(String key, dynamic value) async {
    if (value is int) await _prefs.setInt(key, value);
    if (value is String) await _prefs.setString(key, value);
    if (value is bool) await _prefs.setBool(key, value);

    // NOT: Buraya ileride "if (isLoggedIn) syncWithGoogleCloud();" eklenecek.
  }

  // --- PARA VE LEVEL İÇİN ÖZEL GETTER/SETTER ---
  static int getGold() => _prefs.getInt('gold') ?? 0;
  static int getLevel() => _prefs.getInt('level') ?? 1;
  static String getLanguage() => _prefs.getString('lang') ?? 'en';

  static Future<void> addGold(int amount) async {
    int currentGold = getGold();
    await saveData('gold', currentGold + amount);
  }

  static Future<void> setLevel(int level) async {
    await saveData('level', level);
  }
}