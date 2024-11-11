import "package:flutter/material.dart";

class CreateHabitScreen extends StatelessWidget {
  const CreateHabitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          title: const Text("Habits"),
          elevation: 1.0,
          shadowColor: Colors.black,
          leading: IconButton(
            onPressed: (){},
            icon: const Icon(Icons.arrow_back),),
        ),

        //BODY
        const Expanded(
          child: Column(
            children: <Widget>[
              Row(),
              Row(),
            ],
          ),
        ),
      ],
    );
  }
}