import 'package:auto_route/auto_route.dart';
import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AutoRouteModeExampleApp());
}

class AutoRouteModeExampleApp extends StatelessWidget {
  AutoRouteModeExampleApp({super.key});

  final RootStackRouter _router = RootStackRouter.build(
    routes: [
      AutoRoute(
        page: PageInfo.builder(
          'ShellRoute',
          builder: (context, data) => const AutoRouteShellPage(),
        ),
        path: '/',
        initial: true,
        children: [
          AutoRoute(
            page: PageInfo.builder(
              'HomeRoute',
              builder: (context, data) =>
                  const AutoRouteBranchPage(title: 'Home'),
            ),
            path: 'home',
            initial: true,
          ),
          AutoRoute(
            page: PageInfo.builder(
              'SearchRoute',
              builder: (context, data) =>
                  const AutoRouteBranchPage(title: 'Search'),
            ),
            path: 'search',
          ),
          AutoRoute(
            page: PageInfo.builder(
              'ProfileRoute',
              builder: (context, data) =>
                  const AutoRouteBranchPage(title: 'Profile'),
            ),
            path: 'profile',
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'bottom_shell_nav auto_route demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: _router.config(),
    );
  }
}

class AutoRouteShellPage extends StatelessWidget {
  const AutoRouteShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        PageRouteInfo.named('HomeRoute'),
        PageRouteInfo.named('SearchRoute'),
        PageRouteInfo.named('ProfileRoute'),
      ],
      builder: (context, child) {
        return BottomShell.autoRoute(
          tabsRouter: AutoTabsRouter.of(context),
          appearance: BottomShellAppearance.floatingPill(),
          adaptivePolicy: const AdaptiveNavigationPolicy.automatic(),
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
              badge: BranchBadge.dot(),
            ),
          ],
          child: child,
        );
      },
    );
  }
}

class AutoRouteBranchPage extends StatefulWidget {
  const AutoRouteBranchPage({required this.title, super.key});

  final String title;

  @override
  State<AutoRouteBranchPage> createState() => _AutoRouteBranchPageState();
}

class _AutoRouteBranchPageState extends State<AutoRouteBranchPage> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          Text(
            'AutoTabsRouter branch: ${widget.title}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Text('Counter state: $_counter'),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => setState(() => _counter++),
            icon: const Icon(Icons.add),
            label: const Text('Increment'),
          ),
        ],
      ),
    );
  }
}
