import 'package:flutter/foundation.dart';

import '../data/brand_data.dart';
import '../data/models.dart';

/// Lightweight in-memory state for the prototype (no backend).
///
/// [Content] holds the fixed sample catalogue; this class holds everything
/// the user can change at runtime (session, cart, roster, orders, …) and
/// notifies listeners so the UI stays consistent across screens.
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
    final stock = effectiveStock(p);
    if (idx >= 0) {
      cart[idx].qty = (cart[idx].qty + qty).clamp(1, stock);
    } else {
      cart.add(CartLine(p, qty.clamp(1, stock)));
    }
    notifyListeners();
  }

  void setQty(Product p, int qty) {
    final idx = cart.indexWhere((l) => l.product.id == p.id);
    if (idx < 0) return;
    if (qty <= 0) {
      cart.removeAt(idx);
    } else {
      cart[idx].qty = qty.clamp(1, effectiveStock(p));
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

  // --- Orders (prototype records) ------------------------------------------
  /// Each order carries structured `lines` so screens can derive
  /// digital/physical handling instead of parsing display strings:
  /// `[{'name', 'qty', 'digital', 'price'}]`, plus `type`
  /// ('digital' | 'physical' | 'mixed') and `customer`.
  final List<Map<String, dynamic>> orders = [
    {
      'id': '#MA1001',
      'date': '10 Sep 2026',
      'amount': 'RM120.00',
      'status': 'Paid',
      'customer': 'Aisyah Rahman',
      'type': 'digital',
      'items': 'EQ Journal Template Pack ×1, Mindfulness Card Deck ×1',
      'lines': [
        {'name': 'EQ Journal Template Pack', 'qty': 1, 'digital': true, 'price': 35.0},
        {'name': 'Mindfulness Card Deck (PDF)', 'qty': 1, 'digital': true, 'price': 30.0},
      ],
    },
    {
      'id': '#MA1002',
      'date': '12 Sep 2026',
      'amount': 'RM85.00',
      'status': 'Shipped',
      'customer': 'Daniel Wong',
      'type': 'physical',
      'items': 'Team Reflection Cards ×1',
      'lines': [
        {'name': 'Team Reflection Cards', 'qty': 1, 'digital': false, 'price': 75.0},
      ],
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

  /// Records a completed checkout: creates the order with structured
  /// lines, unlocks digital items, clears the cart and notifies once.
  /// Returns the amount charged.
  double checkout({String date = '12 Oct 2026'}) {
    if (cart.isEmpty) return 0;
    final amount = total;
    final hasPhysical = cart.any((l) => !l.product.isDigital);
    final hasDigital = cart.any((l) => l.product.isDigital);
    orders.insert(0, {
      'id': '#MA${1003 + orders.length}',
      'date': date,
      'amount': 'RM${amount.toStringAsFixed(2)}',
      'status': 'Paid',
      'customer': userName ?? 'Guest checkout',
      'type': hasPhysical && hasDigital
          ? 'mixed'
          : hasPhysical
              ? 'physical'
              : 'digital',
      'items': cart.map((l) => '${l.product.name} ×${l.qty}').join(', '),
      'lines': [
        for (final l in cart)
          {
            'name': l.product.name,
            'qty': l.qty,
            'digital': l.product.isDigital,
            'price': l.product.price,
          },
      ],
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

  /// Advances an order one step along its fulfilment state machine.
  /// Physical: Paid → Shipped → Delivered. Digital: Paid → Available.
  /// Returns true when the status changed.
  bool advanceOrderStatus(Map<String, dynamic> order) {
    final type = '${order['type']}';
    final current = '${order['status']}';
    const physicalFlow = ['Paid', 'Shipped', 'Delivered'];
    const digitalFlow = ['Paid', 'Available'];
    final flow = type == 'digital' ? digitalFlow : physicalFlow;
    final idx = flow.indexOf(current);
    if (idx < 0 || idx >= flow.length - 1) return false;
    order['status'] = flow[idx + 1];
    notifyListeners();
    return true;
  }

  // --- Employer roster (single source of truth) -----------------------------
  /// Runtime learner roster, seeded from the sample catalogue. Invited
  /// employees are appended here, so dashboards, reports and assignment
  /// screens always agree.
  final List<Employee> roster = List.of(Content.employees);

  void addEmployee(String name, String dept, String email,
      {String role = 'Learner'}) {
    roster.insert(
        0,
        Employee(
            name: name,
            department: dept,
            course: 'Not assigned',
            progress: 0,
            status: 'Invited',
            email: email,
            role: role));
    notifyListeners();
  }

  void removeEmployee(String email) {
    roster.removeWhere((e) => e.email == email);
    notifyListeners();
  }

  // --- Course assignments ----------------------------------------------------
  final List<Map<String, String>> assignments = [
    {
      'course': 'Workplace Well-being Practitioner',
      'employees': 'Tan Wei Ming, Priya Nair',
      'count': '2',
      'deadline': '30 Oct 2026',
      'assigned': '12 Oct 2026',
    },
    {
      'course': 'Communicate with Impact',
      'employees': 'Jason Lee',
      'count': '1',
      'deadline': '05 Nov 2026',
      'assigned': '12 Oct 2026',
    },
  ];

  void assignCourse({
    required String course,
    required List<String> employees,
    required String deadline,
  }) {
    assignments.insert(0, {
      'course': course,
      'employees': employees.join(', '),
      'count': '${employees.length}',
      'deadline': deadline,
      'assigned': '12 Oct 2026',
    });
    notifyListeners();
  }

  // --- Enquiries & newsletter (recorded by contact/insights forms) -----------
  final List<Map<String, String>> enquiries = [
    {
      'name': 'Siti Ahmad',
      'email': 'siti@contoh.my',
      'type': 'Corporate Training',
      'message': 'Enquiring about a leadership lab for 40 managers.',
      'date': '11 Oct 2026',
    },
  ];

  void submitEnquiry({
    required String name,
    required String email,
    required String type,
    required String message,
  }) {
    enquiries.insert(0, {
      'name': name,
      'email': email,
      'type': type,
      'message': message,
      'date': '12 Oct 2026',
    });
    notifyListeners();
  }

  final List<String> newsletter = [];

  /// Returns false when the email is already subscribed.
  bool subscribeNewsletter(String email) {
    if (newsletter.contains(email)) return false;
    newsletter.insert(0, email);
    notifyListeners();
    return true;
  }

  // --- Admin overrides (in-memory prototype management) ----------------------
  final Map<String, String> courseStatus = {};
  final Map<String, int> stockOverrides = {};
  final Map<String, bool> adminSwitches = {
    'Email notifications': true,
    'New enrolment alerts': true,
  };

  String coursePublishStatus(String id) => courseStatus[id] ?? 'Published';

  void toggleCourseStatus(String id) {
    courseStatus[id] =
        coursePublishStatus(id) == 'Published' ? 'Draft' : 'Published';
    notifyListeners();
  }

  int effectiveStock(Product p) =>
      stockOverrides[p.id] ?? p.stock;

  void adjustStock(Product p, int delta) {
    final next = (effectiveStock(p) + delta).clamp(0, 999);
    stockOverrides[p.id] = next;
    notifyListeners();
  }

  void setAdminSwitch(String key, bool value) {
    adminSwitches[key] = value;
    notifyListeners();
  }
}
