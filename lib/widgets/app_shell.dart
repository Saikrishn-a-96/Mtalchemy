import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../data/brand_data.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'common.dart';

/// Public site chrome: adaptive top navigation (AppBar + Drawer) and footer.
class AppShell extends StatefulWidget {
  final Widget child;
  final String route;
  final bool showFooter;
  const AppShell({
    super.key,
    required this.child,
    required this.route,
    this.showFooter = true,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _go(String route) {
    if (ModalRoute.of(context)?.settings.name == route) return;
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final wide = !isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.bg,
      drawer: wide ? null : _MobileDrawer(onGo: _go),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _TopBar(
          route: widget.route,
          state: state,
          wide: wide,
          onMenu: () => _scaffoldKey.currentState?.openDrawer(),
          onGo: _go,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.child,
            if (widget.showFooter) const AppFooter(),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final String route;
  final AppState state;
  final bool wide;
  final VoidCallback onMenu;
  final ValueChanged<String> onGo;

  const _TopBar({
    required this.route,
    required this.state,
    required this.wide,
    required this.onMenu,
    required this.onGo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: PageWidth(
        max: 1320,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: SizedBox(
          height: 72,
          child: Row(
            children: [
              _Logo(onTap: () => onGo('/')),
              const SizedBox(width: 28),
              if (wide)
                Expanded(
                  child: Row(
                    children: [
                      for (var i = 0; i < Brand.navLabels.length; i++)
                        _NavLink(
                          label: Brand.navLabels[i],
                          active: route == Brand.navRoutes[i],
                          onTap: () => onGo(Brand.navRoutes[i]),
                        ),
                    ],
                  ),
                )
              else
                const Spacer(),
              const SizedBox(width: 12),
              _CartButton(onGo: onGo, count: state.cartCount),
              const SizedBox(width: 8),
              if (wide) ...[
                const SizedBox(width: 4),
                _AccountButton(state: state, onGo: onGo),
              ] else
                IconButton(
                  onPressed: onMenu,
                  icon: const Icon(Icons.menu_rounded),
                  tooltip: 'Menu',
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final VoidCallback? onTap;
  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.deepBlue, AppColors.purple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepBlue.withValues(alpha: .28),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                'MT',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  letterSpacing: .5,
                ),
              ),
            ),
          ),
          const SizedBox(width: 11),
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MT ALCHEMY',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16.5,
                  letterSpacing: .6,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'CONSULTANCY · TRAINING · OD',
                style: TextStyle(
                  fontSize: 9.5,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavLink({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.active
        ? AppColors.deepBlue
        : _hover
            ? AppColors.indigo
            : AppColors.muted;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontWeight: widget.active ? FontWeight.w800 : FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: 200.ms,
                height: 2.5,
                width: widget.active || _hover ? 26 : 0,
                decoration: BoxDecoration(
                  color: widget.active ? AppColors.softYellow : AppColors.purple,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CartButton extends StatelessWidget {
  final int count;
  final ValueChanged<String> onGo;
  const _CartButton({required this.count, required this.onGo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: () => onGo('/cart'),
          tooltip: 'Cart',
          icon: const Icon(Icons.shopping_bag_outlined, size: 23),
        ),
        if (count > 0)
          Positioned(
            right: 6,
            top: 6,
            child: AnimatedContainer(
              duration: 250.ms,
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.purple,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: Colors.white, width: 1.6),
              ),
              child: Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AccountButton extends StatelessWidget {
  final AppState state;
  final ValueChanged<String> onGo;
  const _AccountButton({required this.state, required this.onGo});

  @override
  Widget build(BuildContext context) {
    final signedIn = state.isSignedIn;

    return PopupMenuButton<String>(
      tooltip: 'Account & demo roles',
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      onSelected: (v) {
        if (v == 'signin') {
          onGo('/login');
        } else if (v == 'signout') {
          state.signOut();
        } else if (v.startsWith('role:')) {
          state.switchRole(v.substring(5));
        } else {
          onGo(v);
        }
      },
      itemBuilder: (context) => [
        if (!signedIn) ...[
          const PopupMenuItem(
            value: 'signin',
            child: Row(children: [
              Icon(Icons.login_rounded, size: 18),
              SizedBox(width: 10),
              Text('Sign in / Register'),
            ]),
          ),
        ] else ...[
          PopupMenuItem(
            enabled: false,
            child: Text(
              '${state.userName} · ${state.userRole}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
          ),
          const PopupMenuItem(
              value: '/dashboard', child: Text('Learner dashboard')),
          const PopupMenuItem(
              value: '/employer', child: Text('Employer dashboard')),
          const PopupMenuItem(value: '/admin', child: Text('Admin portal')),
          const PopupMenuDivider(),
          const PopupMenuItem(value: 'role:Guest', child: Text('Demo as Guest')),
          const PopupMenuItem(
              value: 'role:Individual Learner',
              child: Text('Demo as Individual')),
          const PopupMenuItem(
              value: 'role:Employer', child: Text('Demo as Employer')),
          const PopupMenuItem(value: 'role:Trainer', child: Text('Demo as Trainer')),
          const PopupMenuItem(
              value: 'role:Administrator', child: Text('Demo as Admin')),
          const PopupMenuDivider(),
          const PopupMenuItem(
            value: 'signout',
            child: Row(children: [
              Icon(Icons.logout_rounded, size: 18),
              SizedBox(width: 10),
              Text('Sign out'),
            ]),
          ),
        ],
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.deepBlue,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.person_rounded, size: 17, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              signedIn ? state.userName!.split(' ').first : 'Login / Register',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13.5,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 16, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _MobileDrawer extends StatelessWidget {
  final ValueChanged<String> onGo;
  const _MobileDrawer({required this.onGo});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            const SizedBox(height: 6),
            _Logo(onTap: () {
              Navigator.pop(context);
              onGo('/');
            }),
            const SizedBox(height: 18),
            const Divider(),
            for (var i = 0; i < Brand.navLabels.length; i++)
              ListTile(
                selected:
                    Brand.navRoutes[i] == ModalRoute.of(context)?.settings.name,
                selectedColor: AppColors.deepBlue,
                title: Text(
                  Brand.navLabels[i],
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                onTap: () {
                  Navigator.pop(context);
                  onGo(Brand.navRoutes[i]);
                },
              ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text('Cart',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              trailing: state.cartCount > 0
                  ? Chip(label: Text('${state.cartCount}'))
                  : null,
              onTap: () {
                Navigator.pop(context);
                onGo('/cart');
              },
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Learner Dashboard',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(context);
                onGo('/dashboard');
              },
            ),
            ListTile(
              leading: const Icon(Icons.business_outlined),
              title: const Text('Employer Portal',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(context);
                onGo('/employer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings_outlined),
              title: const Text('Admin Portal',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                Navigator.pop(context);
                onGo('/admin');
              },
            ),
            const SizedBox(height: 10),
            PrimaryButton(
              label: state.isSignedIn ? 'Sign out' : 'Login / Register',
              wide: true,
              onPressed: () {
                Navigator.pop(context);
                state.isSignedIn ? state.signOut() : onGo('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.deepBlue,
      child: PageWidth(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
        child: ResponsiveBuilder(
          builder: (context, type) {
            final stacked = type == ScreenType.mobile;
            final about = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'MT ALCHEMY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    letterSpacing: .8,
                  ),
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 340),
                  child: Text(
                    Brand.tagline,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: .72),
                      height: 1.6,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: .35)),
                  ),
                  child: const Text(
                    'PROTOTYPE · SAMPLE DATA · NO REAL TRANSACTIONS',
                    style: TextStyle(
                      color: AppColors.softYellow,
                      fontSize: 10,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                _ContactRow(
                    icon: Icons.mail_outline_rounded, text: Brand.email),
                const SizedBox(height: 8),
                _ContactRow(icon: Icons.phone_outlined, text: Brand.phone),
              ],
            );

            final links = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FooterHeading('EXPLORE'),
                for (var i = 0; i < Brand.navLabels.length; i++)
                  _FooterLink(
                    label: Brand.navLabels[i],
                    onTap: () =>
                        Navigator.pushNamed(context, Brand.navRoutes[i]),
                  ),
              ],
            );

            final portals = Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FooterHeading('PORTALS'),
                _FooterLink(
                    label: 'Login / Register',
                    onTap: () => Navigator.pushNamed(context, '/login')),
                _FooterLink(
                    label: 'Learner Dashboard',
                    onTap: () => Navigator.pushNamed(context, '/dashboard')),
                _FooterLink(
                    label: 'Employer Portal',
                    onTap: () => Navigator.pushNamed(context, '/employer')),
                _FooterLink(
                    label: 'Trainer Space',
                    onTap: () => Navigator.pushNamed(context, '/employer')),
                _FooterLink(
                    label: 'Admin Portal',
                    onTap: () => Navigator.pushNamed(context, '/admin')),
              ],
            );

            if (stacked) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  about,
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: links),
                      Expanded(child: portals),
                    ],
                  ),
                ],
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 5, child: about),
                const SizedBox(width: 40),
                Expanded(flex: 3, child: links),
                const SizedBox(width: 40),
                Expanded(flex: 3, child: portals),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _FooterHeading extends StatelessWidget {
  final String text;
  const _FooterHeading(this.text);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.softYellow,
            fontWeight: FontWeight.w800,
            fontSize: 12,
            letterSpacing: 1.6,
          ),
        ),
      );
}

class _FooterLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _FooterLink({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: InkWell(
          onTap: onTap,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .8),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _ContactRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Icon(icon, size: 16, color: AppColors.softYellow),
          const SizedBox(width: 9),
          Text(
            text,
            style: TextStyle(
              color: Colors.white.withValues(alpha: .8),
              fontSize: 13.5,
            ),
          ),
        ],
      );
}
