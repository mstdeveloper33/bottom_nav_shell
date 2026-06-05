# Bottom Shell Nav — Flutter Paket Ürün Planı

> **Amaç:** Flutter için sadece güzel görünen bir bottom navigation bar değil; route-aware, persistent, adaptive ve modern görünümlü bir navigation shell paketi tasarlamak.

---

## 1. Yönetici Özeti

Flutter ekosisteminde bottom navigation alanında çok sayıda paket bulunuyor. Ancak bu paketlerin büyük bölümü yalnızca görsel bottom bar üretmeye odaklanıyor. Yani ikon animasyonları, curved bar, convex bar, floating bar veya Material benzeri görünümler sunuyorlar.

Fakat gerçek uygulamalarda geliştiricinin yaşadığı problem yalnızca "bar nasıl görünecek?" sorusu değildir.

Gerçek problem şudur:

- Sekmeler arası geçince sayfa state'i kaybolmamalı.
- Her tab kendi navigation stack'ini korumalı.
- Bir tab içinden detail sayfasına gidildiğinde bottom bar kaybolmamalı.
- Aynı tab'a tekrar basıldığında root sayfaya dönülebilmeli.
- `go_router` veya `auto_route` ile temiz çalışmalı.
- SafeArea, keyboard, notch ve bottom inset davranışları düzgün olmalı.
- Tablet ve desktop ekranlarda bottom bar yerine navigation rail'e dönüşebilmeli.
- Modern ve şık görünmeli.
- Accessibility, RTL, text scale ve dark mode desteği olmalı.

Bu nedenle yeni paketin konumu şu olmalıdır:

> **Not just a beautiful bottom bar.  
> A modern navigation shell for real Flutter apps.**

Türkçe karşılığı:

> **Sadece güzel bir bottom bar değil.  
> Gerçek Flutter uygulamaları için modern navigation shell.**

---

## 2. Ürün Kararı

Bu paket sadece bir `BottomNavigationBar` alternatifi olmayacak.

Yanlış konumlandırma:

```text
Daha güzel animasyonlu bir bottom bar yapalım.
```

Doğru konumlandırma:

```text
Flutter için route-aware, persistent, adaptive ve modern görünümlü bottom navigation shell yapalım.
```

Yani ürünün özü:

```text
Bottom bar + tab state + nested navigation + safe area + adaptive layout + modern renderer + accessibility
```

---

## 3. Paket Konumlandırması

### İngilizce Pub.dev Açıklaması

```text
A route-aware, persistent and adaptive bottom navigation shell for Flutter.
Supports nested tab navigation, preserved branch state, SafeArea handling,
modern renderers, accessibility, custom bars and router adapters.
```

### Türkçe Ürün Tanımı

```text
Flutter için route-aware, durum koruyan ve adaptif bottom navigation shell paketi.
Her tab için ayrı navigation stack, kalıcı tab state'i, SafeArea, modern renderer,
accessibility, custom tasarım ve router adapter desteği sunar.
```

### Kısa Slogan

```text
Not another animated bottom bar.
A modern navigation shell for real Flutter apps.
```

Alternatif slogan:

```text
Beautiful on the surface. Reliable in the navigation core.
```

---

## 4. Pazar Gözlemi

Mevcut bottom bar paketleri genel olarak iki gruba ayrılıyor.

### 4.1 Görsel Odaklı Paketler

Örnekler:

- `google_nav_bar`
- `salomon_bottom_bar`
- `curved_navigation_bar`
- `convex_bottom_bar`
- `animated_bottom_navigation_bar`
- `bottom_navy_bar`
- `fancy_bottom_navigation`

Bu paketlerin ortak özelliği:

- Şık görünüm sunarlar.
- Animasyon sunarlar.
- Basit kullanım sağlarlar.
- Genellikle sadece bar widget'ı verirler.
- Navigation stack yönetimini geliştiriciye bırakırlar.
- Router entegrasyonu çoğu zaman birinci sınıf destek değildir.
- Tab içi nested navigation genellikle uygulama koduna bırakılır.

### 4.2 Persistent Navigation Odaklı Paketler

Örnekler:

- `persistent_bottom_nav_bar`
- `persistent_bottom_nav_bar_v2`

Bu paketler daha güçlüdür çünkü:

- Tab state koruyabilir.
- Her tab için ayrı navigation mantığına yaklaşır.
- Daha gerçek uygulama senaryolarına hitap eder.
- Hazır stiller sunar.

Ancak fırsat alanları hâlâ vardır:

- API daha sade olabilir.
- Modern görünüm daha kontrollü sunulabilir.
- Core ve router adapter ayrımı daha temiz yapılabilir.
- Accessibility ve adaptive layout daha net konumlandırılabilir.
- Material 3, floating pill ve gelecekte navigation rail desteği daha güçlü ürün mesajı oluşturabilir.

---

## 5. Belirlenen Pazar Boşluğu

Yeni paket için en güçlü boşluk şudur:

```text
Görsel olarak modern, mimari olarak güçlü, router-dostu ve adaptive bottom navigation shell.
```

Yani pazarda iki uç var:

```text
1. Çok güzel görünen ama sadece bar çizen paketler
2. Navigation problemi çözen ama daha ağır veya karmaşık hisseden paketler
```

Bizim konumumuz:

```text
Basit API + modern görünüm + gerçek navigation mimarisi
```

---

## 6. Hedef Kullanıcılar

### 6.1 Orta Seviye Flutter Geliştiriciler

Bu geliştiriciler artık sadece `setState` ile tab değiştirmek istemez. Daha temiz, state koruyan ve gerçek uygulamaya uygun yapı ister.

### 6.2 Clean Architecture Kullanan Geliştiriciler

Presentation katmanını temiz tutmak isteyen geliştiriciler için route-aware shell yapısı değerlidir.

### 6.3 `go_router` Kullanan Ekipler

`go_router` ile bottom navigation kurmak, özellikle `StatefulShellRoute` ve branch yapıları yeni başlayanlar için karışık olabilir. Bu paket adapter ile ciddi kolaylık sağlayabilir.

### 6.4 `auto_route` Kullanan Ekipler

`AutoTabsRouter` kullanan ekipler için daha modern ve özelleştirilebilir bir shell katmanı sunulabilir.

### 6.5 Ajanslar ve Freelance Geliştiriciler

Birçok projede aynı bottom navigation mimarisini tekrar tekrar kurmak yerine, hazır ama esnek bir shell kullanabilirler.

### 6.6 Tablet / Desktop Hedefleyen Flutter Geliştiricileri

Adaptive navigation desteği sayesinde bottom bar, büyük ekranda navigation rail'e dönüşebilir.

---

## 7. Ürünün Ana Değer Önerisi

Paketin ana vaadi:

```text
Geliştiriciye yalnızca güzel bir bottom bar değil, gerçek uygulamalarda kullanılabilir bir navigation shell vermek.
```

Paket şunları çözmeli:

- Tab state koruma
- Nested navigation
- Her tab için ayrı Navigator
- Bottom bar'ın detail sayfalarında kaybolmaması
- Aynı tab'a tekrar tıklayınca pop-to-root
- Lazy branch loading
- SafeArea ve keyboard davranışı
- Modern Material 3 görünüm
- Floating pill görünüm
- Badge desteği
- Accessibility
- Router adapter mimarisi
- Adaptive navigation

---

## 8. Paket İsmi Önerileri

| İsim | Yorum |
|---|---|
| `bottom_shell_nav` | En dengeli ve açıklayıcı isim |
| `branch_nav_shell` | Branch mantığını güçlü anlatır |
| `adaptive_bottom_shell` | Adaptive özelliği öne çıkarır |
| `shell_nav_bar` | Kısa ve akılda kalıcı |
| `route_aware_bottom_bar` | SEO güçlü ama uzun |
| `nested_bottom_shell` | Nested navigation farkını anlatır |
| `modern_bottom_shell` | Görsellik ve shell fikrini birleştirir |

## Önerilen Ana İsim

```text
bottom_shell_nav
```

## Adapter Paketleri

```text
bottom_shell_nav_go_router
bottom_shell_nav_auto_route
```

---

## 9. Ürün Mimari Yaklaşımı

Paket iki ana katmana ayrılmalıdır.

```text
1. Navigation Core Layer
2. Visual Renderer Layer
```

### 9.1 Navigation Core Layer

Bu katman paketin gerçek değerini taşır.

Sorumlulukları:

- Seçili tab yönetimi
- Her branch için ayrı Navigator
- Branch stack koruma
- Lazy branch initialization
- Reselect behavior
- Android back button handling
- SafeArea policy
- Keyboard policy
- Branch lifecycle
- Controller API

### 9.2 Visual Renderer Layer

Bu katman paketin modern ve şık görünmesini sağlar.

Sorumlulukları:

- Material 3 bottom bar
- Floating pill bottom bar
- Badge görünümü
- Selected indicator
- Animasyonlar
- Label behavior
- Custom barBuilder desteği
- Gelecekte glass, Cupertino ve rail renderer desteği

---

## 10. Önerilen Paket Mimarisi

```text
BottomShell
 ├── Navigation Core
 │    ├── selectedIndex
 │    ├── branch navigator
 │    ├── tab persistence
 │    ├── reselect behavior
 │    ├── back button behavior
 │    ├── SafeArea policy
 │    └── keyboard policy
 │
 └── Renderer Layer
      ├── MaterialBottomBarRenderer
      ├── FloatingPillBottomBarRenderer
      ├── CustomRenderer
      ├── future GlassBottomBarRenderer
      ├── future CupertinoBottomBarRenderer
      └── future NavigationRailRenderer
```

---

## 11. MVP Yol Haritası

## MVP 0 — Ürün ve API Doğrulama

Amaç:

```text
Kod yazmadan önce API gerçekten doğru mu, geliştirici bu paketi kullanmak ister mi, bunu doğrulamak.
```

Çıktılar:

- Paket adı seçilecek
- Public API taslağı hazırlanacak
- README taslağı yazılacak
- Before / After örnekleri hazırlanacak
- Rakiplerden fark netleştirilecek
- İlk example app senaryosu belirlenecek
- Modern görünüm presetleri netleştirilecek

Başarı kriteri:

```text
Geliştirici README'yi açtığında paketin ne çözdüğünü 2 dakikada anlamalı.
```

---

## MVP 1 — Core Navigation Shell

Sürüm:

```text
bottom_shell_nav v0.1.0
```

Bu ilk yayınlanabilir sürümdür.

### Olacak Özellikler

#### Core

- `BottomShell`
- `BottomBranch`
- `BottomDestination`
- `BottomShellController`
- `BranchBadge`
- `ReTapBehavior`
- `BranchPersistencePolicy`
- `SafeAreaPolicy`
- `KeyboardPolicy`

#### Navigation

- Her tab için ayrı Navigator
- Navigator key desteği
- IndexedStack ile state koruma
- Lazy branch loading
- Android back button desteği
- Aynı tab'a tekrar basınca pop-to-root
- Bottom bar'ın nested route içinde kalıcı olması

#### UI

- Material 3 renderer
- Floating Pill renderer
- Selected / unselected icon desteği
- Label behavior
- Badge desteği
- Custom `barBuilder`

#### UX

- SafeArea default açık
- Keyboard açılınca bar davranışı
- Tooltip
- Basic semantics
- Minimum touch target
- Dark mode uyumu

#### Dokümantasyon

- Basic usage
- Nested navigation example
- Custom renderer example
- Floating pill example
- Badge example
- Reselect example
- SafeArea açıklaması
- Before / After bölümü

### Olmayacak Özellikler

- `go_router` adapter
- `auto_route` adapter
- Cupertino renderer
- Glass blur renderer
- Çok fazla hazır stil
- FAB notch
- Analytics hook
- Full adaptive rail desteği
- Sliver özel desteği

---

## MVP 2 — Router Adapter: go_router

Sürüm:

```text
bottom_shell_nav_go_router v0.1.0
```

Amaç:

`go_router` kullanan geliştiriciler için bottom shell kullanımını kolaylaştırmak.

Özellikler:

- `BottomShellGoRouterAdapter`
- `StatefulShellRoute` desteği
- `navigationShell.currentIndex` senkronizasyonu
- `navigationShell.goBranch(index)` entegrasyonu
- Destination mapping
- Reselect behavior desteği
- Router-agnostic core ile uyumlu yapı

Örnek kullanım:

```dart
BottomShellGoRouterAdapter(
  navigationShell: navigationShell,
  appearance: BottomShellAppearance.floatingPill(),
  destinations: const [
    BottomDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    BottomDestination(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
    ),
    BottomDestination(
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      label: 'Profile',
    ),
  ],
)
```

---

## MVP 3 — Adaptive Navigation

Sürüm:

```text
bottom_shell_nav v0.2.0
```

Amaç:

Telefon, tablet ve desktop ekranlarda doğru navigation pattern kullanmak.

Özellikler:

- Compact ekranda bottom bar
- Medium / expanded ekranda navigation rail
- `AdaptiveNavigationPolicy`
- Breakpoint ayarları
- NavigationRail renderer
- Tablet / desktop example app

Örnek API:

```dart
BottomShell(
  adaptivePolicy: const AdaptiveNavigationPolicy(
    compact: AdaptiveNavigationMode.bottomBar,
    mediumAndUp: AdaptiveNavigationMode.navigationRail,
  ),
  branches: branches,
)
```

---

## MVP 4 — Accessibility ve UX Güçlendirme

Sürüm:

```text
bottom_shell_nav v0.3.0
```

Özellikler:

- Semantics label
- Selected state semantics
- Tooltip
- RTL desteği
- Text scale handling
- Minimum touch target
- Reduce motion desteği
- High contrast uyumu
- Screen reader uyum testleri

README mesajı:

```text
Built with accessibility, RTL and text scaling in mind.
```

---

## MVP 5 — Cupertino Renderer

Sürüm:

```text
bottom_shell_nav v0.4.0
```

Özellikler:

- Cupertino style bottom tab renderer
- iOS-style tab behavior
- iOS renk ve spacing varsayılanları
- Cupertino icons example
- Platform adaptive renderer

---

## MVP 6 — auto_route Adapter

Sürüm:

```text
bottom_shell_nav_auto_route v0.1.0
```

Özellikler:

- `BottomShellAutoRouteAdapter`
- `AutoTabsRouter` entegrasyonu
- `TabsRouter.activeIndex` senkronizasyonu
- Destination mapping
- Reselect behavior
- AutoRoute example

---

## MVP 7 — Advanced Behaviors

İleri aşama özellikler:

- Scroll-to-top registry
- `onBeforeSelect` guard
- Disabled tab support
- Auth required tab behavior
- Analytics hooks
- Branch observers
- State restoration
- Custom transition policy
- Scroll-aware hide/show
- Dynamic branch visibility

Örnek:

```dart
BottomShell(
  onBeforeSelect: (context, branch) async {
    if (branch.id == 'profile' && !auth.isLoggedIn) {
      showLoginSheet(context);
      return false;
    }

    return true;
  },
  branches: branches,
)
```

---

## 12. Modern Görünüm Stratejisi

Paket yalnızca teknik bir shell gibi görünmemeli. Pub.dev'de ilk bakışta modern ve kaliteli hissettirmeli.

Ancak kritik ayrım:

```text
Görsellik ana kimlik değil, güçlü destek katmanı olacak.
```

Ana kimlik:

```text
Modern görünümlü, persistent ve route-aware navigation shell.
```

---

## 13. v0.1.0 İçin Görsel Presetler

İlk sürümde çok fazla stil olmamalı. Sadece iki tane kaliteli görünüm yeterlidir.

```text
1. Material 3 Renderer
2. Floating Pill Renderer
```

---

## 14. Material 3 Renderer

Varsayılan renderer olarak kullanılabilir.

Özellikler:

- Material Design uyumlu
- Temiz ve güvenli görünüm
- Dark mode uyumlu
- Badge destekli
- Label behavior destekli
- Accessibility uyumlu
- Kurumsal uygulamalar için uygun

Kullanım:

```dart
BottomShell(
  branches: branches,
  renderer: const MaterialBottomBarRenderer(),
)
```

Ya da default olarak:

```dart
BottomShell(
  branches: branches,
)
```

---

## 15. Floating Pill Renderer

Paketin modern ve şık yüzü olabilir.

Görsel özellikler:

- Ekranın altında yüzen kapsül bar
- Yuvarlatılmış köşeler
- Hafif gölge
- Seçili item için pill indicator
- Yumuşak animasyon
- Badge desteği
- SafeArea uyumu
- Dark mode uyumu

Kullanım:

```dart
BottomShell(
  branches: branches,
  renderer: const FloatingPillBottomBarRenderer(),
)
```

Daha özelleştirilmiş kullanım:

```dart
BottomShell(
  branches: branches,
  renderer: const FloatingPillBottomBarRenderer(
    height: 72,
    borderRadius: 32,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    labelBehavior: BottomLabelBehavior.onlySelected,
    animationStyle: BottomBarAnimationStyle.smooth,
  ),
)
```

---

## 16. Glass Renderer Hakkında Karar

Glassmorphism / blur görünümü modern ve dikkat çekici olabilir. Ancak ilk sürümde ana özellik yapılmamalıdır.

Riskler:

- Performans sorunu
- Blur arka plan hataları
- SafeArea sorunları
- `extendBody` problemleri
- Notch / FAB geometrisi karmaşası
- Keyboard davranışı sorunları

Karar:

```text
v0.1.0:
- Glass renderer yok veya experimental değil.

v0.2.0 / v0.3.0:
- Test edilmiş GlassBottomBarRenderer eklenebilir.
```

---

## 17. Önerilen Public API

### Basit Kullanım

```dart
BottomShell(
  branches: [
    BottomBranch(
      id: 'home',
      destination: const BottomDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      builder: (context) => const HomePage(),
    ),
    BottomBranch(
      id: 'search',
      destination: const BottomDestination(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: 'Search',
      ),
      builder: (context) => const SearchPage(),
    ),
    BottomBranch(
      id: 'profile',
      destination: const BottomDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
      builder: (context) => const ProfilePage(),
    ),
  ],
)
```

### Floating Pill Kullanımı

```dart
BottomShell(
  appearance: BottomShellAppearance.floatingPill(),
  branches: [
    BottomBranch(
      id: 'home',
      destination: const BottomDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      builder: (_) => const HomePage(),
    ),
    BottomBranch(
      id: 'search',
      destination: const BottomDestination(
        icon: Icons.search_outlined,
        selectedIcon: Icons.search,
        label: 'Search',
      ),
      builder: (_) => const SearchPage(),
    ),
    BottomBranch(
      id: 'profile',
      destination: const BottomDestination(
        icon: Icons.person_outline,
        selectedIcon: Icons.person,
        label: 'Profile',
      ),
      builder: (_) => const ProfilePage(),
    ),
  ],
)
```

### Gelişmiş Kullanım

```dart
final controller = BottomShellController(initialIndex: 0);

BottomShell(
  controller: controller,
  persistence: const BranchPersistencePolicy.indexedStack(
    lazyLoadBranches: true,
  ),
  reTapBehavior: const ReTapBehavior.popToRoot(),
  appearance: const BottomShellAppearance.floatingPill(
    margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
    height: 72,
    borderRadius: 32,
    labelBehavior: BottomLabelBehavior.onlySelected,
    animationStyle: BottomBarAnimationStyle.smooth,
  ),
  branches: [
    BottomBranch(
      id: 'home',
      navigatorKey: GlobalKey<NavigatorState>(),
      destination: const BottomDestination(
        icon: Icons.home_outlined,
        selectedIcon: Icons.home,
        label: 'Home',
      ),
      builder: (context) => const HomePage(),
    ),
    BottomBranch(
      id: 'messages',
      navigatorKey: GlobalKey<NavigatorState>(),
      destination: const BottomDestination(
        icon: Icons.mail_outline,
        selectedIcon: Icons.mail,
        label: 'Messages',
        badge: BranchBadge.count(8),
      ),
      builder: (context) => const MessagesPage(),
    ),
  ],
)
```

### Custom Bar Kullanımı

```dart
BottomShell(
  branches: branches,
  barBuilder: (context, state) {
    return MyCustomBottomBar(
      selectedIndex: state.currentIndex,
      destinations: state.destinations,
      onTap: state.selectBranch,
    );
  },
)
```

---

## 18. Public API Bileşenleri

| Bileşen | Sorumluluk |
|---|---|
| `BottomShell` | Ana shell widget |
| `BottomBranch` | Her tab / branch tanımı |
| `BottomDestination` | Icon, selectedIcon, label, tooltip, badge bilgileri |
| `BottomShellController` | Seçili index, programatik geçiş ve lifecycle yönetimi |
| `BranchBadge` | Count, dot veya custom badge desteği |
| `ReTapBehavior` | Aynı tab'a tekrar basıldığında davranış |
| `BranchPersistencePolicy` | Branch state koruma stratejisi |
| `SafeAreaPolicy` | Bottom inset ve notch davranışı |
| `KeyboardPolicy` | Keyboard açıldığında bar davranışı |
| `BottomShellAppearance` | Hazır görsel stiller |
| `BottomBarRenderer` | Custom renderer interface |
| `MaterialBottomBarRenderer` | Material 3 renderer |
| `FloatingPillBottomBarRenderer` | Modern floating pill renderer |
| `BottomShellTheme` | Global tema katmanı |
| `BottomShellThemeData` | Renk, shape, spacing, animation token'ları |

---

## 19. Önerilen Klasör Yapısı

```text
bottom_shell_nav/
  lib/
    bottom_shell_nav.dart

    src/
      shell/
        bottom_shell.dart
        bottom_shell_scope.dart
        bottom_shell_controller.dart
        bottom_shell_state.dart

      branch/
        bottom_branch.dart
        bottom_destination.dart
        branch_badge.dart
        branch_lifecycle.dart

      navigation/
        branch_navigator.dart
        branch_navigator_host.dart
        back_button_handler.dart

      policies/
        branch_persistence_policy.dart
        re_tap_behavior.dart
        keyboard_policy.dart
        safe_area_policy.dart

      appearance/
        bottom_shell_appearance.dart
        bottom_label_behavior.dart
        bottom_bar_animation_style.dart

      renderers/
        bottom_bar_renderer.dart
        material_bottom_bar_renderer.dart
        floating_pill_bottom_bar_renderer.dart
        bottom_bar_item.dart

      theme/
        bottom_shell_theme.dart
        bottom_shell_theme_data.dart
        bottom_shell_tokens.dart

      accessibility/
        bottom_shell_semantics.dart

      utils/
        typedefs.dart
        assertions.dart

  example/
    lib/
      main.dart
      examples/
        basic_shell_example.dart
        nested_navigation_example.dart
        badge_example.dart
        floating_pill_example.dart
        custom_renderer_example.dart

  test/
    shell/
      bottom_shell_controller_test.dart
      bottom_shell_test.dart

    navigation/
      branch_navigator_test.dart
      back_button_handler_test.dart

    renderers/
      material_bottom_bar_renderer_test.dart
      floating_pill_bottom_bar_renderer_test.dart

    accessibility/
      bottom_shell_semantics_test.dart

  README.md
  CHANGELOG.md
  LICENSE
  pubspec.yaml
```

---

## 20. Public Export Dosyası

```dart
library bottom_shell_nav;

export 'src/shell/bottom_shell.dart';
export 'src/shell/bottom_shell_controller.dart';

export 'src/branch/bottom_branch.dart';
export 'src/branch/bottom_destination.dart';
export 'src/branch/branch_badge.dart';

export 'src/policies/branch_persistence_policy.dart';
export 'src/policies/re_tap_behavior.dart';
export 'src/policies/keyboard_policy.dart';
export 'src/policies/safe_area_policy.dart';

export 'src/appearance/bottom_shell_appearance.dart';
export 'src/appearance/bottom_label_behavior.dart';
export 'src/appearance/bottom_bar_animation_style.dart';

export 'src/renderers/bottom_bar_renderer.dart';
export 'src/renderers/material_bottom_bar_renderer.dart';
export 'src/renderers/floating_pill_bottom_bar_renderer.dart';

export 'src/theme/bottom_shell_theme.dart';
export 'src/theme/bottom_shell_theme_data.dart';
```

Kullanıcı import'u:

```dart
import 'package:bottom_shell_nav/bottom_shell_nav.dart';
```

---

## 21. Test Stratejisi

### Unit Testler

- `BottomShellController` selectedIndex değişimi
- Branch selection
- Reselect behavior
- Guard behavior
- Persistence policy
- Adaptive policy
- Badge model
- Appearance config

### Widget Testler

- Default Material renderer render ediliyor mu?
- Floating pill renderer render ediliyor mu?
- Seçili item doğru gösteriliyor mu?
- Badge doğru gösteriliyor mu?
- Custom barBuilder çalışıyor mu?
- SafeArea uygulanıyor mu?
- Keyboard policy çalışıyor mu?
- Reselect pop-to-root tetikleniyor mu?
- Lazy branch loading çalışıyor mu?

### Navigation Testleri

- Her tab kendi Navigator'ına sahip mi?
- Tab değişince stack korunuyor mu?
- Detail sayfaya gidince bottom bar kalıyor mu?
- Android back davranışı doğru mu?
- Aynı tab'a tekrar basınca root'a dönüyor mu?

### Accessibility Testleri

- Semantics label var mı?
- Selected state screen reader tarafından anlaşılır mı?
- Tooltip doğru mu?
- Minimum touch target korunuyor mu?
- Text scale büyüdüğünde overflow oluyor mu?
- RTL layout bozuluyor mu?

### Golden Testler

- Material 3 light mode
- Material 3 dark mode
- Floating pill light mode
- Floating pill dark mode
- Badge state
- Selected / unselected item
- High contrast
- Text scale 2.0

---

## 22. Sprint Planı

## Sprint 1 — Ürün ve API

Amaç:

```text
Kod yazmadan önce ürünün ne olduğunu ve API'nin nasıl görüneceğini netleştirmek.
```

Görevler:

- Paket ismi seçilecek
- PRD hazırlanacak
- Public API sözleşmesi çıkarılacak
- README ilk taslağı yazılacak
- Basic usage örneği yazılacak
- Nested navigation örneği tasarlanacak
- Modern renderer kararları netleşecek

Çıktı:

```text
Paketin ne olduğu, ne olmadığı ve nasıl kullanılacağı netleşmiş olacak.
```

---

## Sprint 2 — Core Shell

Amaç:

```text
BottomShell'in çalışan ilk versiyonunu yapmak.
```

Görevler:

- `BottomShellController` yazılacak
- `BottomBranch` modeli yazılacak
- `BottomDestination` modeli yazılacak
- Branch Navigator yapısı kurulacak
- IndexedStack persistence yapılacak
- Lazy branch loading yapılacak
- Basit 3 tab example hazırlanacak

Çıktı:

```text
3 tab'lı örnek uygulamada tab state korunacak.
```

---

## Sprint 3 — Material Renderer ve Floating Pill

Amaç:

```text
Paketi hem kullanılabilir hem de modern görünümlü hale getirmek.
```

Görevler:

- `MaterialBottomBarRenderer` yazılacak
- `FloatingPillBottomBarRenderer` yazılacak
- Selected / unselected icon desteği eklenecek
- Label behavior eklenecek
- Badge desteği eklenecek
- Animation style eklenecek
- Dark mode uyumu kontrol edilecek

Çıktı:

```text
Paket sıfır custom UI ile hem profesyonel hem şık görünecek.
```

---

## Sprint 4 — Navigation Behavior

Amaç:

```text
Gerçek uygulama davranışlarını çözmek.
```

Görevler:

- Android back button davranışı
- Aynı tab'a tekrar basınca popToRoot
- Navigator key desteği
- Branch lifecycle testleri
- Reselect behavior testleri
- Detail route içinde bottom bar'ın kalıcı olması

Çıktı:

```text
Nested navigation senaryosu stabil çalışacak.
```

---

## Sprint 5 — SafeArea, Keyboard ve Accessibility

Amaç:

```text
Paketi gerçek cihazlarda güvenilir hale getirmek.
```

Görevler:

- SafeArea policy
- Keyboard policy
- Tooltip desteği
- Semantics desteği
- Text scale testleri
- RTL testleri
- Minimum touch target kontrolü

Çıktı:

```text
Paket yalnızca güzel değil, kaliteli ve erişilebilir olacak.
```

---

## Sprint 6 — Test, README ve Yayın

Amaç:

```text
Pub.dev'e çıkabilecek kaliteye getirmek.
```

Görevler:

- Unit testler
- Widget testler
- Golden testler
- Example app tamamlanacak
- README tamamlanacak
- CHANGELOG yazılacak
- LICENSE eklenecek
- pubspec metadata düzenlenecek
- `flutter analyze`
- `flutter test`
- `dart pub publish --dry-run`

Çıktı:

```text
bottom_shell_nav v0.1.0 yayına hazır olacak.
```

---

## 23. Başarı Kriterleri

İlk sürüm için başarı kriterleri:

- 5 dakikada kurulabiliyor mu?
- README ile kullanım anlaşılabiliyor mu?
- 3 tab'lı uygulamada state korunuyor mu?
- Detail sayfasında bottom bar kalıyor mu?
- Aynı tab'a tekrar basınca root'a dönebiliyor mu?
- SafeArea problemi çıkarmıyor mu?
- Keyboard açılınca bar doğru davranıyor mu?
- Floating pill modern görünüyor mu?
- Custom renderer yapılabiliyor mu?
- Dark mode düzgün mü?
- Badge düzgün çalışıyor mu?
- Accessibility temel seviyede doğru mu?
- Pub.dev sayfası profesyonel görünüyor mu?

---

## 24. README İçeriği

README şu sırayla hazırlanmalıdır:

```text
1. Headline
2. Kısa value proposition
3. GIF / screenshot alanı
4. Not another animated bottom bar mesajı
5. Problem açıklaması
6. Basic usage
7. Floating pill usage
8. Nested navigation example
9. Reselect behavior
10. Badge support
11. Custom renderer
12. SafeArea ve keyboard policy
13. Accessibility
14. Router adapters roadmap
15. API overview
16. Roadmap
17. FAQ
18. License
```

README ilk ekran mesajı:

```text
Not another animated bottom bar.
A modern navigation shell for real Flutter apps.

Preserve tab state, manage nested navigation, handle SafeAreas,
ship beautiful Material 3 and floating pill bars, and keep your app navigation clean.
```

---

## 25. Pub.dev Topics

Önerilen topics:

```text
bottom-navigation
navigation-bar
navigation-shell
nested-navigation
go-router
auto-route
state-persistence
adaptive-layout
navigation-rail
material3
accessibility
```

---

## 26. Riskler ve Çözüm Planı

| Risk | Açıklama | Çözüm |
|---|---|---|
| API şişmesi | Çok fazla parametre paketi karmaşıklaştırabilir | Appearance, policy ve renderer sınıflarıyla ayrıştır |
| Router kırılmaları | `go_router` ve `auto_route` sürümleri değişebilir | Adapter paketlerini core'dan ayrı tut |
| Performans | Her tab Navigator tutmak bellek tüketebilir | Lazy load ve dispose policy sun |
| SafeArea sorunları | Bottom bar paketlerinde sık hata çıkar | İlk sürümden itibaren test et |
| Sadece görsel paket gibi algılanmak | Pazar zaten dolu | Mesajı "navigation shell" olarak konumlandır |
| Görsellik zayıf kalırsa dikkat çekmeyebilir | Pub.dev'de ilk izlenim önemli | Material 3 + Floating Pill renderer ile çık |
| Accessibility unutulabilir | Profesyonel algıyı düşürür | Semantics ve tooltip ilk sürümde olsun |
| Çok büyük MVP | Yayına çıkmayı geciktirir | v0.1.0 scope'u sıkı tut |

---

## 27. Yapay Zeka İçin Profesyonel Promptlar

## Prompt 1 — PRD Hazırlama

```text
You are a senior Flutter package architect and product strategist.

I want to build a pub.dev package named bottom_shell_nav.

This package is not just another animated bottom navigation bar. It is a route-aware, persistent, adaptive and modern bottom navigation shell for Flutter apps.

The package should solve these problems:

- Preserve tab state when switching between tabs.
- Support nested navigation with a separate Navigator per tab.
- Keep the bottom bar visible while navigating inside a tab.
- Support reselect behavior such as pop-to-root.
- Handle SafeArea, keyboard, notch and bottom inset behavior correctly.
- Provide accessible defaults with semantics, tooltips and selected state.
- Provide modern visual renderers such as Material 3 and Floating Pill.
- Allow custom bottom bar renderers.
- Keep the core package router-agnostic.
- Provide go_router and auto_route integrations later as separate adapter packages.

Create a professional Product Requirement Document for the first MVP.

The MVP should include:

- BottomShell
- BottomBranch
- BottomDestination
- BottomShellController
- BranchBadge
- ReTapBehavior
- BranchPersistencePolicy
- Material 3 default renderer
- Floating Pill renderer
- Custom barBuilder
- IndexedStack persistence
- Lazy branch loading
- SafeArea policy
- Keyboard policy
- Basic accessibility support
- Example app requirements
- Test strategy
- Non-goals
- Future roadmap

The first version must not include go_router, auto_route, Cupertino renderer, glass blur effects, FAB notch, or many visual styles.

Please produce:

- Product vision
- Problem statement
- Target users
- MVP scope
- Non-goals
- Public API proposal
- Folder structure
- Example usage
- Test plan
- Roadmap
- Pub.dev positioning
```

---

## Prompt 2 — Public API Tasarımı

```text
You are a senior Dart and Flutter API designer.

Design the public API for a Flutter package named bottom_shell_nav.

The package should provide a route-aware, persistent, adaptive and modern bottom navigation shell for Flutter apps.

Core requirements:

- BottomShell
- BottomBranch
- BottomDestination
- BottomShellController
- BranchBadge
- ReTapBehavior
- BranchPersistencePolicy
- SafeAreaPolicy
- KeyboardPolicy
- BottomShellAppearance
- BottomBarRenderer
- MaterialBottomBarRenderer
- FloatingPillBottomBarRenderer
- Custom barBuilder support

Design goals:

- Simple API for basic usage.
- Powerful API for advanced nested navigation.
- Router-agnostic core.
- No go_router or auto_route dependency in the core package.
- Dart 3 and null safety friendly.
- Const constructors where possible.
- Easy theming.
- Minimal public surface.
- Avoid constructor parameter explosion.

Please output:

- Public classes
- Constructor signatures
- Type definitions
- Example usage
- Advanced usage
- Design rationale
- What should remain private
- Export file recommendation
- Breaking change risks
```

---

## Prompt 3 — Core Implementation

```text
You are a senior Flutter package engineer.

Implement the first MVP of a Flutter package named bottom_shell_nav.

MVP scope:

- BottomShell
- BottomBranch
- BottomDestination
- BottomShellController
- BranchBadge
- ReTapBehavior
- BranchPersistencePolicy
- SafeAreaPolicy
- KeyboardPolicy
- MaterialBottomBarRenderer
- FloatingPillBottomBarRenderer
- Custom barBuilder
- IndexedStack persistence
- Lazy branch loading
- Separate Navigator per branch
- Basic Android back button behavior
- Basic accessibility semantics

Technical requirements:

- Core package must not depend on go_router or auto_route.
- Use Flutter best practices.
- Use const constructors where possible.
- Keep widgets composable.
- Avoid unnecessary rebuilds.
- Make code pub.dev friendly.
- Organize internal files under lib/src.
- Export only necessary files from lib/bottom_shell_nav.dart.
- Add documentation comments.
- Include simple example app.
- Include basic unit and widget tests.

Please generate:

- Folder structure
- Dart implementation for each file
- Example usage
- Test examples
- Notes for future extension
```

---

## Prompt 4 — Floating Pill Renderer

```text
You are a senior Flutter UI engineer.

Design and implement a modern Floating Pill bottom bar renderer for a package named bottom_shell_nav.

The renderer should be visually modern but not overengineered.

Requirements:

- Floating pill container
- Rounded corners
- SafeArea awareness
- Selected pill indicator
- Smooth but subtle animation
- Label behavior options
- Badge support
- Dark mode support
- Theme support
- Minimum touch target
- Semantics labels
- RTL support
- Text scale handling
- No blur effect in the first version

API idea:

FloatingPillBottomBarRenderer(
  height: 72,
  borderRadius: 32,
  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
  labelBehavior: BottomLabelBehavior.onlySelected,
  animationStyle: BottomBarAnimationStyle.smooth,
)

Please output:

- Widget implementation
- Theme token usage
- Animation strategy
- Accessibility handling
- Edge cases
- Widget tests
- Golden test recommendations
```

---

## Prompt 5 — go_router Adapter

```text
You are a senior Flutter routing expert.

Design a separate adapter package named bottom_shell_nav_go_router.

This package depends on:

- bottom_shell_nav
- go_router

Goal:

Allow go_router users to use bottom_shell_nav with StatefulShellRoute and navigationShell.

Requirements:

- BottomShellGoRouterAdapter
- Accept StatefulNavigationShell navigationShell
- Accept BottomDestination list
- Sync currentIndex with navigationShell.currentIndex
- Use navigationShell.goBranch(index) when selecting tabs
- Support reselect behavior
- Support custom appearance and renderer
- Keep this adapter thin
- Do not duplicate core navigation logic

Please output:

- Public API
- Implementation code
- Example router setup
- Example usage
- README section
- Tests
- Explanation of why this is a separate package
```

---

## Prompt 6 — README Yazımı

```text
You are an expert open-source package maintainer and technical writer.

Write a professional README.md for a Flutter package named bottom_shell_nav.

The package is not just another animated bottom navigation bar. It is a modern navigation shell for real Flutter apps.

Core value:

- Preserve tab state.
- Support nested navigation.
- Keep bottom bar visible inside tab routes.
- Handle SafeArea and keyboard behavior.
- Provide Material 3 and Floating Pill renderers.
- Support accessibility.
- Allow custom renderers.
- Support router adapters later.

README sections:

- Strong headline
- Short value proposition
- Screenshot/GIF placeholder
- Why not another bottom bar?
- Installation
- Basic usage
- Floating pill usage
- Nested navigation example
- Reselect behavior
- Badge support
- Custom renderer
- SafeArea and keyboard behavior
- Accessibility
- Roadmap
- FAQ
- License

Tone:

- Professional
- Developer-focused
- Clear
- Not too marketing-heavy
- Easy to scan

Also include:

- Pub.dev short description
- Suggested topics
- Before/After comparison
```

---

## Prompt 7 — Test Stratejisi

```text
You are a senior Flutter testing engineer.

Create a complete test strategy for a Flutter package named bottom_shell_nav.

Features:

- BottomShell
- BottomBranch
- BottomDestination
- BottomShellController
- Separate Navigator per branch
- IndexedStack persistence
- Lazy branch loading
- Reselect behavior
- Android back handling
- Material 3 renderer
- Floating Pill renderer
- Badge support
- SafeArea policy
- Keyboard policy
- Accessibility semantics

Please produce:

- Unit test plan
- Widget test plan
- Golden test plan
- Integration test plan
- Accessibility test plan
- Edge cases
- Example test files
- CI workflow recommendation
- Coverage goals

Important scenarios:

- Tab state is preserved.
- Branch stack is preserved.
- Detail page keeps bottom bar visible.
- Reselect pops to root.
- Back button pops current branch first.
- Lazy branch loading works.
- Custom renderer receives correct state.
- Badge renders correctly.
- Semantics labels exist.
- Text scale does not break layout.
```

---

## 28. Nihai Karar

Bu rapor ve planlama sonucunda çıkarılacak ürün şu olmalıdır:

```text
bottom_shell_nav
```

Ürün kimliği:

```text
Modern görünümlü, mimari olarak güçlü, router-dostu Flutter bottom navigation shell.
```

İlk MVP'nin özü:

```text
BottomShell + BottomBranch + her tab için ayrı Navigator + IndexedStack persistence
+ Material 3 renderer + Floating Pill renderer + SafeArea + reselect behavior.
```

Bu ürün doğru yapılırsa, pazardaki "güzel ama sadece bar çizen" paketlerle "güçlü ama ağır persistent navigation" paketleri arasında güçlü bir boşluğu doldurabilir.

En önemli stratejik karar:

```text
Görsel olarak modern olacağız.
Ama ana değerimiz navigation mimarisi olacak.
```

