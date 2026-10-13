import 'package:flutter/material.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/commerce/cart_screen.dart';
import 'screens/commerce/checkout_screen.dart';
import 'screens/commerce/confirmation_screen.dart';
import 'screens/commerce/digital_library_screen.dart';
import 'screens/commerce/my_orders_screen.dart';
import 'screens/commerce/product_detail_screen.dart';
import 'screens/lms/certificate_screen.dart';
import 'screens/lms/course_detail_screen.dart';
import 'screens/lms/course_player_screen.dart';
import 'screens/lms/learner_dashboard_screen.dart';
import 'screens/lms/quiz_screen.dart';
import 'screens/portal/admin_portal_screen.dart';
import 'screens/portal/assign_course_screen.dart';
import 'screens/portal/employer_dashboard_screen.dart';
import 'screens/portal/employees_screen.dart';
import 'screens/portal/reports_screen.dart';
import 'screens/public/about_screen.dart';
import 'screens/public/contact_screen.dart';
import 'screens/public/home_screen.dart';
import 'screens/public/insights_screen.dart';
import 'screens/public/learning_hub_screen.dart';
import 'screens/public/services_screen.dart';
import 'screens/public/store_screen.dart';
import 'widgets/app_shell.dart';

/// Routes that use the role-based portal chrome instead of the public site shell.
const Set<String> portalRoutes = {
  '/dashboard',
  '/employer',
  '/employer/employees',
  '/employer/assign',
  '/employer/reports',
  '/admin',
};

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  final name = settings.name ?? '/';
  final Widget page = _buildPage(name, settings.arguments);

  return PageRouteBuilder<void>(
    settings: settings,
    transitionDuration: const Duration(milliseconds: 340),
    reverseTransitionDuration: const Duration(milliseconds: 240),
    pageBuilder: (_, _, _) => portalRoutes.contains(name)
        ? page
        : AppShell(route: name, child: page),
    transitionsBuilder: (_, animation, _, child) {
      final curved =
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.02), end: Offset.zero)
              .animate(curved),
          child: child,
        ),
      );
    },
  );
}

Widget _buildPage(String name, Object? arguments) {
  switch (name) {
    case '/':
      return const HomeScreen();
    case '/about':
      return const AboutScreen();
    case '/services':
      return const ServicesScreen();
    case '/upskilling':
      return const LearningHubScreen();
    case '/course':
      return CourseDetailScreen(course: arguments);
    case '/register':
      return const RegisterScreen();
    case '/login':
      return const LoginScreen();
    case '/dashboard':
      return const LearnerDashboardScreen();
    case '/player':
      return const CoursePlayerScreen();
    case '/quiz':
      return const QuizScreen();
    case '/certificate':
      return const CertificateScreen();
    case '/store':
      return const StoreScreen();
    case '/product':
      return ProductDetailScreen(product: arguments);
    case '/cart':
      return const CartScreen();
    case '/checkout':
      return const CheckoutScreen();
    case '/confirmation':
      return const ConfirmationScreen();
    case '/orders':
      return const MyOrdersScreen();
    case '/digital-library':
      return const DigitalLibraryScreen();
    case '/insights':
      return const InsightsScreen();
    case '/contact':
      return const ContactScreen();
    case '/employer':
      return const EmployerDashboardScreen();
    case '/employer/employees':
      return const EmployeesScreen();
    case '/employer/assign':
      return const AssignCourseScreen();
    case '/employer/reports':
      return const ReportsScreen();
    case '/admin':
      return const AdminPortalScreen();
    default:
      return const HomeScreen();
  }
}
