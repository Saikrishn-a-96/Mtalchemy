import 'package:flutter/foundation.dart';

import '../data/models.dart';

/// Lightweight in-memory state for the prototype (no backend at Checkpoint 1).
class AppState extends ChangeNotifier {
  AppState._();
  static final AppState instance = AppState._();

  // --- Session -------------------------------------------------------------
  String? userName;
  String userRole = 'Guest';
  bool get isSignedIn => userName != null;

  void signIn({required String name, String role = 'Individual Learner'}) {
    userName = name;
    userRole = role;
    notifyListeners();
  }

  void switchRole(String role) {
    userRole = role;
    notifyListeners();
  }

  void signOut() {
    userName = null;
    userRole = 'Guest';
    notifyListeners();
  }

  // --- Cart ----------------------------------------------------------------
  final List<CartLine> cart = [];

  int get cartCount => cart.fold(0, (sum, l) => sum + l.qty);

  double get subtotal =>
      cart.fold(0, (sum, l) => sum + l.product.price * l.qty);

  double get shipping =>
      cart.any((l) => !l.product.isDigital) ? 15.0 : 0.0;

  double get total => subtotal + shipping;

  void addToCart(Product p, {int qty = 1}) {
    final idx = cart.indexWhere((l) => l.product.id == p.id);
    if (idx >= 0) {
      cart[idx].qty += qty;
    } else {
      cart.add(CartLine(p, qty));
    }
    notifyListeners();
  }

  void setQty(Product p, int qty) {
    final idx = cart.indexWhere((l) => l.product.id == p.id);
    if (idx < 0) return;
    if (qty <= 0) {
      cart.removeAt(idx);
    } else {
      cart[idx].qty = qty;
    }
    notifyListeners();
  }

  void clearCart() {
    cart.clear();
    notifyListeners();
  }

  // --- Learning ------------------------------------------------------------
  final Set<String> enrolled = {'eq-101'};
  String activeCourseId = 'eq-101';
  double activeProgress = 0.65;
  final Set<String> completedLessons = {'eq-101-l1', 'eq-101-l2'};
  bool certificateIssued = false;

  bool isEnrolled(String id) => enrolled.contains(id);

  void enrol(String id) {
    enrolled.add(id);
    activeCourseId = id;
    activeProgress = 0.0;
    notifyListeners();
  }

  void openCourse(String id) {
    activeCourseId = id;
    notifyListeners();
  }

  void markLessonComplete(double nextProgress) {
    activeProgress = nextProgress.clamp(0, 1);
    if (activeProgress >= 0.99) certificateIssued = true;
    notifyListeners();
  }

  // --- Orders (prototype records) -----------------------------------------
  final List<Map<String, dynamic>> orders = [
    {
      'id': '#MA1001',
      'date': '10 Sep 2026',
      'amount': 'RM120.00',
      'status': 'Paid',
      'items': 'EQ Journal Template Pack ×1, Mindfulness Card Deck ×1',
    },
    {
      'id': '#MA1002',
      'date': '12 Sep 2026',
      'amount': 'RM85.00',
      'status': 'Shipped',
      'items': 'Team Reflection Cards ×1',
    },
  ];

  final List<Map<String, String>> digitalLibrary = [
    {
      'name': 'Emotional Clarity Workbook',
      'purchased': '10 Sep 2026',
      'file': 'PDF · 62 pages · 8.4 MB',
    },
    {
      'name': 'EQ Journal Template Pack',
      'purchased': '10 Sep 2026',
      'file': 'ZIP · 18 templates · 3.1 MB',
    },
  ];

  /// Records a completed checkout: creates the order, unlocks digital
  /// items, clears the cart and notifies listeners once.
  /// Returns the amount charged.
  double checkout({String date = '12 Oct 2026'}) {
    if (cart.isEmpty) return 0;
    final amount = total;
    final itemsLabel =
        cart.map((l) => '${l.product.name} ×${l.qty}').join(', ');
    orders.insert(0, {
      'id': '#MA${1003 + orders.length}',
      'date': date,
      'amount': 'RM${amount.toStringAsFixed(2)}',
      'status': 'Paid',
      'items': itemsLabel,
    });
    for (final l in cart) {
      if (l.product.isDigital) {
        digitalLibrary.insert(0, {
          'name': l.product.name,
          'purchased': date,
          'file': 'PDF · digital download',
        });
      }
    }
    cart.clear();
    notifyListeners();
    return amount;
  }

  // --- Employer ------------------------------------------------------------
  final List<Map<String, String>> myEmployees = [
    {'name': 'Aisyah Rahman', 'dept': 'HR', 'email': 'aisyah@abcsdn.my'},
    {'name': 'Daniel Wong', 'dept': 'Finance', 'email': 'daniel@abcsdn.my'},
    {'name': 'Priya Nair', 'dept': 'Operations', 'email': 'priya@abcsdn.my'},
    {'name': 'Jason Lee', 'dept': 'Sales', 'email': 'jason@abcsdn.my'},
  ];

  void addEmployee(String name, String dept, String email) {
    myEmployees.insert(0, {'name': name, 'dept': dept, 'email': email});
    notifyListeners();
  }
}
