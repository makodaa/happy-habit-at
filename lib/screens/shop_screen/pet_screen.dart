import "package:flutter/material.dart";
import "package:happy_habit_at/constants/pet_icons.dart";
import "package:happy_habit_at/providers/app_state.dart";
import "package:happy_habit_at/utils/extensions/map_pairs.dart";
import "package:happy_habit_at/widgets/currency_display.dart";
import "package:provider/provider.dart";

class PetScreen extends StatefulWidget {
  const PetScreen({super.key});

  @override
  State<PetScreen> createState() => _PetScreenState();

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
}

class _PetScreenState extends State<PetScreen> {
  late final AppState appState = context.read<AppState>();

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
            // const Text("New Pet"),
            // _fieldSeparator,
            // _buyCard(),
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
          child: Column(
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
                onPressed: () {},
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 2.0,
                  ),
                  child: CurrencyDisplay(currency: 2),
                ),
              ),
            ],
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
        for (var (String id, PetIcon icon) in petIcons.pairs) //
          _petTile(id, icon),
      ],
    );
  }

  Widget _petTile(String id, PetIcon petIcon) {
    return GestureDetector(
      onTap: () {
        appState.activeRoom.value.petId = id;
      },
      child: ListenableBuilder(
        listenable: appState.activeRoom.value,
        builder: (BuildContext context, Widget? child) => DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: appState.activeRoom.value.petId == id ? Border.all(color: Colors.green) : null,
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
                  child: Image.asset(
                    petIcon.imagePath,
                    width: petIcon.dimensions.$1,
                    height: petIcon.dimensions.$2,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(petIcon.name),
            ),
          ],
        ),
      ),
    );
  }
}
