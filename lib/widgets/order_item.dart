import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  const OrderItem({super.key, required this.order});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(children: [
        ListTile(
          title: Text('\$${widget.order.amount}'),
          subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
          trailing: IconButton(
            icon: _isExpanded
                ? const Icon(Icons.expand_less)
                : const Icon(Icons.expand_more),
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
        ),
        if (_isExpanded)
          Container(
            padding: const EdgeInsets.only(left: 18, right: 18, bottom: 16),
            child: Column(
                children: widget.order.products
                    .map((e) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(e.title),
                              Text(
                                '${e.quantity}x\$${e.price}',
                                style: const TextStyle(color: Colors.black54),
                              )
                            ],
                          ),
                        ))
                    .toList()),
          )
      ]),
    );
  }
}
