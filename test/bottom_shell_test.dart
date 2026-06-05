import 'dart:async';

import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('preserves branch state when switching tabs', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              builder: (_) => const _CounterPage(label: 'home'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                selectedIcon: Icons.search,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('increment home'));
    await tester.pump();
    expect(find.text('home count 1'), findsOneWidget);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);

    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(find.text('home count 1'), findsOneWidget);
  });

  testWidgets('keeps bottom bar visible in branch detail routes', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              builder: (_) => const _PushPage(label: 'home'),
            ),
            BottomBranch(
              id: 'profile',
              destination: const BottomDestination(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
              ),
              builder: (_) => const Text('profile root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('push home detail'));
    await tester.pumpAndSettle();

    expect(find.text('home detail'), findsOneWidget);
    expect(find.byTooltip('Profile'), findsOneWidget);
  });

  testWidgets('re-tapping active destination pops branch to root', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              builder: (_) => const _PushPage(label: 'home'),
            ),
            BottomBranch(
              id: 'profile',
              destination: const BottomDestination(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
              ),
              builder: (_) => const Text('profile root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('push home detail'));
    await tester.pumpAndSettle();
    expect(find.text('home detail'), findsOneWidget);

    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();

    expect(find.text('home root'), findsOneWidget);
    expect(find.text('home detail'), findsNothing);
  });

  testWidgets('restores selected branch with restorationScopeId', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        restorationScopeId: 'app',
        home: BottomShell(
          restorationScopeId: 'shell',
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);

    await tester.restartAndRestore();
    await tester.pumpAndSettle();

    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('controller exposes branch actions', (tester) async {
    final controller = BottomShellController();

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          controller: controller,
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const _PushPage(label: 'home'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('push home detail'));
    await tester.pumpAndSettle();
    expect(controller.canPopBranch(0), isTrue);

    expect(await controller.popToRoot(0), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('home root'), findsOneWidget);

    controller.select(1);
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('lazy loads branches only after visit', (tester) async {
    var homeInits = 0;
    var searchInits = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) {
                return _InitProbe(
                  onInit: () => homeInits++,
                  child: const Text('home root'),
                );
              },
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) {
                return _InitProbe(
                  onInit: () => searchInits++,
                  child: const Text('search root'),
                );
              },
            ),
          ],
        ),
      ),
    );

    expect(homeInits, 1);
    expect(searchInits, 0);

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();

    expect(searchInits, 1);
  });

  testWidgets('uses custom barBuilder state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
          barBuilder: (context, state) {
            return Row(
              children: [
                for (var i = 0; i < state.destinations.length; i++)
                  TextButton(
                    onPressed: () => state.onSelect(i),
                    child: Text(
                      '${state.destinations[i].label}:${state.selectedIndex}',
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );

    expect(find.text('Home:0'), findsOneWidget);
    await tester.tap(find.text('Search:0'));
    await tester.pump();
    expect(find.text('Search:1'), findsOneWidget);
  });

  testWidgets('renders floating pill selected state and badges', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          appearance: BottomShellAppearance.floatingPill(),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'alerts',
              destination: const BottomDestination(
                icon: Icons.notifications_outlined,
                selectedIcon: Icons.notifications,
                label: 'Alerts',
                badge: BranchBadge.count(120),
              ),
              builder: (_) => const Text('alerts root'),
            ),
            BottomBranch(
              id: 'tasks',
              destination: const BottomDestination(
                icon: Icons.checklist_outlined,
                selectedIcon: Icons.checklist,
                label: 'Tasks',
              ),
              builder: (_) => const Text('tasks root'),
            ),
            BottomBranch(
              id: 'profile',
              destination: const BottomDestination(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: 'Profile',
              ),
              builder: (_) => const Text('profile root'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('99+'), findsOneWidget);

    await tester.tap(find.byTooltip('Alerts'));
    await tester.pumpAndSettle();
    expect(find.text('Alerts'), findsOneWidget);
  });

  testWidgets('floating pill gives selected label extra width', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          appearance: BottomShellAppearance.floatingPill(),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'tasks',
              destination: const BottomDestination(
                icon: Icons.checklist_outlined,
                label: 'Tasks',
              ),
              builder: (_) => const Text('tasks root'),
            ),
            BottomBranch(
              id: 'alerts',
              destination: const BottomDestination(
                icon: Icons.notifications_outlined,
                label: 'Alerts',
              ),
              builder: (_) => const Text('alerts root'),
            ),
            BottomBranch(
              id: 'profile',
              destination: const BottomDestination(
                icon: Icons.person_outline,
                label: 'Profile',
              ),
              builder: (_) => const Text('profile root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Tasks'));
    await tester.pumpAndSettle();

    final row = tester.widgetList<Row>(find.byType(Row)).firstWhere((row) {
      return row.children.whereType<Expanded>().length == 4;
    });
    final selected = row.children.whereType<Expanded>().firstWhere(
      (expanded) => expanded.flex == 2,
    );

    expect(selected.flex, 2);
    expect(find.text('Tasks'), findsOneWidget);
  });

  testWidgets('adds semantics labels and selected state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.bySemanticsLabel('Home'), findsWidgets);
    expect(find.bySemanticsLabel('Search'), findsWidgets);

    await tester.tap(find.bySemanticsLabel('Search').first);
    await tester.pumpAndSettle();

    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('go_router mode switches with StatefulShellRoute', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return BottomShell.router(
              navigationShell: navigationShell,
              destinations: const [
                BottomDestination(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  label: 'Home',
                ),
                BottomDestination(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  label: 'Profile',
                ),
              ],
            );
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/home',
                  builder: (context, state) => const Text('router home'),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  builder: (context, state) => const Text('router profile'),
                ),
              ],
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    expect(find.text('router home'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('router profile'), findsOneWidget);
  });

  testWidgets('auto_route mode switches with AutoTabsRouter', (tester) async {
    final router = RootStackRouter.build(
      routes: [
        AutoRoute(
          page: PageInfo.builder(
            'ShellRoute',
            builder: (context, data) {
              return AutoTabsRouter(
                routes: const [
                  PageRouteInfo.named('HomeRoute'),
                  PageRouteInfo.named('ProfileRoute'),
                ],
                builder: (context, child) {
                  return BottomShell.autoRoute(
                    tabsRouter: AutoTabsRouter.of(context),
                    destinations: const [
                      BottomDestination(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: 'Home',
                      ),
                      BottomDestination(
                        icon: Icons.person_outline,
                        selectedIcon: Icons.person,
                        label: 'Profile',
                      ),
                    ],
                    child: child,
                  );
                },
              );
            },
          ),
          path: '/',
          initial: true,
          children: [
            AutoRoute(
              page: PageInfo.builder(
                'HomeRoute',
                builder: (context, data) => const Text('auto home'),
              ),
              path: 'home',
              initial: true,
            ),
            AutoRoute(
              page: PageInfo.builder(
                'ProfileRoute',
                builder: (context, data) => const Text('auto profile'),
              ),
              path: 'profile',
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router.config()));
    await tester.pumpAndSettle();
    expect(find.text('auto home'), findsOneWidget);

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('auto profile'), findsOneWidget);
  });

  testWidgets('adaptive policy switches bottom bar to NavigationRail', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 900,
          child: BottomShell(
            adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
              railBreakpoint: 500,
              extendedRailBreakpoint: 700,
            ),
            branches: [
              BottomBranch(
                id: 'home',
                destination: const BottomDestination(
                  icon: Icons.home_outlined,
                  label: 'Home',
                ),
                builder: (_) => const Text('home root'),
              ),
              BottomBranch(
                id: 'search',
                destination: const BottomDestination(
                  icon: Icons.search_outlined,
                  label: 'Search',
                ),
                builder: (_) => const Text('search root'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(
      tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
      isTrue,
    );
    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('custom rail builder receives adaptive state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: SizedBox(
          width: 900,
          child: BottomShell(
            adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
              railBreakpoint: 500,
              extendedRailBreakpoint: 700,
            ),
            railBuilder: (context, state) {
              return SizedBox(
                width: state.width,
                child: TextButton(
                  onPressed: () => state.onSelect(1),
                  child: Text('custom rail:${state.extended}'),
                ),
              );
            },
            branches: [
              BottomBranch(
                id: 'home',
                destination: const BottomDestination(
                  icon: Icons.home_outlined,
                  label: 'Home',
                ),
                builder: (_) => const Text('home root'),
              ),
              BottomBranch(
                id: 'search',
                destination: const BottomDestination(
                  icon: Icons.search_outlined,
                  label: 'Search',
                ),
                builder: (_) => const Text('search root'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('custom rail:true'), findsOneWidget);
    await tester.tap(find.text('custom rail:true'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('adaptive policy switches rail to drawer on wide screens', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1300, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
            railBreakpoint: 500,
            drawerBreakpoint: 1000,
          ),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(ListTile), findsNWidgets(2));

    await tester.tap(find.text('Search'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('custom drawer builder receives adaptive state', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1300, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
            railBreakpoint: 500,
            drawerBreakpoint: 1000,
          ),
          drawerBuilder: (context, state) {
            return SizedBox(
              width: state.width,
              child: TextButton(
                onPressed: () => state.onSelect(1),
                child: Text('custom drawer:${state.type.name}'),
              ),
            );
          },
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('custom drawer:drawer'), findsOneWidget);
    await tester.tap(find.text('custom drawer:drawer'));
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);
  });

  testWidgets('scroll-to-hide hides and shows the bottom bar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          scrollToHidePolicy: const ScrollToHidePolicy.enabled(
            threshold: 1,
            duration: Duration.zero,
          ),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => ListView(
                children: [
                  for (var index = 0; index < 40; index++)
                    SizedBox(height: 56, child: Text('home item $index')),
                ],
              ),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.byTooltip('Search'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -260));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Search'), findsNothing);

    await tester.drag(find.byType(ListView), const Offset(0, 260));
    await tester.pumpAndSettle();
    expect(find.byTooltip('Search'), findsOneWidget);
  });

  testWidgets('visibility controller hides and shows the bottom bar', (
    tester,
  ) async {
    final visibilityController = BottomShellVisibilityController();

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          navigationVisibilityController: visibilityController,
          scrollToHidePolicy: const ScrollToHidePolicy.enabled(
            duration: Duration.zero,
          ),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.byTooltip('Search'), findsOneWidget);

    visibilityController.hide();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Search'), findsNothing);

    visibilityController.show();
    await tester.pumpAndSettle();
    expect(find.byTooltip('Search'), findsOneWidget);
  });

  testWidgets('keyboard shortcuts switch destinations', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('search root'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pumpAndSettle();
    expect(find.text('home root'), findsOneWidget);
  });

  testWidgets('re-tapping root branch scrolls primary scrollable to top', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          scrollToTopPolicy: const ScrollToTopPolicy.enabled(
            duration: Duration.zero,
          ),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => ListView(
                children: [
                  for (var index = 0; index < 60; index++)
                    SizedBox(height: 56, child: Text('home row $index')),
                ],
              ),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.text('home row 0'), findsOneWidget);
    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('home row 0'), findsNothing);

    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(find.text('home row 0'), findsOneWidget);
  });

  testWidgets('scroll-to-top uses a registered branch controller', (
    tester,
  ) async {
    final registry = ScrollToTopRegistry();
    final scrollController = ScrollController();
    registry.register(0, scrollController);
    addTearDown(scrollController.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          scrollToTopRegistry: registry,
          scrollToTopPolicy: const ScrollToTopPolicy.enabled(
            duration: Duration.zero,
          ),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => ListView(
                controller: scrollController,
                children: [
                  for (var index = 0; index < 60; index++)
                    SizedBox(height: 56, child: Text('registry row $index')),
                ],
              ),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.drag(find.byType(ListView), const Offset(0, -900));
    await tester.pumpAndSettle();
    expect(find.text('registry row 0'), findsNothing);

    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    expect(find.text('registry row 0'), findsOneWidget);
  });

  testWidgets('disabled destination and guard block selection', (tester) async {
    var guardCalls = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          onBeforeSelect: (context, index, destination) {
            guardCalls++;
            return destination.label != 'Blocked';
          },
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'disabled',
              destination: const BottomDestination(
                icon: Icons.lock_outline,
                label: 'Disabled',
                enabled: false,
              ),
              builder: (_) => const Text('disabled root'),
            ),
            BottomBranch(
              id: 'blocked',
              destination: const BottomDestination(
                icon: Icons.block_outlined,
                label: 'Blocked',
              ),
              builder: (_) => const Text('blocked root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Disabled'));
    await tester.pumpAndSettle();
    expect(find.text('home root'), findsOneWidget);
    expect(guardCalls, 0);

    await tester.tap(find.byTooltip('Blocked'));
    await tester.pumpAndSettle();
    expect(find.text('home root'), findsOneWidget);
    expect(guardCalls, 1);
  });

  testWidgets('async guard shows pending state and reports blocked selection', (
    tester,
  ) async {
    final completer = Completer<bool>();
    final blocked = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          onBeforeSelect: (context, index, destination) => completer.future,
          onSelectionBlocked: (index, destination) =>
              blocked.add(destination.label),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Search'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(false);
    await tester.pumpAndSettle();

    expect(find.text('home root'), findsOneWidget);
    expect(blocked, ['Search']);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('rich guard can block and redirect selection', (tester) async {
    var redirected = false;
    final blocked = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          onSelectionGuard: (context, index, destination) {
            return BottomShellGuardDecision.redirect(
              reason: 'login-required',
              metadata: {'target': destination.label},
              redirect: () => redirected = true,
            );
          },
          onSelectionBlocked: (index, destination) {
            blocked.add(destination.label);
          },
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'profile',
              destination: const BottomDestination(
                icon: Icons.person_outline,
                label: 'Profile',
              ),
              builder: (_) => const Text('profile root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.byTooltip('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('home root'), findsOneWidget);
    expect(blocked, ['Profile']);
    expect(redirected, isTrue);
  });

  testWidgets('lifecycle and analytics hooks are called', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          onBranchLoaded: (index, destination) =>
              events.add('loaded:${destination.label}'),
          onBranchSelected: (index, destination) =>
              events.add('selected:${destination.label}'),
          onBranchReselected: (index, destination) =>
              events.add('reselected:${destination.label}'),
          onBranchPoppedToRoot: (index, destination) =>
              events.add('popped:${destination.label}'),
          onBranchEntered: (index, destination) =>
              events.add('entered:${destination.label}'),
          onBranchExited: (index, destination) =>
              events.add('exited:${destination.label}'),
          onBranchBecameActiveAgain: (index, destination) =>
              events.add('again:${destination.label}'),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const _PushPage(label: 'home'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(events, contains('loaded:Home'));

    await tester.tap(find.byTooltip('Search'));
    await tester.pumpAndSettle();
    expect(
      events,
      containsAll([
        'loaded:Search',
        'selected:Search',
        'exited:Home',
        'entered:Search',
      ]),
    );

    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('push home detail'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Home'));
    await tester.pumpAndSettle();

    expect(
      events,
      containsAll(['again:Home', 'reselected:Home', 'popped:Home']),
    );
  });

  testWidgets('reports core branch route changes', (tester) async {
    final routes = <String>[];
    final events = <BottomShellRouteEvent>[];

    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          onBranchRouteChanged: (index, route) {
            routes.add('$index:${route?.settings.name ?? 'root'}');
          },
          onBranchRouteEvent: events.add,
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const _NamedPushPage(),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('push named detail'));
    await tester.pumpAndSettle();

    expect(routes, contains('0:home-detail'));
    expect(
      events.map((event) => event.type),
      contains(BottomShellRouteEventType.push),
    );
    expect(events.map((event) => event.routeName), contains('home-detail'));
  });

  testWidgets('renders Cupertino renderer', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BottomShell(
          appearance: const BottomShellAppearance.cupertino(),
          branches: [
            BottomBranch(
              id: 'home',
              destination: const BottomDestination(
                icon: Icons.home_outlined,
                label: 'Home',
              ),
              builder: (_) => const Text('home root'),
            ),
            BottomBranch(
              id: 'search',
              destination: const BottomDestination(
                icon: Icons.search_outlined,
                label: 'Search',
              ),
              builder: (_) => const Text('search root'),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(CupertinoTabBar), findsOneWidget);
  });

  testWidgets('handles RTL and large text scale without exceptions', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: BottomShell(
              branches: [
                BottomBranch(
                  id: 'home',
                  destination: const BottomDestination(
                    icon: Icons.home_outlined,
                    label: 'Home',
                  ),
                  builder: (_) => const Text('home root'),
                ),
                BottomBranch(
                  id: 'search',
                  destination: const BottomDestination(
                    icon: Icons.search_outlined,
                    label: 'Search',
                  ),
                  builder: (_) => const Text('search root'),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.byTooltip('Search'), findsOneWidget);
  });
}

class _CounterPage extends StatefulWidget {
  const _CounterPage({required this.label});

  final String label;

  @override
  State<_CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<_CounterPage> {
  var _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('${widget.label} count $_count'),
        TextButton(
          onPressed: () => setState(() => _count++),
          child: Text('increment ${widget.label}'),
        ),
      ],
    );
  }
}

class _InitProbe extends StatefulWidget {
  const _InitProbe({required this.onInit, required this.child});

  final VoidCallback onInit;
  final Widget child;

  @override
  State<_InitProbe> createState() => _InitProbeState();
}

class _InitProbeState extends State<_InitProbe> {
  @override
  void initState() {
    super.initState();
    widget.onInit();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _PushPage extends StatelessWidget {
  const _PushPage({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('$label root'),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => Text('$label detail')),
            );
          },
          child: Text('push $label detail'),
        ),
      ],
    );
  }
}

class _NamedPushPage extends StatelessWidget {
  const _NamedPushPage();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('named root'),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                settings: const RouteSettings(name: 'home-detail'),
                builder: (_) => const Text('named detail'),
              ),
            );
          },
          child: const Text('push named detail'),
        ),
      ],
    );
  }
}
