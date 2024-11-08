import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/screens/home_screen.dart";
import "package:happy_habit_at/screens/home_screen_shells/habitat_screen.dart";
import "package:happy_habit_at/screens/home_screen_shells/habits_screen.dart";
import "package:happy_habit_at/screens/home_screen_shells/shop_screen.dart";
import "package:happy_habit_at/screens/home_screen_shells/stats_screen.dart";

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");

// ignore: always_specify_types
final navigatorKeys = (
  habitat: GlobalKey<NavigatorState>(debugLabel: "habitat"),
  habits: GlobalKey<NavigatorState>(debugLabel: "habits"),
  shop: GlobalKey<NavigatorState>(debugLabel: "shop"),
  stats: GlobalKey<NavigatorState>(debugLabel: "stats"),
);

class SlideUpPageAnimation extends StatelessWidget {
  const SlideUpPageAnimation({
    required this.context,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
    super.key,
  });
  final BuildContext context;
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 0.8),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut, // Curve applied here
          ),
        ),
        child: child,
      ),
    );
  }
}

CustomTransitionPage<void> Function(BuildContext, GoRouterState) transitionPage({
  required Widget child,
}) {
  return (BuildContext context, GoRouterState state) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
        Widget child,
      ) {
        return RotationTransition(
          turns: animation,
          child: child,
        );
      },
    );
  };
}

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: "/habitat",
  routes: <RouteBase>[
    StatefulShellRoute(
      navigatorContainerBuilder: (
        BuildContext context,
        StatefulNavigationShell navigationShell,
        List<Widget> children,
      ) {
        return HomeScreen(navigationShell: navigationShell, children: children);
      },
      builder: (
        BuildContext context,
        GoRouterState state,
        StatefulNavigationShell navigationShell,
      ) =>
          navigationShell,
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: navigatorKeys.habitat,
          routes: <RouteBase>[
            GoRoute(
              path: "/habitat",
              builder: (BuildContext context, GoRouterState state) => const HabitatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.habits,
          routes: <RouteBase>[
            GoRoute(
              path: "/habits",
              builder: (BuildContext context, GoRouterState state) => const HabitsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.shop,
          routes: <RouteBase>[
            GoRoute(
              path: "/shop",
              builder: (BuildContext context, GoRouterState state) => const ShopScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.stats,
          routes: <RouteBase>[
            GoRoute(
              path: "/stats",
              builder: (BuildContext context, GoRouterState state) => const StatsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
