// To parse this JSON data, do
//
//     final entryModel = entryModelFromJson(jsonString);

import 'dart:convert';

class EntryModel {
  EntryModel({
    this.date,
    this.value,
  });

  DateTime date;
  int value;

  EntryModel copyWith({
    DateTime date,
    int value,
  }) =>
      EntryModel(
        date: date ?? this.date,
        value: value ?? this.value,
      );

  factory EntryModel.fromRawJson(String str) =>
      EntryModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory EntryModel.fromJson(Map<String, dynamic> json) => EntryModel(
        date: DateTime.parse(json["date"]),
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
        "value": value,
      };

  static Map<String, dynamic> toMap(EntryModel entry) => {
        'date': entry.date.toIso8601String(),
        'value': entry.value,
      };

  static String encode(List<EntryModel> musics) => json.encode(
        musics
            .map<Map<String, dynamic>>((entry) => EntryModel.toMap(entry))
            .toList(),
      );

  static List<EntryModel> decode(String entries) =>
      (json.decode(entries) as List<dynamic>)
          .map<EntryModel>((item) => EntryModel.fromJson(item))
          .toList();
}
