import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'card.dart';
import 'http.methods.dart';
import 'product dis page.dart';

class Ecom1 extends StatefulWidget {
  const Ecom1({super.key});

  @override
  State<Ecom1> createState() => _Ecom1State();
}

class _Ecom1State extends State<Ecom1> {
  List<Ecom> allProducts = [];
  List<Ecom> filteredProducts = [];
  bool _isSearching = false;

  TextEditingController searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse("https://fakestoreapi.com/products"));
      if (response.statusCode == 200) {
        List data = jsonDecode(response.body);
        allProducts = data.map((json) => Ecom.fromJson(json)).toList();
        setState(() {
          filteredProducts = allProducts;
        });
      } else {
        throw Exception("Failed to load products");
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _searchProducts(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = allProducts;
      } else {
        filteredProducts = allProducts
            .where((product) => product.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        title: _isSearching
            ? TextField(
          controller: searchCtrl,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Search products...",
            border: InputBorder.none,
          ),
          onChanged: _searchProducts,
        )
            : const Text("Products"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  searchCtrl.clear();
                  filteredProducts = allProducts;
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CartPage()),
                  ).then((_) => setState(() {}));
                },
              ),
              if (cartItems.isNotEmpty)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cartItems.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                )
            ],
          ),
        ],
      ),
      body: filteredProducts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.65,
        ),
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final product = filteredProducts[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Product(product: product)),
              );
            },
            child: Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Hero(
                      tag: product.id!,
                      child: Image.network(
                        product.image ?? '',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          product.title ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text("₹${product.price?.toStringAsFixed(2)}"),
                        const SizedBox(height: 4),
                        Text(
                          "${product.rating?.rate ?? 0} (${product.rating?.count ?? 0})",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
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

  Ecom({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  Ecom.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = (json['price'] as num).toDouble();
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }
}

class Rating {
  double? rate;
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = (json['rate'] as num).toDouble();
    count = json['count'];
  }
}
