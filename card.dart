import 'package:api1/product%20dis%20page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'http.methods.dart';

class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: cartItems.isEmpty
          ? Center(child: Text("Your cart is empty"))
          : ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          var item = cartItems[index];
          return ListTile(
            leading: Image.network(item.image ?? '', height: 50),
            title: Text(item.title ?? ''),
            subtitle: Text("₹${item.price?.toStringAsFixed(2)}"),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                cartItems.removeAt(index);
                (context as Element).reassemble();
              },
            ),
          );
        },
      ),
    );
  }
}
