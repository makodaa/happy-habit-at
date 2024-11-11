import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/screens/create_habit_screen.dart";
import "package:happy_habit_at/screens/habitat_screen.dart";
import "package:happy_habit_at/screens/habits_screen.dart";
import "package:happy_habit_at/screens/home_screen.dart";
import "package:happy_habit_at/screens/shop_screen.dart";
import "package:happy_habit_at/screens/more_screen.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

// ignore: always_specify_types
final navigatorKeys = (
  root: GlobalKey<NavigatorState>(debugLabel: "root"),
  habitat: GlobalKey<NavigatorState>(debugLabel: "habitat"),
  createHabit: GlobalKey<NavigatorState>(debugLabel: "createHabit"),
  habits: GlobalKey<NavigatorState>(debugLabel: "habits"),
  shop: GlobalKey<NavigatorState>(debugLabel: "shop"),
  stats: GlobalKey<NavigatorState>(debugLabel: "stats"),
);

final GoRouter router = GoRouter(
  navigatorKey: navigatorKeys.root,
  initialLocation: "/habitat",
  routes: <RouteBase>[
    StatefulShellRoute(
      navigatorContainerBuilder: (
        BuildContext context,
        StatefulNavigationShell navigationShell,
        List<Widget> children,
      ) {
        print(navigationShell);

        return HomeScreen(
          navigationShell: navigationShell,
          children: ImmutableList<Widget>(children),
        );
      },
      builder: (_, __, StatefulNavigationShell navigationShell) => navigationShell,
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          navigatorKey: navigatorKeys.habitat,
          routes: <RouteBase>[
            GoRoute(
              name: "habitat",
              path: "/habitat",
              builder: (BuildContext context, GoRouterState state) => const HabitatScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.habits,
          routes: <RouteBase>[
            GoRoute(
              name: "habits",
              path: "/habits",
              builder: (BuildContext context, GoRouterState state) => const HabitsScreen(),
              routes: <RouteBase>[
                GoRoute(
                  name: "createHabit",
                  path: "create-habit",
                  builder: (BuildContext context, GoRouterState state) => const CreateHabitScreen(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.shop,
          routes: <RouteBase>[
            GoRoute(
              name: "shop",
              path: "/shop",
              builder: (BuildContext context, GoRouterState state) => const ShopScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: navigatorKeys.stats,
          routes: <RouteBase>[
            GoRoute(
              name: "more",
              path: "/more",
              builder: (BuildContext context, GoRouterState state) => const MoreScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
