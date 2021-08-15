import 'package:flutter/foundation.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double ammount;
  final List<CartItems> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.ammount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    var url = Uri.parse(
        "https://flutter-shop-app-bb686-default-rtdb.asia-southeast1.firebasedatabase.app/$userId.json?auth=$authToken");

    final response = await http.get(url);
    final fetchedData = json.decode(response.body) as Map<String, dynamic>?;
    if (fetchedData == null) {
      return;
    }

    final List<OrderItem> loadedOrders = [];
    fetchedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          ammount: orderData["ammount"],
          products: (orderData["products"] as List<dynamic>)
              .map((e) => CartItems(
                  id: e["id"],
                  title: e["title"],
                  quantity: e["quantity"],
                  price: e["price"]))
              .toList(),
          dateTime: DateTime.parse(orderData["dateTime"])));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItems> cartproducts, double total) async {
    var url = Uri.parse(
        "https://flutter-shop-app-bb686-default-rtdb.asia-southeast1.firebasedatabase.app/$userId.json?auth=$authToken");

    final timeStamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          "ammount": total,
          "dateTime": timeStamp.toIso8601String(),
          "products": cartproducts
              .map((e) => {
                    "id": e.id,
                    "title": e.title,
                    "quantity": e.quantity,
                    "price": e.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)["name"],
            ammount: total,
            products: cartproducts,
            dateTime: timeStamp));
    notifyListeners();
  }
}
