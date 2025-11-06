import 'package:flutter/material.dart';
class mmm extends StatelessWidget {
  const mmm({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        title: Text("Product",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: double.infinity,
              height: 300,
            )
          ],
        ),
      ),
    );();
  }
}
