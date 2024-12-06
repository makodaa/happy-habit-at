import "dart:async";
import "dart:math";

import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/utils/extension_types/ids.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/widgets/currency_display.dart";
import "package:provider/provider.dart";

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
}

class _PetScreenState extends State<PetScreen> with SingleTickerProviderStateMixin {
  late final AppState appState = context.read<AppState>();

  late Completer<PetId>? rollCompleter = null;
  late Duration? lastDuration = null;
  late DateTime? lastTick = null;
  late Ticker? ticker = null;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const UserCurrencyDisplay(),
            PetScreen._fieldSeparator,
            const Text("New Pet"),
            const SizedBox(
              height: 16.0,
            ),
            _buyCard(),
            const Text("Pets"),
            _pets(),
          ],
        ),
      ),
    );
  }

  Widget _buyCard() {
    return Center(
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListenableBuilder(
            listenable: appState.ownedPets,
            builder: (BuildContext context, _) {
              Random generator = Random();
              List<PetId> notOwnedPets = appState.notOwnedPets;

              return switch (notOwnedPets.isNotEmpty) {
                true => Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.green.shade800,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.catching_pokemon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Buy a new pet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PetScreen._fieldSeparator,
                      const Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.0,
                            child: Text("If you can read this, you are a pogger"),
                          ),
                          Positioned.fill(
                            child: Center(child: Text("Roll for a random pet!")),
                          ),
                        ],
                      ),
                      PetScreen._fieldSeparator,
                      FilledButton(
                        onPressed: appState.currency.value > 150
                            ? () async {
                                PetId newPetId =
                                      notOwnedPets[generator.nextInt(notOwnedPets.length)];
                                PetIcon newPetIcon = petIcons[newPetId]!;

                                await appState.ownPet(newPetId);
                                if (!context.mounted) {
                                  return;
                                }

                                return showDialog<void>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("You got a new pet"),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.all(32.0),
                                              child: Center(
                                                child: Image.asset(
                                                  newPetIcon.imagePath,
                                                  width: newPetIcon.dimensions.$1,
                                                  height: newPetIcon.dimensions.$2,
                                                ),
                                              ),
                                            ),
                                            Text(newPetIcon.name),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            : null,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 2.0,
                          ),
                          child: CurrencyDisplay(currency: 150),
                        ),
                      ),
                    ],
                  ),
                false => Column(
                    children: <Widget>[
                      DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: Colors.green.shade800,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.catching_pokemon,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Text(
                        "Buy a new pet",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      PetScreen._fieldSeparator,
                      const Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.0,
                            child: Text("If you can read this, you are a pogger"),
                          ),
                          Positioned.fill(
                            child: Center(child: Text("You own all the pets!")),
                          ),
                        ],
                      ),
                      PetScreen._fieldSeparator,
                      const FilledButton(
                        onPressed: null,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 2.0,
                          ),
                          child: CurrencyDisplay(currency: 150),
                        ),
                      ),
                    ],
                  ),
              };
            },
          ),
        ),
      ),
    );
  }

  Widget _pets() {
    return GridView(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      children: <Widget>[
        for (var (PetId id, PetIcon icon) in petIcons.pairs) //
          _petTile(id, icon),
      ],
    );
  }

  // If pet owned, allow ontap and icon
  // If pet not owned, disable
  Widget _petTile(PetId id, PetIcon petIcon) {
    return ListenableBuilder(
      listenable: appState.ownedPets,
      builder: (BuildContext context, _) {
        bool isOwned = appState.ownedPets.contains(id);
        return GestureDetector(
          onTap: () {
            if (isOwned) {
              appState.activeRoom.value.petId = id;
            }
          },
          child: ListenableBuilder(
            listenable: appState.activeRoom.value,
            builder: (BuildContext context, Widget? child) => DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border:
                    appState.activeRoom.value.petId == id ? Border.all(color: Colors.green) : null,
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: child,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isOwned
                          ? Image.asset(
                              petIcon.imagePath,
                              width: petIcon.dimensions.$1,
                              height: petIcon.dimensions.$2,
                            )
                          : null,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: isOwned ? Text(petIcon.name) : const Text("Not unlocked"),
                ),
                ListenableBuilder(
                  listenable: appState.activeRoom.value,
                  builder: (BuildContext context, Widget? child) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: appState.activeRoom.value.petId == id
                        ? const Text(
                            "Selected",
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          )
                        : null,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
