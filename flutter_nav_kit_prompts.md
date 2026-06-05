# flutter_nav_kit — Yapay Zeka Geliştirme Prompt'ları

Her prompt bağımsız çalışır. Sırayla ver, her promptun çıktısını bir sonrakine context olarak ekle.

---

## FAZ 1 — Core Modeller + go_router + SolidBar

### Prompt 1.1 — Proje Kurulumu ve pubspec.yaml

```
Flutter paketi geliştiriyorum. Adı `flutter_nav_kit`.

Aşağıdaki yapıya göre tüm dosyaları oluştur:

flutter_nav_kit/
├── lib/
│   ├── src/
│   │   ├── core/
│   │   │   ├── nav_item.dart
│   │   │   ├── nav_badge.dart
│   │   │   ├── nav_style.dart
│   │   │   └── nav_breakpoints.dart
│   │   ├── widgets/
│   │   │   ├── nav_kit_scaffold.dart
│   │   │   ├── bottom_nav_bar.dart
│   │   │   ├── nav_rail.dart
│   │   │   ├── nav_drawer.dart
│   │   │   ├── nav_badge_widget.dart
│   │   │   └── nav_item_widget.dart
│   │   ├── styles/
│   │   │   ├── solid_bar_style.dart
│   │   │   ├── floating_pill_style.dart
│   │   │   └── glass_style.dart
│   │   └── utils/
│   │       ├── platform_detector.dart
│   │       └── scroll_controller_mixin.dart
│   └── flutter_nav_kit.dart
├── example/
│   └── lib/
│       ├── main.dart
│       └── router.dart
├── test/
├── CHANGELOG.md
├── LICENSE
└── pubspec.yaml

pubspec.yaml içeriği:
- name: flutter_nav_kit
- description: go_router-native, adaptive bottom navigation kit for Flutter. Supports iOS 26 Liquid Glass, Material 3, animated badges, and automatic phone/tablet/desktop layout.
- version: 0.1.0
- sdk: '>=3.4.0 <4.0.0'
- flutter: '>=3.22.0'
- Tek bağımlılık: go_router (>=13.0.0 <20.0.0)
- dev_dependencies: flutter_test, flutter_lints ^5.0.0

Şimdi sadece pubspec.yaml ve boş dosyaları (içinde sadece // TODO yorum satırı olan) oluştur. Kod yazmaya başlama.
```

---

### Prompt 1.2 — NavItem ve NavBadge Modelleri

```
flutter_nav_kit paketi için core model dosyalarını yaz.

**lib/src/core/nav_badge.dart** içeriği:

NavBadge sınıfı:
- int? count (null ise nokta badge)
- Color? color (null ise varsayılan kırmızı)
- bool animated (varsayılan: true)

Named constructor'lar:
- NavBadge.dot({Color? color, bool animated = true})
- NavBadge.count(int count, {Color? color, bool animated = true})

Kurallar:
- count > 99 ise "99+" string'i döndüren getter: String get displayText
- count null ise nokta badge olduğunu döndüren getter: bool get isDot
- const constructor kullan
- copyWith metodu ekle
- == ve hashCode override et

---

**lib/src/core/nav_item.dart** içeriği:

NavItem sınıfı:
- String label (zorunlu)
- IconData icon (zorunlu)
- IconData? activeIcon (null ise icon kullanılır)
- NavBadge? badge (null ise badge yok)
- String? tooltip (null ise label kullanılır — accessibility için)
- Color? activeColor

Kurallar:
- const constructor kullan
- copyWith metodu ekle
- == ve hashCode override et
- effectiveTooltip getter: tooltip ?? label döndürür
- effectiveActiveIcon getter: activeIcon ?? icon döndürür

Tüm public API'lar için /// dokümantasyon yorumu yaz.
Dart 3 syntax kullan.
```

---

### Prompt 1.3 — NavStyle, NavBreakpoints, NavKitTheme

```
flutter_nav_kit paketi için stil ve tema dosyalarını yaz.

**lib/src/core/nav_style.dart** içeriği:

NavStyle enum:
- solidBar  // Material 3 uyumlu solid bar
- floatingPill  // Yüksekte duran yuvarlak pill
- glass  // iOS 26 Liquid Glass / frosted glass

NavKitTheme sınıfı (aynı dosyada):
Parametreler:
- Color? backgroundColor
- Color? selectedItemColor
- Color? unselectedItemColor
- Color? indicatorColor
- double? elevation (varsayılan: 4)
- double? borderRadius (varsayılan: 16, floatingPill için)
- EdgeInsets? margin
- TextStyle? labelStyle
- double? iconSize (varsayılan: 24)
- double? height (varsayılan: 64)

Metodlar:
- const constructor
- copyWith
- lerp(NavKitTheme a, NavKitTheme b, double t) — animasyon için
- NavKitTheme.fromColorScheme(ColorScheme scheme) factory constructor
- == ve hashCode override

---

**lib/src/core/nav_breakpoints.dart** içeriği:

NavBreakpoints sınıfı:
- double rail (varsayılan: 600) — NavigationRail geçiş genişliği
- double drawer (varsayılan: 1200) — NavigationDrawer geçiş genişliği

Metodlar:
- const constructor
- copyWith
- NavLayout currentLayout(double width) — NavLayout enum döndürür

NavLayout enum (aynı dosyada):
- bottomBar
- rail
- drawer

Tüm public API'lar için /// dokümantasyon yorumu yaz.
```

---

### Prompt 1.4 — NavBadgeWidget

```
flutter_nav_kit paketi için animated badge widget'ı yaz.

**lib/src/widgets/nav_badge_widget.dart** içeriği:

NavBadgeWidget StatefulWidget:
- NavBadge badge (zorunlu)
- Widget child (zorunlu) — badge'in üstüne yerleştirilecek widget

Davranış:
- badge.isDot true ise: küçük dolu daire (çap: 8px), sağ üst köşede
- badge.isDot false ise: sayıyı gösteren pill şeklinde kapsayıcı
  - count <= 9: daire (24x24px)
  - count > 9: pill (min genişlik 24px, yükseklik 18px, padding: horizontal 4px)
  - badge.displayText içeriğini göster ("99+" dahil)
- badge.color null ise Colors.red kullan
- badge.animated true ise:
  - AnimationController ile pulse efekti (scale 1.0 → 1.2 → 1.0, 1.5 saniye, tekrarlayan)
  - Yeni badge geldiğinde (count değiştiğinde) bounce animasyonu (scale 0.5 → 1.2 → 1.0)
- Stack kullanarak child üstüne badge'i yerleştir
- Positioned ile sağ üst köşeye sabitle

Erişilebilirlik:
- Semantics ile badge değerini açıkla: "X bildirim" veya "yeni bildirim"

Dart 3, flutter_lints uyumlu kod yaz.
```

---

### Prompt 1.5 — NavItemWidget

```
flutter_nav_kit paketi için tek navigation item widget'ı yaz.

**lib/src/widgets/nav_item_widget.dart** içeriği:

NavItemWidget StatelessWidget:
Parametreler:
- NavItem item (zorunlu)
- bool isSelected (zorunlu)
- VoidCallback onTap (zorunlu)
- NavKitTheme theme (zorunlu)
- bool showLabel (varsayılan: true)

Davranış:
- InkWell veya GestureDetector ile dokunma algıla
- isSelected true ise item.effectiveActiveIcon, false ise item.icon göster
- isSelected true ise theme.selectedItemColor, false ise theme.unselectedItemColor
- item.badge != null ise ikonun üstüne NavBadgeWidget sar
- showLabel true ise ikonun altında item.label göster
- Minimum dokunma alanı 48x48px (GestureDetector veya InkWell boyutu)
- item.activeColor varsa selectedItemColor yerine onu kullan

Animasyon:
- Tab seçildiğinde (isSelected değiştiğinde) ikon scale animasyonu: 0.8 → 1.1 → 1.0 (150ms)
- AnimatedDefaultTextStyle ile label renk geçişi

Erişilebilirlik:
- Semantics(
    label: item.effectiveTooltip,
    button: true,
    selected: isSelected,
  )

Dart 3, const constructor kullan, flutter_lints uyumlu.
```

---

### Prompt 1.6 — SolidBar Stili

```
flutter_nav_kit paketi için solid bar stil widget'ı yaz.

**lib/src/styles/solid_bar_style.dart** içeriği:

SolidBarStyle StatelessWidget:
Parametreler:
- List<NavItem> items (zorunlu)
- int selectedIndex (zorunlu)
- ValueChanged<int> onItemTapped (zorunlu)
- NavKitTheme theme (zorunlu)

Davranış:
- Flutter'ın Material 3 NavigationBar widget'ını KULLANMA
- Sıfırdan yaz: Container + Row + NavItemWidget'lardan oluşsun
- Container özellikleri:
  - height: theme.height ?? 64
  - color: theme.backgroundColor (null ise Theme.of(context).colorScheme.surface)
  - Üstte ince ayırıcı çizgi: BorderSide(color: theme, width: 0.5)
- Row içinde items.length kadar Expanded widget
- Her Expanded içinde NavItemWidget
- Seçili item'ın altında animasyonlu gösterge çizgisi:
  - AnimatedPositioned veya AnimatedContainer ile kayma efekti
  - Genişlik: 24px, yükseklik: 3px, borderRadius: 2px
  - Renk: theme.indicatorColor
- SafeArea ile sarılmış (bottom: true)

Renk mantığı:
- backgroundColor null ise: Theme.of(context).colorScheme.surface
- selectedItemColor null ise: Theme.of(context).colorScheme.primary
- unselectedItemColor null ise: Theme.of(context).colorScheme.onSurfaceVariant

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 1.7 — Ana NavKitScaffold Widget'ı (Faz 1 — Sadece SolidBar)

```
flutter_nav_kit paketi için ana scaffold widget'ını yaz. Bu Faz 1 versiyonudur, sadece solidBar stili ve adaptive layout (bottomBar + rail) çalışacak.

**lib/src/widgets/nav_kit_scaffold.dart** içeriği:

NavKitScaffold StatelessWidget:
Parametreler:
- StatefulNavigationShell navigationShell (zorunlu) — go_router'dan
- List<NavItem> items (zorunlu, min 2 max 5 assert)
- NavStyle style (varsayılan: NavStyle.solidBar)
- bool adaptive (varsayılan: true)
- NavBreakpoints breakpoints (varsayılan: NavBreakpoints())
- NavKitTheme? theme
- bool hideOnScroll (varsayılan: false) — Faz 1'de henüz implemente etme, sadece parametreyi al
- bool handleBackButton (varsayılan: true)
- int initialTabIndex (varsayılan: 0)
- ValueChanged<int>? onTabChanged

Davranış:

1. _goBranch(int index):
   - navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex)
   - onTabChanged?.call(index)

2. LayoutBuilder ile adaptive:
   - adaptive false ise: her zaman _buildBottomBar
   - adaptive true ise:
     - constraints.maxWidth >= breakpoints.drawer → _buildDrawerLayout (Faz 1'de stub, sadece _buildRailLayout döndür)
     - constraints.maxWidth >= breakpoints.rail → _buildRailLayout
     - diğer → _buildBottomBar

3. _buildBottomBar:
   - Scaffold(
       body: navigationShell,
       bottomNavigationBar: SolidBarStyle(...) — style ne olursa olsun Faz 1'de hep SolidBar
     )

4. _buildRailLayout:
   - Scaffold(
       body: Row(
         children: [
           NavigationRail(
             selectedIndex: navigationShell.currentIndex,
             onDestinationSelected: _goBranch,
             destinations: items.map((item) => NavigationRailDestination(
               icon: Icon(item.icon),
               selectedIcon: Icon(item.effectiveActiveIcon),
               label: Text(item.label),
             )).toList(),
             labelType: NavigationRailLabelType.all,
           ),
           VerticalDivider(thickness: 1, width: 1),
           Expanded(child: navigationShell),
         ],
       ),
     )

5. handleBackButton true ise PopScope ile sar:
   - canPop: navigationShell.currentIndex == 0
   - onPopInvokedWithResult: index != 0 ise _goBranch(0)

Assert:
- assert(items.length >= 2 && items.length <= 5, 'NavItem sayısı 2 ile 5 arasında olmalıdır')

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 1.8 — Barrel Export ve Example App

```
flutter_nav_kit paketi için barrel export ve example app yaz.

**lib/flutter_nav_kit.dart** içeriği:
Aşağıdakileri export et:
- src/core/nav_item.dart
- src/core/nav_badge.dart
- src/core/nav_style.dart (NavStyle, NavKitTheme)
- src/core/nav_breakpoints.dart (NavBreakpoints, NavLayout)
- src/widgets/nav_kit_scaffold.dart
- src/widgets/nav_badge_widget.dart

---

**example/lib/router.dart** içeriği:
go_router ile 4 tab:
- /home → HomePage
- /explore → ExplorePage
- /notifications → NotificationsPage (badge ile)
- /profile → ProfilePage

StatefulShellRoute.indexedStack kullan.
NavKitScaffold ile:
- style: NavStyle.solidBar
- adaptive: true
- items: 4 NavItem (Notifications item'ında NavBadge.count(3, animated: true))

---

**example/lib/main.dart** içeriği:
MaterialApp.router ile router'ı bağla.
ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple))
Hem light hem dark theme ekle.

---

Her sayfa için basit Scaffold (AppBar + Center(child: Text('...'))) yaz.

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 1.9 — Faz 1 Testleri

```
flutter_nav_kit paketi için Faz 1 birim ve widget testleri yaz.

**test/nav_item_test.dart**:
- NavItem const constructor testi
- copyWith testi
- effectiveTooltip: tooltip null ise label döndürmeli
- effectiveActiveIcon: activeIcon null ise icon döndürmeli
- == operatörü testi

**test/nav_badge_test.dart**:
- NavBadge.dot() testi: isDot true, count null
- NavBadge.count(5) testi: isDot false, displayText "5"
- NavBadge.count(100) testi: displayText "99+"
- NavBadge.count(99) testi: displayText "99"
- copyWith testi

**test/nav_breakpoints_test.dart**:
- currentLayout(400) → NavLayout.bottomBar
- currentLayout(800) → NavLayout.rail
- currentLayout(1300) → NavLayout.drawer
- Özel breakpoint testi

**test/nav_kit_scaffold_test.dart**:
- 1 item ile assert hatası fırlatmalı
- 6 item ile assert hatası fırlatmalı
- 3 item ile normal çalışmalı
- go_router mock ile tab değişimi testi

Her test için grup açıklaması ve açıklayıcı test isimleri kullan.
flutter_test package kullan.
```

---

## FAZ 2 — FloatingPill + Scroll-to-Hide + Badge Animasyonu

### Prompt 2.1 — FloatingPill Stili

```
flutter_nav_kit paketi için floating pill stil widget'ı yaz.

**lib/src/styles/floating_pill_style.dart** içeriği:

FloatingPillStyle StatelessWidget:
Parametreler:
- List<NavItem> items (zorunlu)
- int selectedIndex (zorunlu)
- ValueChanged<int> onItemTapped (zorunlu)
- NavKitTheme theme (zorunlu)

Görünüm hedefi:
- Bar zeminden yüksekte durmalı (margin ile)
- Yuvarlak köşeler (theme.borderRadius ?? 32)
- Arkaplan bulanıklığı: BackdropFilter + ImageFilter.blur(sigmaX: 10, sigmaY: 10)
- Hafif şeffaf arka plan: backgroundColor.withOpacity(0.85)
- Gölge: BoxShadow(blurRadius: 20, spreadRadius: -5, color: Colors.black.withOpacity(0.15))
- Dış margin: theme.margin ?? EdgeInsets.symmetric(horizontal: 24, vertical: 12)
- Yükseklik: theme.height ?? 64

İç yapı:
- Row içinde items.length kadar item
- Seçili item: arka plan rengi (indicatorColor) olan yuvarlak kapsayıcı içinde ikon + label
  - AnimatedContainer ile boyut değişimi (genişlik animasyonu: daraltıp genişletme)
- Pasif item: sadece ikon
- Geçiş animasyonu: 300ms, Curves.easeInOut

SafeArea:
- bottom: true

Önemli:
- ClipRRect ile yuvarlak köşeleri kırp
- Stack kullanma, Scaffold.bottomNavigationBar'a verilecek
- Scaffold body'sinin altında kaymaması için Scaffold'a bottomNavigationBar olarak değil,
  body içinde Stack + Positioned.bottom ile kullan
  (NavKitScaffold bunu halleder, bu widget sadece görsel kısmı döndürür)

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 2.2 — ScrollControllerMixin ve Scroll-to-Hide

```
flutter_nav_kit paketi için scroll-to-hide özelliğini yaz.

**lib/src/utils/scroll_controller_mixin.dart** içeriği:

NavScrollMixin — State sınıfları için mixin:
- bool _isNavBarVisible = true getter ile dışarı aç
- double _lastScrollOffset = 0
- ScrollNotification'ı dinle

notificationListener metodu:
- ScrollUpdateNotification geldiğinde:
  - delta > 3 (aşağı) → _isNavBarVisible = false
  - delta < -3 (yukarı) → _isNavBarVisible = true
  - setState çağır
- NotificationListener<ScrollNotification> döndüren Widget buildScrollListener(Widget child) metodu

---

NavKitScaffold'u StatefulWidget'a dönüştür ve bu mixin'i ekle.
hideOnScroll: true ise:
- bottomNavigationBar'ı AnimatedSlide ile sar:
  - _isNavBarVisible: offset Offset(0, 0)
  - !_isNavBarVisible: offset Offset(0, 1)
  - duration: hideAnimationDuration ?? 300ms
  - curve: hideAnimationCurve ?? Curves.easeInOut
- body'yi NotificationListener ile sar

Önemli: ScrollController gerektirmesin. NotificationListener ile çalışsın.

Mevcut nav_kit_scaffold.dart dosyasını bu mixin'i kullanacak şekilde güncelle.

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 2.3 — NavKitScaffold'a FloatingPill Entegrasyonu

```
Mevcut NavKitScaffold widget'ını güncelleyerek FloatingPill stilini entegre et.

Mevcut durum: style parametresi var ama her zaman SolidBarStyle kullanıyor.

Yapılacaklar:

1. _buildNavBar(BuildContext context) private metodu oluştur:
   switch (style) {
     case NavStyle.solidBar: return SolidBarStyle(...)
     case NavStyle.floatingPill: return FloatingPillStyle(...)
     case NavStyle.glass: return SolidBarStyle(...) // Faz 3'e kadar fallback
   }

2. FloatingPill için özel Scaffold yapısı:
   FloatingPill Scaffold.bottomNavigationBar'a verilmez.
   Bunun yerine:
   Scaffold(
     body: Stack(
       children: [
         Padding(
           padding: EdgeInsets.only(bottom: _floatingBarHeight), // içerik barın altına gitmesin
           child: navigationShell,
         ),
         Positioned(
           bottom: 0, left: 0, right: 0,
           child: AnimatedSlide(...) // hideOnScroll için
             child: FloatingPillStyle(...)
           )
         ),
       ],
     ),
   )

3. SolidBar için:
   Scaffold(
     body: navigationShell,
     bottomNavigationBar: AnimatedSlide(...) // hideOnScroll için
       child: SolidBarStyle(...)
     )
   )

4. _floatingBarHeight hesabı:
   theme?.height ?? 64 + (margin?.bottom ?? 12) + MediaQuery.of(context).padding.bottom

Dart 3, flutter_lints uyumlu.
```

---

## FAZ 3 — Glass Stili + iOS 26 Platform Detect

### Prompt 3.1 — PlatformDetector

```
flutter_nav_kit paketi için platform algılama yardımcısını yaz.

**lib/src/utils/platform_detector.dart** içeriği:

PlatformDetector abstract class (sadece static metodlar):

static bool get isIOS:
- dart:io Platform.isIOS kullan
- kIsWeb true ise false döndür

static bool get isAndroid:
- dart:io Platform.isAndroid kullan
- kIsWeb true ise false döndür

static bool get isIOS26OrHigher:
- kIsWeb true ise false döndür
- Platform.isIOS değilse false döndür
- Platform.operatingSystemVersion'dan major versiyon parse et
- major >= 26 ise true

static double get iosVersion:
- iOS değilse 0.0 döndür
- Platform.operatingSystemVersion'ı parse et (örn: "26.0.0")

Önemli:
- dart:io import'unu conditional yapmalısın: web'de Platform sınıfı yok
- `import 'dart:io' show Platform;` yerine
  defaultTargetPlatform (package:flutter/foundation.dart) veya
  kIsWeb kontrolü ile güvenli yap

Platform.operatingSystemVersion iOS'ta bu formatta gelir: "Version X.Y.Z (Build XXXX)"
Parse ederken split ve RegExp kullan.

Dart 3, flutter_lints uyumlu. Web'de çalışmalı (crash vermemeli).
```

---

### Prompt 3.2 — Glass Stili (FrostedGlass)

```
flutter_nav_kit paketi için glass bar stil widget'ı yaz.

**lib/src/styles/glass_style.dart** içeriği:

GlassBarStyle StatelessWidget:
Parametreler: (SolidBarStyle ile aynı)
- List<NavItem> items
- int selectedIndex
- ValueChanged<int> onItemTapped
- NavKitTheme theme

Bu widget PlatformDetector.isIOS26OrHigher kontrolü yapar:
- true → NativeGlassBar widget'ı döndür (stub: şimdilik FrostedGlassBar döndür, Faz 3.3'te implement edilecek)
- false → FrostedGlassBar döndür

---

FrostedGlassBar StatelessWidget (aynı dosyada):

Görünüm:
- BackdropFilter(filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20), child: ...)
- Arka plan: backgroundColor.withOpacity(0.6) veya Colors.white.withOpacity(0.6)
- Üstte ince çizgi: Colors.white.withOpacity(0.5), thickness: 0.5
- Köşe yarıçapı: 0 (düz bar) veya theme.borderRadius (floating kullanımda)

İçerik:
- Row içinde NavItemWidget'lar (SolidBarStyle ile aynı yapı)
- Seçili item'da pill gösterge: beyaz/primary rengi, yuvarlak

SafeArea: bottom: true
ClipRRect ile köşeleri kırp

Dart 3. BackdropFilter kullanımı için ClipRect gerekli: ClipRect > BackdropFilter > Container.
flutter_lints uyumlu.
```

---

### Prompt 3.3 — Native iOS 26 UITabBar (Platform Channel)

```
flutter_nav_kit paketi için iOS 26 native UITabBar platform channel implementasyonunu yaz.

Bu özellik sadece iOS 26+ cihazlarda çalışır. Diğer platformlarda FrostedGlassBar kullanılır.

---

**ios/Classes/FlutterNavKitPlugin.swift** içeriği:

SwiftUI UITabBar'ı Flutter'a aktaracak bir FlutterPlatformView implementasyonu.

NativeGlassTabBarFactory: NSObject, FlutterPlatformViewFactory
NativeGlassTabBarView: NSObject, FlutterPlatformView

UIView olarak UIHostingController<NativeTabBarView> döndür.

NativeTabBarView: View (SwiftUI):
- items: [TabItemData] (JSON'dan parse et)
- selectedIndex: Int
- onTabSelected: (Int) -> Void

TabItemData: Codable
- label: String
- iconName: String (SF Symbol adı veya system icon)
- badgeCount: Int? (0 = nokta, null = yok, >0 = sayı)

Flutter ↔ Swift iletişim:
- MethodChannel: "flutter_nav_kit/native_tab_bar"
- Method: "updateItems" → items JSON
- Method: "updateSelectedIndex" → index
- EventChannel: "flutter_nav_kit/tab_selected" → seçilen index

---

**lib/src/styles/native_glass_bar.dart** içeriği:

NativeGlassBar StatefulWidget:
- UiKitView ile "flutter_nav_kit/NativeGlassTabBar" viewType'ını render et
- MethodChannel üzerinden items ve selectedIndex gönder
- EventChannel üzerinden tab seçimini dinle, onItemTapped çağır

---

**lib/src/styles/glass_style.dart** güncelle:
NativeGlassBar import et ve PlatformDetector.isIOS26OrHigher true ise kullan.

---

Önemli notlar:
- FlutterNavKitPlugin'i AppDelegate'e register etmeyi unutma (ios/Runner/AppDelegate.swift örneği yaz)
- pubspec.yaml'a ios plugin tanımı ekle
- flutter_lints uyumlu Dart kodu
- Swift kodu için minimum iOS 26 deployment target
```

---

## FAZ 4 — Navigation Drawer + Accessibility + Deep Link

### Prompt 4.1 — NavigationDrawer Widget'ı

```
flutter_nav_kit paketi için desktop navigation drawer widget'ı yaz.

**lib/src/widgets/nav_drawer.dart** içeriği:

NavKitDrawer StatelessWidget:
Parametreler:
- List<NavItem> items (zorunlu)
- int selectedIndex (zorunlu)
- ValueChanged<int> onItemTapped (zorunlu)
- NavKitTheme theme (zorunlu)
- Widget body (zorunlu)

Yapı:
Scaffold(
  body: Row(
    children: [
      NavKitDrawerPanel(...),
      VerticalDivider(thickness: 1, width: 1),
      Expanded(child: body),
    ],
  ),
)

NavKitDrawerPanel StatelessWidget:
- Genişlik: 256px (sabit)
- Column içinde:
  - Padding (top: 16)
  - items.map → DrawerNavItem widget'ı

DrawerNavItem StatelessWidget:
- selectedIndex == itemIndex ise seçili görünüm:
  - Arka plan: indicatorColor
  - Sol kenar çizgisi: 3px, selectedItemColor
  - Icon + label yatay
- Pasif görünüm: sadece icon + label, soluk renk
- NavBadgeWidget entegrasyonu (badge varsa)
- Minimum dokunma yüksekliği: 48px
- ListTile veya InkWell kullan
- AnimatedContainer ile seçim geçişi

NavKitScaffold'da _buildDrawerLayout metodunu güncelle:
- NavKitDrawer widget'ını döndür (stub'ı kaldır)
- breakpoints.drawer değerini kullan

Dart 3, flutter_lints uyumlu.
```

---

### Prompt 4.2 — Accessibility Geliştirmeleri

```
flutter_nav_kit paketinin tüm widget'larına kapsamlı accessibility desteği ekle.

Aşağıdaki dosyaları güncelle:

**nav_item_widget.dart**:
- Mevcut Semantics'i genişlet:
  Semantics(
    label: item.effectiveTooltip,
    button: true,
    selected: isSelected,
    hint: isSelected ? 'Seçili sekme' : '${item.effectiveTooltip} sekmesine git',
    onTap: onTap,
    child: ...,
  )
- Minimum touch target: SizedBox(width: 48, height: 48) ile sarılı olduğundan emin ol

**nav_badge_widget.dart**:
- Badge semantics:
  - isDot: Semantics(label: 'Yeni bildirim var', child: ...)
  - count: Semantics(label: '${badge.displayText} bildirim', child: ...)

**solid_bar_style.dart** ve **floating_pill_style.dart**:
- MediaQuery.highContrastOf(context) true ise:
  - Border ekle veya kontrast artır
- MediaQuery.disableAnimationsOf(context) true ise:
  - AnimationController duration'ı 0'a indir
  - Animasyonları atla

**nav_kit_scaffold.dart**:
- ExcludeSemantics ile navigation bar dışındaki alanlarda çakışma önle
- Focus traversal order ekle: FocusTaversal widget ile nav items'ları tab sırasına koy

Tüm değişiklikler için mevcut kodu paylaş ve güncelle.
Dart 3, WCAG 2.1 AA uyumlu, flutter_lints uyumlu.
```

---

### Prompt 4.3 — Kapsamlı Test Paketi (Faz 4)

```
flutter_nav_kit paketi için kapsamlı final test paketi yaz.

**test/nav_kit_scaffold_test.dart** — genişletilmiş versiyon:

1. Adaptive layout testleri:
   - Genişlik 400px → SolidBarStyle/FloatingPillStyle gösterilmeli
   - Genişlik 800px → NavigationRail gösterilmeli
   - Genişlik 1300px → NavigationDrawer gösterilmeli
   - MediaQueryData ile genişliği simüle et

2. Tab değişimi testleri:
   - Tab'a tıklanınca doğru index ile goBranch çağrılmalı
   - onTabChanged callback çağrılmalı
   - initialTabIndex doğru çalışmalı

3. Badge testleri:
   - Badge değeri 0 iken badge görünmemeli
   - Badge.dot() görünmeli
   - Badge.count(5) "5" göstermeli
   - Badge.count(100) "99+" göstermeli

4. Erişilebilirlik testleri:
   - Her nav item'ın Semantics.label'ı item.label'a eşit olmalı
   - isSelected true item'ın selected: true semantics'i olmalı

5. Assert testleri:
   - 1 item → FlutterError fırlatmalı
   - 6 item → FlutterError fırlatmalı
   - 2 item → normal çalışmalı
   - 5 item → normal çalışmalı

Her test için MaterialApp > Router > StatefulShellRoute mock'u oluştur.
go_router'ı mocklama yerine gerçek GoRouter kullan.
flutter_test, WidgetTester kullan.
Dart 3, flutter_lints uyumlu.
```

---

## GENEL — Her Fazdan Sonra Çalıştır

### Prompt G.1 — Lint ve Analiz Düzeltme

```
flutter_nav_kit paketi üzerinde aşağıdaki komutları çalıştırdım ve hatalar aldım.

Komutlar:
- flutter analyze
- dart format --set-exit-if-changed lib/
- flutter test

Çıktı:
[BURAYA HATA ÇIKTISINI YAPISTIR]

Tüm hataları ve uyarıları düzelt. Değiştirilen her dosyanın tam içeriğini ver.
flutter_lints kurallarına tam uyum sağla.
Dart 3 syntax kullan.
```

---

### Prompt G.2 — CHANGELOG.md Güncelleme

```
flutter_nav_kit paketi için CHANGELOG.md dosyasını güncelle.

Mevcut versiyon: [VERSİYON]
Yeni versiyon: [YENİ VERSİYON]

Bu versiyonda yapılanlar:
[YAPILANLARI YAZ]

Keep a Changelog formatını kullan (https://keepachangelog.com).
Kategoriler: Added, Changed, Fixed, Deprecated, Removed, Security.
```

---

### Prompt G.3 — pub.dev Yayın Kontrolü

```
flutter_nav_kit paketini pub.dev'e yayınlamadan önce kontrol listesi:

Aşağıdaki dosyaları incele ve eksikleri tamamla:

1. pubspec.yaml:
   - description 60-180 karakter arasında mı?
   - homepage doğru mu?
   - repository doğru mu?
   - issue_tracker doğru mu?
   - topics listesi var mı? (navigation, bottom-bar, go-router, material-3, adaptive)
   - screenshots listesi var mı?

2. README.md:
   - pub.dev badge'leri gerçek URL ile mi?
   - Kod örnekleri çalışıyor mu?
   - GIF/screenshot var mı?

3. CHANGELOG.md:
   - Keep a Changelog formatında mı?
   - İlk versiyon girişi var mı?

4. LICENSE:
   - MIT lisansı tam mı?
   - Copyright yılı ve isim doğru mu?

5. example/:
   - Çalışan bir example app var mı?
   - pubspec.yaml'da example doğru tanımlı mı?

6. lib/flutter_nav_kit.dart:
   - Tüm public API'lar export edilmiş mi?
   - Library directive var mı?

Eksikleri tamamla ve son halini ver.
```

---

## HIZLI REFERANS

| Faz | Prompt | Konu |
|-----|--------|------|
| 1 | 1.1 | Proje kurulumu |
| 1 | 1.2 | NavItem + NavBadge modelleri |
| 1 | 1.3 | NavStyle + NavKitTheme + NavBreakpoints |
| 1 | 1.4 | NavBadgeWidget |
| 1 | 1.5 | NavItemWidget |
| 1 | 1.6 | SolidBar stili |
| 1 | 1.7 | NavKitScaffold (Faz 1) |
| 1 | 1.8 | Barrel export + Example app |
| 1 | 1.9 | Faz 1 testleri |
| 2 | 2.1 | FloatingPill stili |
| 2 | 2.2 | ScrollMixin + scroll-to-hide |
| 2 | 2.3 | FloatingPill entegrasyonu |
| 3 | 3.1 | PlatformDetector |
| 3 | 3.2 | FrostedGlass stili |
| 3 | 3.3 | Native iOS 26 UITabBar |
| 4 | 4.1 | NavigationDrawer |
| 4 | 4.2 | Accessibility |
| 4 | 4.3 | Final test paketi |
| G | G.1 | Lint düzeltme |
| G | G.2 | CHANGELOG güncelleme |
| G | G.3 | pub.dev yayın kontrolü |

---

## ÖNEMLİ NOTLAR

1. **Her prompt sonunda** `flutter analyze` ve `flutter test` çalıştır. Hata varsa G.1 prompt'unu kullan.

2. **Context aktarımı:** Her yeni prompt'a başlamadan önce önceki promptun ürettiği ilgili dosyaları context olarak ekle.

3. **Versiyon yönetimi:**
   - Faz 1 tamamı → v0.1.0
   - Faz 2 tamamı → v0.2.0
   - Faz 3 tamamı → v0.3.0
   - Faz 4 tamamı → v1.0.0

4. **iOS 26 Prompt 3.3** Swift kodu içerir. Eğer kullandığın yapay zeka Swift bilmiyorsa Claude'a sor.

5. **Pub.dev yayını** için `dart pub publish --dry-run` komutunu önce çalıştır.
