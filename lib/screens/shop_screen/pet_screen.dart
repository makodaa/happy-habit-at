import "package:flutter/material.dart";

class PetScreen extends StatelessWidget {
  const PetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text("Insert Cash"),
                  _rowSeparator,
                  Icon(Icons.circle),
                ],
              ),
              _fieldSeparator,
              Text("Expand Habitat"),
              _fieldSeparator,
              Center(
                child: Card(
                  elevation: 2.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Expanded(
                      child: Column(
                        children: <Widget>[
                          DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: Colors.green.shade800,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.catching_pokemon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            "Pet Gachapon",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold,),
                          ),
                          _fieldSeparator,
                          Text("Increase habitat size from mxm to nxn"),
                          _fieldSeparator,
                          FilledButton(
                            onPressed: () {},
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 2.0,),
                              child: Text("Insert price"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const SizedBox _fieldSeparator = SizedBox(height: 16.0);
  static const SizedBox _labelSeparator = SizedBox(height: 4.0);
  static const SizedBox _rowSeparator = SizedBox(width: 4.0);
}
