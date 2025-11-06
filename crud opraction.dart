import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrudPage extends StatefulWidget {
  const CrudPage({super.key});

  @override
  State<CrudPage> createState() => _CrudPageState();
}

class _CrudPageState extends State<CrudPage> {
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();

  Future<void> addData() async {
    final url = Uri.parse('https://dragon-11409-default-rtdb.firebaseio.com/findit.json');

    final response = await http.post(
      url,
      body: json.encode({
        'name': name.text,
        'age': age.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Data added successfully')),
      );
      name.clear();
      age.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(' Failed to add data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Firebase ",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
      backgroundColor: Colors.black,
      ),
      body: Padding(
        padding:EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.date_range),
                  labelText: "DATE OF BIRTH",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: addData,
                child: Text("Enter",
                  style: TextStyle(fontWeight: FontWeight.bold),))
          ],
        ),
      ),
    );
  }
}