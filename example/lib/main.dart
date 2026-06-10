import 'package:bottom_shell_nav/bottom_shell_nav.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CoreModeExampleApp());
}

/// All available appearance presets.
enum BarStyle {
  material('Material'),
  floatingPill('Floating Pill'),
  cupertino('Cupertino'),
  curved('Curved / Notched'),
  gNav('GNav Pill'),
  dotIndicator('Dot Indicator'),
  waterDrop('Water Drop'),
  flashy('Flashy'),
  bubble('Bubble'),
  convex('Convex FAB'),
  sliding('Sliding'),
  glow('Glow / Neon'),
  neumorphic('Neumorphic');

  const BarStyle(this.label);
  final String label;

  BottomShellAppearance toAppearance() {
    return switch (this) {
      BarStyle.material => const BottomShellAppearance.material(),
      BarStyle.floatingPill => BottomShellAppearance.floatingPill(),
      BarStyle.cupertino => const BottomShellAppearance.cupertino(),
      BarStyle.curved => BottomShellAppearance.curved(),
      BarStyle.gNav => BottomShellAppearance.gNav(),
      BarStyle.dotIndicator => BottomShellAppearance.dotIndicator(),
      BarStyle.waterDrop => BottomShellAppearance.waterDrop(),
      BarStyle.flashy => BottomShellAppearance.flashy(),
      BarStyle.bubble => BottomShellAppearance.bubble(),
      BarStyle.convex => BottomShellAppearance.convex(),
      BarStyle.sliding => BottomShellAppearance.sliding(),
      BarStyle.glow => BottomShellAppearance.glow(
        backgroundColor: const Color(0xFF1A1B26),
        surfaceColor: const Color(0xFFE9E6F2),
        surfacePadding: const EdgeInsets.all(6),
      ),
      BarStyle.neumorphic => BottomShellAppearance.neumorphic(),
    };
  }
}

class CoreModeExampleApp extends StatefulWidget {
  const CoreModeExampleApp({super.key});

  @override
  State<CoreModeExampleApp> createState() => _CoreModeExampleAppState();
}

class _CoreModeExampleAppState extends State<CoreModeExampleApp> {
  BarStyle _currentStyle = BarStyle.floatingPill;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bottom_shell_nav demo',
      restorationScopeId: 'bottom_shell_nav_core_demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: BottomShell(
        key: ValueKey(_currentStyle),
        restorationScopeId: 'core_shell',
        appearance: _currentStyle.toAppearance(),
        adaptivePolicy: const AdaptiveNavigationPolicy.automatic(
          extendedRailBreakpoint: 840,
          drawerBreakpoint: 1200,
        ),
        scrollToHidePolicy: const ScrollToHidePolicy.enabled(),
        scrollToTopPolicy: const ScrollToTopPolicy.enabled(),
        bodyTransition: const BottomShellBodyTransition.fade(),
        keyboardNavigationPolicy: const KeyboardNavigationPolicy.enabled(),
        hapticFeedbackPolicy: const HapticFeedbackPolicy.selectionClick(),
        selectionGuardPolicy: const SelectionGuardPolicy.showPending(),
        branches: [
          BottomBranch(
            id: 'home',
            destination: const BottomDestination(
              icon: Icons.home_outlined,
              selectedIcon: Icons.home,
              label: 'Home',
            ),
            builder: (_) => DemoBranchPage(
              title: 'Home',
              subtitle: 'Counter state stays alive when you switch tabs.',
              icon: Icons.home,
              currentStyle: _currentStyle,
              onStyleChanged: (style) =>
                  setState(() => _currentStyle = style),
            ),
          ),
          BottomBranch(
            id: 'tasks',
            destination: const BottomDestination(
              icon: Icons.checklist_outlined,
              selectedIcon: Icons.checklist,
              label: 'Tasks',
            ),
            builder: (_) => DemoBranchPage(
              title: 'Tasks',
              subtitle: 'Open a detail page and the bottom bar stays visible.',
              icon: Icons.checklist,
              itemCount: 8,
              currentStyle: _currentStyle,
              onStyleChanged: (style) =>
                  setState(() => _currentStyle = style),
            ),
          ),
          BottomBranch(
            id: 'alerts',
            destination: const BottomDestination(
              icon: Icons.notifications_outlined,
              selectedIcon: Icons.notifications,
              label: 'Alerts',
              badge: BranchBadge.count(8),
            ),
            builder: (_) => DemoBranchPage(
              title: 'Alerts',
              subtitle: 'Badges support count, dot and 99+ rendering.',
              icon: Icons.notifications,
              itemCount: 5,
              currentStyle: _currentStyle,
              onStyleChanged: (style) =>
                  setState(() => _currentStyle = style),
            ),
          ),
          BottomBranch(
            id: 'search',
            destination: const BottomDestination(
              icon: Icons.search_outlined,
              selectedIcon: Icons.search,
              label: 'Search',
            ),
            builder: (_) => DemoBranchPage(
              title: 'Search',
              subtitle: 'Search across all your items.',
              icon: Icons.search,
              itemCount: 6,
              currentStyle: _currentStyle,
              onStyleChanged: (style) =>
                  setState(() => _currentStyle = style),
            ),
          ),

          BottomBranch(
            id: 'profile',
            destination: const BottomDestination(
              icon: Icons.person_outline,
              selectedIcon: Icons.person,
              label: 'Profile',
            ),
            builder: (_) => DemoBranchPage(
              title: 'Profile',
              subtitle: 'Tap this selected tab again to pop back to root.',
              icon: Icons.person,
              itemCount: 3,
              currentStyle: _currentStyle,
              onStyleChanged: (style) =>
                  setState(() => _currentStyle = style),
            ),
          ),
        ],
      ),
    );
  }
}

class DemoBranchPage extends StatefulWidget {
  const DemoBranchPage({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.currentStyle,
    required this.onStyleChanged,
    this.itemCount = 4,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final int itemCount;
  final BarStyle currentStyle;
  final ValueChanged<BarStyle> onStyleChanged;

  @override
  State<DemoBranchPage> createState() => _DemoBranchPageState();
}

class _DemoBranchPageState extends State<DemoBranchPage> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
        children: [
          // Style picker
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<BarStyle>(
                      initialValue: widget.currentStyle,
                      decoration: const InputDecoration(
                        labelText: 'Bar Style',
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      items: [
                        for (final style in BarStyle.values)
                          DropdownMenuItem(
                            value: style,
                            child: Text(style.label),
                          ),
                      ],
                      onChanged: (style) {
                        if (style != null) widget.onStyleChanged(style);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: colors.primaryContainer,
              foregroundColor: colors.onPrimaryContainer,
              child: Icon(widget.icon),
            ),
            title: Text(widget.title),
            subtitle: Text(widget.subtitle),
          ),
          const SizedBox(height: 16),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Branch counter: $_counter',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () => setState(() => _counter++),
                    icon: const Icon(Icons.add),
                    label: const Text('Increment'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Nested routes', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          for (var index = 1; index <= widget.itemCount; index++)
            Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: Text(index.toString().padLeft(2, '0')),
                title: Text('${widget.title} item $index'),
                subtitle: const Text('Pushes inside this branch navigator.'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) =>
                          DemoDetailPage(title: '${widget.title} item $index'),
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

class DemoDetailPage extends StatelessWidget {
  const DemoDetailPage({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
        children: [
          Text(
            'This route was pushed inside the active branch navigator.',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          const Text(
            'The bottom bar remains visible, switching tabs preserves this '
            'branch stack, and tapping the active tab again pops back to root.',
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to branch root'),
          ),
        ],
      ),
    );
  }
}
