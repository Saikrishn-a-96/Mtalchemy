import 'package:flutter/material.dart';

import 'dart:ui' show PointerDeviceKind;

import 'routes.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MtAlchemyApp());
}

class MtAlchemyApp extends StatelessWidget {
  const MtAlchemyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Rebuild the whole app whenever prototype state changes (cart,
    // auth, enrolment, progress). This wires the ChangeNotifier-based
    // AppState singleton into the widget tree without extra packages.
    return ListenableBuilder(
      listenable: AppState.instance,
      builder: (context, _) => MaterialApp(
        title: 'MT Alchemy — Corporate Platform Prototype',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        onGenerateRoute: onGenerateRoute,
        initialRoute: '/',
        scrollBehavior: const MaterialScrollBehavior().copyWith(
          dragDevices: {
            PointerDeviceKind.mouse,
            PointerDeviceKind.touch,
            PointerDeviceKind.stylus,
            PointerDeviceKind.trackpad,
          },
        ),
      ),
    );
  }
}
