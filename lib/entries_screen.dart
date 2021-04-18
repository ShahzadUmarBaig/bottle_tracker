import 'dart:convert';

import 'package:bottle_tracker/add_entry_screen.dart';
import 'package:bottle_tracker/entry_model.dart';
import 'package:bottle_tracker/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EntriesScreen extends StatefulWidget {
  EntriesScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _EntriesScreenState createState() => _EntriesScreenState();
}

class _EntriesScreenState extends State<EntriesScreen> {
  List<EntryModel> decodedData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: Colors.black,
        leading: Container(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: FutureBuilder(
              future: getValuesFromSP("entries"),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (EntryModel.decode(snapshot.data).isNotEmpty) {
                  print(snapshot);
                  decodedData = EntryModel.decode(snapshot.data);

                  decodedData.sort((a, b) => a.date.compareTo(b.date));
                  return ListView.builder(
                    itemCount: decodedData.length,
                    itemBuilder: (context, index) {
                      EntryModel entry = decodedData[index];
                      return entryCard(entry, index);
                    },
                  );
                } else {
                  print("This statement");
                  return Center(
                    child: Text("No Entries Found"),
                  );
                }
              },
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntryScreen(),
                ),
              ).then((value) {
                if (value) {
                  setState(() {});
                }
              });
            },
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              height: 50,
              child: Center(
                  child: Text(
                "Add Entry",
                style: TextStyle(
                    color: Colors.grey[700], fontSize: 18, letterSpacing: 2),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget entryCard(EntryModel entry, int index) {
    DateFormat month = DateFormat("MMMM");
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        child: Row(
          children: [
            SizedBox(width: 8),
            Container(
              height: 40,
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(entry.date.day.toString()),
                  Text(month.format(entry.date).toUpperCase())
                ],
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "No. of bottles",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  SizedBox(height: 4),
                  Text(entry.value.toString())
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline_outlined),
              color: Colors.red,
              onPressed: () async {
                decodedData.removeAt(index);
                final String encodedData = EntryModel.encode(decodedData);
                await setValuesToSP("entries", encodedData);
                setState(() {});
              },
              splashRadius: 24,
            ),
            SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
