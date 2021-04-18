import 'dart:convert';

import 'package:bottle_tracker/entry_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future setValuesToSP(String key, String list) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  prefs.setString(key, list);
}

Future<String> getValuesFromSP(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return EntryModel.encode([]);
  }
}
