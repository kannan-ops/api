import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiTask1 extends StatefulWidget {
  const ApiTask1({super.key});

  @override
  State<ApiTask1> createState() => _ApiTask1State();
}

class _ApiTask1State extends State<ApiTask1> {
  Map<String,dynamic> bodyData={};
  Future<Ecom> getData() async{
    try {
      var response = await http.get(
          Uri.parse("https://fakestoreapi.com/products"));
      bodyData = jsonDecode(response.body);
      print(response.statusCode);
      print(bodyData["message"]);
      if (response.statusCode == 200) {
        return Ecom.fromJson(bodyData);
      }
      else{
        throw Exception("Failed to load data");
      }
    }
    catch(e){
      throw Exception(e);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Api Task example-1"),
      ),
      body: FutureBuilder(future: getData(), builder: (BuildContext context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return CircularProgressIndicator();
        }
        else if(snapshot.hasError){
          return Text("Error:${snapshot.error}");
        }
        else if(snapshot.hasData){
          return Column(
            children: [

              Text(bodyData["id"].toString()),
              Text(bodyData["title"].toString()),
              Text(bodyData["price"].toString()),
              Text(bodyData["description"].toString()),
              Text(bodyData["category"].toString()),
              Text(bodyData["image"].toString()),
              Text(bodyData["rating"].toString()),

            ],
          );
        }
        else{
          return Text("No data found");
        }
      }),
    );
  }
}


class Ecom {
  int? id;
  String? title;
  double? price;
  String? description;
  String? category;
  String? image;
  Rating? rating;

  Ecom(
      {this.id,
        this.title,
        this.price,
        this.description,
        this.category,
        this.image,
        this.rating});

  Ecom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = json['price'];
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating =
    json['rating'] != null ? new Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['price'] = this.price;
    data['description'] = this.description;
    data['category'] = this.category;
    data['image'] = this.image;
    if (this.rating != null) {
      data['rating'] = this.rating!.toJson();
    }
    return data;
  }
}

class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = json['rate'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rate'] = this.rate;
    data['count'] = this.count;
    return data;
  }
}
