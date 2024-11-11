import "package:flutter/material.dart";

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> with SingleTickerProviderStateMixin {
  late final TabController tabController;

  @override
  void initState() {
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        /// APPBAR
        AppBar(
          title: const Text("Shop"),
          elevation: 2.0,
          shadowColor: Colors.black,
        ),

        /// BODY
        Expanded(
          child: Column(
            children: <Widget>[
              TabBar(
                controller: tabController,
                tabs: const <Widget>[
                  Tab(text: "Furniture"),
                  Tab(text: "Food"),
                  Tab(text: "Expansion"),
                  Tab(text: "Pet"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8.0, 
                    children: [
                      Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: const Icon(Icons.bed, size: 12.0),
                        ),
                        label: const Text("Beds"),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: const Icon(Icons.bed, size: 12.0),
                        ),
                        label: const Text("Walls"),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: const Icon(Icons.bed, size: 12.0),
                        ),
                        label: const Text("Floor"),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: const Icon(Icons.bed, size: 12.0),
                        ),
                        label: const Text("Lights"),
                      ),
                      Chip(
                        avatar: CircleAvatar(
                          backgroundColor: Colors.grey.shade800,
                          child: const Icon(Icons.bed, size: 12.0),
                        ),
                        label: const Text("Whatever"),
                      ),
                    ],
                  ),
                ),
              ),
              const Center(
                child: Text("andrei likes calizo"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
