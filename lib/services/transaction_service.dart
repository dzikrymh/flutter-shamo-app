import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shamo/models/cart_model.dart';

class TransactionService {
  String baseUrl = "http://192.168.1.7/shamo/api";

  Future<bool> checkout(
      String token, List<CartModel> carts, double totalPrice) async {
    var url = "$baseUrl/checkout";
    var header = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    var body = jsonEncode(
      {
        'address': "Marsmoon",
        'items': carts
            .map(
              (cart) => {
                'id': cart.product.id,
                'quantity': cart.quantity,
              },
            )
            .toList(),
        'status': "PENDING",
        'total_price': totalPrice,
        'shipping_price': 0,
      },
    );

    var response = await http.post(
      url,
      headers: header,
      body: body,
    );

    print(response);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Gagal Melakukan Checkout!");
    }
  }
}
