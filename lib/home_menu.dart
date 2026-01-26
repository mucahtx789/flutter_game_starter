import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'localization_service.dart';
import 'data_manager.dart'; // Yeni veri yöneticimiz

class HomeMenu extends StatefulWidget {
  const HomeMenu({super.key});

  @override
  State<HomeMenu> createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {
  // Şimdilik bağlantı durumunu simüle ediyoruz
  bool isGoogleConnected = false;

  void _updateLanguage(String langCode) async {
    await LocalizationService.changeLanguage(langCode);
    if (mounted) setState(() {});
  }

  // Google Play Games Giriş/Çıkış Simülasyonu
  void _toggleGooglePlay() {
    setState(() {
      isGoogleConnected = !isGoogleConnected;
    });
    // İleride buraya gerçek AuthService.signIn() gelecek
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF000000)],
          ),
        ),
        child: Stack( // Üst üste binen öğeler için Stack kullanıyoruz
          children: [
            // 1. Üst Bilgi Barı (Para ve Seviye)
            Positioned(
              top: 50.h,
              left: 20.w,
              right: 20.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _statusChip("LVL: ${DataManager.getLevel()}", Icons.star, Colors.blueAccent),
                  _statusChip("${DataManager.getGold()}", Icons.monetization_on, Colors.amber),
                ],
              ),
            ),

            // 2. Ana Menü Butonları
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "NEBULA QUEST",
                    style: TextStyle(
                      fontSize: 36.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      shadows: [Shadow(color: Colors.orangeAccent, blurRadius: 15.r)],
                    ),
                  ),
                  SizedBox(height: 50.h),

                  _menuButton(LocalizationService.get('play'), Icons.play_arrow_rounded, () {
                    // Test amaçlı: Her girişte 10 altın ekle
                    DataManager.addGold(10).then((_) => setState(() {}));
                  }),

                  _menuButton(LocalizationService.get('settings'), Icons.settings_rounded, () {}),

                  _menuButton(LocalizationService.get('language'), Icons.language_rounded, _showLanguageDialog),

                  SizedBox(height: 30.h),

                  // 3. Google Play Games Bağlantı Paneli
                  _googlePlayButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Seviye ve Altın Gösterge Çipi
  Widget _statusChip(String text, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18.sp),
          SizedBox(width: 8.w),
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp)),
        ],
      ),
    );
  }

  // Google Play Games Butonu (Görsel Altyapı)
  Widget _googlePlayButton() {
    return InkWell(
      onTap: _toggleGooglePlay,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isGoogleConnected ? Colors.green.withOpacity(0.2) : Colors.white10,
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(color: isGoogleConnected ? Colors.green : Colors.white24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isGoogleConnected ? Icons.check_circle : Icons.sports_esports,
              color: isGoogleConnected ? Colors.green : Colors.white,
              size: 20.sp,
            ),
            SizedBox(width: 10.w),
            Text(
              isGoogleConnected ? "Connected: Player1" : "Connect Play Games",
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuButton(String text, IconData icon, VoidCallback onTap) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orangeAccent,
          foregroundColor: Colors.black,
          minimumSize: Size(240.w, 55.h),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
          elevation: 5,
        ),
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 22.sp),
            SizedBox(width: 10.w),
            Text(text, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A237E),
        title: Text(LocalizationService.get('language'), style: const TextStyle(color: Colors.white)),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: LocalizationService.supportedLanguages.map((lang) => ListTile(
              title: Text(lang.toUpperCase(), style: const TextStyle(color: Colors.white)),
              onTap: () { _updateLanguage(lang); Navigator.pop(context); },
            )).toList(),
          ),
        ),
      ),
    );
  }
}