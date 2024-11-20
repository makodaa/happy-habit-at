import "package:shared_preferences/shared_preferences.dart";

late final SharedPreferences sharedPreferences;

Future<void> initSharedPrefences() async {
  sharedPreferences = await SharedPreferences.getInstance();
}
