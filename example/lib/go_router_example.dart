import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(GoRouterModeExampleApp());
}

class GoRouterModeExampleApp extends StatelessWidget {
  GoRouterModeExampleApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/home',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return BottomShell.router(
            navigationShell: navigationShell,
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
                icon: Icons.notifications_outlined,
                selectedIcon: Icons.notifications,
                label: 'Alerts',
                badge: BranchBadge.dot(),
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
                builder: (context, state) =>
                    const RouterBranchPage(title: 'Home'),
                routes: [
                  GoRoute(
                    path: 'detail',
                    builder: (context, state) =>
                        const RouterDetailPage(title: 'Home detail'),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) =>
                    const RouterBranchPage(title: 'Search'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alerts',
                builder: (context, state) =>
                    const RouterBranchPage(title: 'Alerts'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) =>
                    const RouterBranchPage(title: 'Profile'),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'bottom_shell_nav go_router demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      routerConfig: _router,
    );
  }
}

class RouterBranchPage extends StatefulWidget {
  const RouterBranchPage({required this.title, super.key});

  final String title;

  @override
  State<RouterBranchPage> createState() => _RouterBranchPageState();
}

class _RouterBranchPageState extends State<RouterBranchPage> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          Text(
            'StatefulShellRoute branch: ${widget.title}',
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
          const SizedBox(height: 24),
          if (widget.title == 'Home')
            FilledButton.tonalIcon(
              onPressed: () => context.go('/home/detail'),
              icon: const Icon(Icons.open_in_new),
              label: const Text('Open go_router detail'),
            ),
        ],
      ),
    );
  }
}

class RouterDetailPage extends StatelessWidget {
  const RouterDetailPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'The bar is rendered by BottomShell.router.',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            const Text(
              'go_router owns the branch stacks; bottom_shell_nav owns the '
              'shared renderer, destinations and selection behavior.',
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home),
              label: const Text('Back to home root'),
            ),
          ],
        ),
      ),
    );
  }
}
