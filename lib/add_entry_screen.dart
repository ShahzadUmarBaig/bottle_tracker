import 'package:bottle_tracker/entry_model.dart';
import 'package:bottle_tracker/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddEntryScreen extends StatefulWidget {
  @override
  _AddEntryScreenState createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  TextEditingController quantity = TextEditingController();
  int value = 0;
  DateTime selectedDate;
  DateFormat format = DateFormat("dd/MM/yyyy");
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    quantity.text = value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Add Entry",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Navigator.pop(context, false);
          },
          splashRadius: 24,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: Column(
                children: [
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            onPressed: () {
                              showDatePicker(
                                      context: context,
                                      firstDate: DateTime.now()
                                          .subtract(Duration(days: 365)),
                                      initialDate: DateTime.now(),
                                      lastDate: DateTime.now()
                                          .add(Duration(days: 365)))
                                  .then((value) =>
                                      setState(() => selectedDate = value));
                            },
                            child: Text(selectedDate == null
                                ? "Select Date"
                                : format.format(selectedDate)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: _decrementValue,
                          icon: Icon(Icons.remove),
                          splashRadius: 24,
                        ),
                        Expanded(
                          child: TextField(
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Enter Value",
                              contentPadding:
                                  EdgeInsets.only(left: 15, right: 15),
                            ),
                            controller: quantity,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          onPressed: _incrementValue,
                          icon: Icon(Icons.add),
                          splashRadius: 24,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              if (selectedDate == null || int.parse(quantity.text) == 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Please select Date and quantity"),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else {
                saveEntry();
              }
            },
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              height: 50,
              child: Center(
                child: Text(
                  "Save Entry",
                  style: TextStyle(
                      color: Colors.grey[700], fontSize: 18, letterSpacing: 2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _incrementValue() {
    setState(() {
      value++;
      quantity.text = value.toString();
    });
  }

  void _decrementValue() {
    if (int.parse(quantity.text) > 0) {
      setState(() {
        value--;
        quantity.text = value.toString();
      });
    }
  }

  void saveEntry() {
    getValuesFromSP("entries").then((value) async {
      if (value == "") {
        final String encodedData = EntryModel.encode([
          EntryModel(
            date: selectedDate,
            value: int.parse(quantity.text),
          ),
        ]);
        await setValuesToSP("entries", encodedData);
        Navigator.pop(context, true);
      } else {
        final List<EntryModel> decodedData = EntryModel.decode(value);
        decodedData.add(
          EntryModel(
            date: selectedDate,
            value: int.parse(quantity.text),
          ),
        );
        final String encodedData = EntryModel.encode(decodedData);
        await setValuesToSP("entries", encodedData);
        Navigator.pop(context, true);
      }
    });
  }
}
