import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/ui/admin_views/admin_dashboard.dart';
import 'package:tesis_airbnb_web/ui/guest_views/main_guest_view.dart';
import 'package:tesis_airbnb_web/ui/login.dart';
import 'package:tesis_airbnb_web/ui/main_web.dart';
import 'package:tesis_airbnb_web/ui/host_views/host_dashboard.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: MainWebPage())),
      GoRoute(
          path: '/login',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: LoginPage())),
      GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: DashboardPage())),
      GoRoute(
          path: '/host',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: HostDashboard())),
      GoRoute(
          path: '/guest',
          pageBuilder: (context, state) =>
              NoTransitionPage(child: MainGuestWebPage())),
    ],
  );
}
