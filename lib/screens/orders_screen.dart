import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';

import '../widget/orderitem_widget.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffffc3a0),
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body:
       FutureBuilder(
        future:
            Provider.of<Orders>(context, listen: false).fetchAndSetData(false),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              // ...
              // Do error handling stuff
              return Center(
                child: Text('An error occurred!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                        Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0, 1],
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (ctx, i) =>
                        OrderItemsWidget(orderData.orders[i]),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
