# MT Alchemy — Corporate Platform Prototype

Flutter UI prototype for the MT Alchemy corporate platform
(consultancy · training · organisational development · store · LMS · portals).

## Run

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome   # or: windows / android / edge
```

## What is included

- Public site: Home, About, Services, Upskilling (Learning Hub),
  Store, Insights, Contact — responsive (`mobile < 700 < tablet < 1080 < desktop`)
  with shared `AppShell` nav + footer.
- Commerce: product detail, cart, checkout (validated form + digital /
  physical shipping logic), confirmation, my orders, digital library.
- LMS: course detail, course player, quiz (pass mark 4/5 with answer
  review), certificate preview / issued state, learner dashboard.
- Portals: employer dashboard, employees, assign course, reports,
  admin portal — all wrapped in the role-based `PortalShell`.
- Auth: login / register with role routing
  (Individual → `/dashboard`, Employer/Trainer → `/employer`,
  Administrator → `/admin`).

## State

`lib/state/app_state.dart` is a `ChangeNotifier` singleton holding the
prototype state (session, cart, enrolment/progress, orders, digital
library, employees). `main.dart` wraps `MaterialApp` in a
`ListenableBuilder` so every `notifyListeners()` rebuilds the UI, and
checkout is committed atomically via `AppState.checkout()`.

live site:  https://saikrishn-a-96.github.io/Mtalchemy/

## Verify

- `flutter analyze` — no issues.
- `flutter test` — brand palette, portal-route wrapping and content
  completeness checks pass (`test/widget_test.dart`).
