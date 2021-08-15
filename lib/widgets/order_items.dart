import 'package:flutter/material.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.ammount}"),
            subtitle: Text(
                DateFormat("dd/mm/yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                icon: _isExpanded ? const Icon(Icons.expand_less) : const Icon(Icons.expand_more)),
          ),
          if(_isExpanded) SizedBox(height: min(widget.order.products.length * 20.0 + 100,100),
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 3),
            children: widget.order.products.map((e) => 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(e.title,style: const TextStyle(fontWeight: FontWeight.bold ,fontSize: 18),),
                Text("${e.quantity}X \$${e.price}",style: const TextStyle(color: Colors.grey,fontSize: 18),
                ),
              ],
            ),
            
            ).toList(),
          ),
          
          ),
        ],
      ),
    );
  }
}
