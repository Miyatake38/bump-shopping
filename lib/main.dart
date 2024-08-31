import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ItemListScreen(),
    );
  }
}

class Item {
  final String name;
  final int price;
  int quantity;

  Item({required this.name, required this.price, this.quantity = 0});

  // JSONからItemを生成するファクトリメソッド
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      name: json['name'],
      price: json['price'].toInt(),
      quantity: json['quantity'] ?? 0,
    );
  }
}

class ItemListScreen extends StatefulWidget {
  @override
  _ItemListScreenState createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // JSONファイルからデータを読み込むメソッド
  Future<void> _loadItems() async {
    final String response = await rootBundle.loadString('assets/items.json');
    final List<dynamic> data = json.decode(response);
    setState(() {
      items = data.map((json) => Item.fromJson(json)).toList();
    });
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Sphery Rendezvous 物販金額',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Created by @aoi_boc_Sr',
              style: TextStyle(fontSize: 8),
            ),
          ],
        ),
        backgroundColor: Color.fromRGBO(10, 41, 69, 1.0),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index].name),
                  subtitle: Text('${items[index].price}円'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          setState(() {
                            items[index].quantity++;
                          });
                        },
                      ),
                      Text('${items[index].quantity}'),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          setState(() {
                            if (items[index].quantity > 0) {
                              items[index].quantity--;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(24.0),
            color: Color.fromRGBO(243, 209, 82, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '点数: $totalItems',
                  style: TextStyle(color: Colors.black, fontSize: 24.0),
                ),
                Text(
                  '金額: ${totalPrice.toStringAsFixed(0)}円',
                  style: TextStyle(color: Colors.black, fontSize: 24.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}