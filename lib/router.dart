// ignore_for_file: always_specify_types

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:happy_habit_at/screens/create_habit_screen.dart";
import "package:happy_habit_at/screens/habitat_screen.dart";
import "package:happy_habit_at/screens/habits_screen.dart";
import "package:happy_habit_at/screens/home_screen.dart";
import "package:happy_habit_at/screens/modify_habit_screen.dart";
import "package:happy_habit_at/screens/modify_habitat_screen.dart";
import "package:happy_habit_at/screens/more_screen.dart";
import "package:happy_habit_at/screens/shop_screen.dart";
import "package:happy_habit_at/screens/shop_screen/decoration_screen.dart";
import "package:happy_habit_at/screens/shop_screen/expansion_screen.dart";
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
  initialLocation: "/more",
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
          builder: (_, __, navigationShell) => Material(child: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  name: "habitat",
                  path: "/habitat",
                  builder: (_, state) => const HabitatScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: navigatorKeys.root,
                      path: "edit",
                      pageBuilder: (_, GoRouterState state) => CustomTransitionPage(
                        child: const ModifyHabitatScreen(),
                        transitionsBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                          Widget child,
                        ) {
                          return child;
                        },
                      ),
                    ),
                  ],
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
                    GoRoute(
                      parentNavigatorKey: navigatorKeys.root,
                      name: "editHabit",
                      path: "edit-habit/:habitId",
                      builder: (_, state) {
                        String stringId = state.pathParameters["habitId"]!;
                        if (int.tryParse(stringId) case int id) {
                          return ModifyHabitScreen(habitId: id);
                        } else {
                          throw Exception("Invalid habit id: $stringId");
                        }
                      },
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
                          path: "/shop/decoration",
                          builder: (_, state) => const DecorationScreen(),
                        ),
                      ],
                    ),
                    // StatefulShellBranch(
                    //   routes: [
                    //     GoRoute(
                    //       path: "/shop/food",
                    //       builder: (_, state) => const FoodScreen(),
                    //     ),
                    //   ],
                    // ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/expansion",
                          builder: (_, state) => const ExpansionScreen(),
                        ),
                      ],
                    ),
                    StatefulShellBranch(
                      routes: [
                        GoRoute(
                          path: "/shop/pet",
                          builder: (_, state) => const PetScreen(),
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
