import 'dart:math';

import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import 'package:intl/intl.dart';

class OrderItemsWidget extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemsWidget(this.orderItem);

  @override
  _OrderItemsWidgetState createState() => _OrderItemsWidgetState();
}

class _OrderItemsWidgetState extends State<OrderItemsWidget> {
  var _expandend = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Auth>(context).useremail;
    final password = Provider.of<Auth>(context).userpassword;

    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Orders>(context, listen: false)
            .removeOrder(widget.orderItem.id);
      },
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Are You Sure?'),
                  content: Text('Do you want to remove this item?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    FlatButton(
                      child: Text('okey'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
      key: ValueKey(widget.orderItem.id),
      background: Container(
        color: Theme.of(context).accentColor,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Theme.of(context).cardColor,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
      ),
      child: Card(
        color: Color(0xfffda085).withOpacity(0.7),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                '\$${widget.orderItem.username}',
              ),
              subtitle: Text(DateFormat("dd-MM-yyyy")
                  .add_jm()
                  .format(widget.orderItem.dateTime)),
              trailing: IconButton(
                icon: Icon(_expandend ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expandend = !_expandend;
                  });
                },
              ),
            ),
            if (_expandend)
              Container(
                  height:
                      min(widget.orderItem.products.length * 20.0 + 50, 180),
                  padding: EdgeInsets.all(10),
                  child: ListView(
                    children: widget.orderItem.products
                        .map(
                          (prod) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                prod.title,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '${prod.quantity}x \$${prod.price}',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ))
          ],
        ),
      ),
    );
  }
}
