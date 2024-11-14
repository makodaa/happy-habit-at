// ignore_for_file: always_specify_types

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/screens/create_habit_screen.dart";
import "package:happy_habit_at/screens/habitat_screen.dart";
import "package:happy_habit_at/screens/habits_screen.dart";
import "package:happy_habit_at/screens/home_screen.dart";
import "package:happy_habit_at/screens/more_screen.dart";
import "package:happy_habit_at/screens/shop_screen.dart";
import "package:happy_habit_at/screens/shop_screen/expansion_screen.dart";
import "package:happy_habit_at/screens/shop_screen/food_screen.dart";
import "package:happy_habit_at/screens/shop_screen/furniture_screen.dart";
import "package:happy_habit_at/screens/shop_screen/pet_screen.dart";
import "package:happy_habit_at/utils/extension_types/immutable_list.dart";

final navigatorKeys = (
  root: GlobalKey<NavigatorState>(debugLabel: "root"),
  habitat: GlobalKey<NavigatorState>(debugLabel: "habitat"),
  createHabit: GlobalKey<NavigatorState>(debugLabel: "createHabit"),
  habits: GlobalKey<NavigatorState>(debugLabel: "habits"),
  shop: GlobalKey<NavigatorState>(debugLabel: "shop"),
  stats: GlobalKey<NavigatorState>(debugLabel: "stats"),
);

final router = GoRouter(
  initialLocation: "/habitat",
  routes: [
    GoRoute(
      path: "/",
      redirect: (_, __) => "/habitat",
    ),

    /// This [ShellRoute] is necessary for the "root" of the navigator,
    ///   which usually requires a [Scaffold] widget
    /// (Which is not possible, as the inner [StatefulShellRoute] already has a [Scaffold].)
    ShellRoute(
      navigatorKey: navigatorKeys.root,
      builder: (_, __, child) => Scaffold(body: child),
      routes: [
        StatefulShellRoute(
          navigatorContainerBuilder: (_, shell, children) => HomeScreen(
            navigationShell: shell,
            children: children.immutable,
          ),
          builder: (_, __, navigationShell) => navigationShell,
          branches: [
            StatefulShellBranch(
              navigatorKey: navigatorKeys.habitat,
              routes: [
                GoRoute(
                  name: "habitat",
                  path: "/habitat",
                  builder: (_, state) => const HabitatScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: "habits",
                  path: "/habits",
                  builder: (_, state) => const HabitsScreen(),
                  routes: [
                    GoRoute(
                      /// This [parentNavigatorKey] is necessary to "override"
                      ///   the [StatefulShellBranch] above.
                      parentNavigatorKey: navigatorKeys.root,
                      name: "createHabit",
                      path: "create-habit",
                      builder: (_, state) => const CreateHabitScreen(),
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                StatefulShellRoute(
                  builder: (_, __, shell) => shell,
                  navigatorContainerBuilder: (_, navigationShell, children) => ShopScreen(
                    navigationShell: navigationShell,
                    children: children.immutable,
                  ),
                  branches: [
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/furniture",
                          builder: (_, state) => FurnitureScreen(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/food",
                          builder: (_, state) => FoodScreen(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/expansion",
                          builder: (_, state) => ExpansionScreen(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/pet",
                          builder: (_, state) => PetScreen(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              navigatorKey: navigatorKeys.stats,
              routes: [
                GoRoute(
                  name: "more",
                  path: "/more",
                  builder: (_, state) => const MoreScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
