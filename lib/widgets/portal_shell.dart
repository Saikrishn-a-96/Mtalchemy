import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../state/app_state.dart';
import '../theme/app_theme.dart';

class PortalNavItem {
  final String label;
  final IconData icon;
  final String route;
  const PortalNavItem(this.label, this.icon, this.route);
}

/// Role-based portal chrome: fixed sidebar on desktop, drawer on mobile.
class PortalShell extends StatefulWidget {
  final String title;
  final String subtitle;
  final String activeRoute;
  final List<PortalNavItem> items;
  final Widget child;
  final String accentRoute;

  const PortalShell({
    super.key,
    required this.title,
    required this.subtitle,
    required this.activeRoute,
    required this.items,
    required this.child,
    this.accentRoute = '/',
  });

  @override
  State<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends State<PortalShell> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  Widget _navList(BuildContext context, {bool drawer = false}) {
    final state = AppState.instance;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 16),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.deepBlue, AppColors.purple],
                  ),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Center(
                  child: Text('MT',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13)),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('MT ALCHEMY',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: .5)),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.purpleSoft,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.purple.withValues(alpha: .25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(state.userName ?? 'Guest visitor',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: AppColors.ink)),
              const SizedBox(height: 2),
              Text(state.userRole,
                  style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.purple,
                      fontWeight: FontWeight.w700)),
            ],
          ),
        ),
        for (final item in widget.items)
          _SideTile(
            item: item,
            active: item.route == widget.activeRoute,
            onTap: () {
              if (drawer) Navigator.pop(context);
              if (item.route != widget.activeRoute) {
                Navigator.pushNamed(context, item.route);
              }
            },
          ),
        const SizedBox(height: 12),
        const Divider(),
        _SideTile(
          item: const PortalNavItem('Back to website', Icons.public_rounded, '/'),
          active: false,
          onTap: () {
            if (drawer) Navigator.pop(context);
            Navigator.pushNamedAndRemoveUntil(context, '/', (r) => false);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 980;
    final state = AppState.instance;

    return Scaffold(
      key: _key,
      backgroundColor: AppColors.bg,
      drawer: wide ? null : Drawer(child: SafeArea(child: _navList(context, drawer: true))),
      body: Row(
        children: [
          if (wide)
            Container(
              width: 264,
              height: double.infinity,
              color: AppColors.surface,
              child: SafeArea(child: _navList(context)),
            ),
          Expanded(
            child: Column(
              children: [
                Container(
                  color: AppColors.surface,
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: AppColors.border)),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 14, 24, 14),
                    child: Row(
                      children: [
                        if (!wide)
                          IconButton(
                            onPressed: () =>
                                _key.currentState?.openDrawer(),
                            icon: const Icon(Icons.menu_rounded),
                          ),
                        if (!wide) const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.title,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink)),
                              const SizedBox(height: 2),
                              Text(widget.subtitle,
                                  style: const TextStyle(
                                      fontSize: 13, color: AppColors.muted)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        _RoleChip(state.userRole),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            AppState.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/login', (r) => false);
                          },
                          tooltip: 'Sign out',
                          icon: const Icon(Icons.logout_rounded, size: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String role;
  const _RoleChip(this.role);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.softYellow.withValues(alpha: .2),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.softYellow),
        ),
        child: Text(
          role.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
            color: AppColors.deepBlue,
          ),
        ),
      );
}

class _SideTile extends StatefulWidget {
  final PortalNavItem item;
  final bool active;
  final VoidCallback onTap;
  const _SideTile(
      {required this.item, required this.active, required this.onTap});

  @override
  State<_SideTile> createState() => _SideTileState();
}

class _SideTileState extends State<_SideTile> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    final active = widget.active;
    final bg = active
        ? AppColors.deepBlue
        : _hover
            ? AppColors.bg
            : Colors.transparent;
    final fg = active ? Colors.white : AppColors.ink;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        cursor: SystemMouseCursors.click,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(11),
          child: AnimatedContainer(
            duration: 180.ms,
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Row(
              children: [
                Icon(widget.item.icon,
                    size: 19,
                    color: active ? AppColors.softYellow : AppColors.indigo),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    style: TextStyle(
                      color: fg,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (active)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.softYellow,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

