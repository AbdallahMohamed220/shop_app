import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widget/cartitem_widget.dart';
import '../providers/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Cart',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Container(
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
        child: Column(
          children: <Widget>[
            Card(
              color: Theme.of(context).primaryColor,
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total :',
                      style: TextStyle(
                          fontSize: 18, color: Theme.of(context).cardColor),
                    ),
                    Spacer(),
                    Chip(
                      label: Text(
                        '\$${cartData.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).cardColor,
                        ),
                      ),
                      backgroundColor: Color(0xfffda085).withOpacity(0.5),
                    ),
                    OrderButton(cart: cartData)
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: cartData.items.length,
                itemBuilder: (ctx, i) => CartItemWidget(
                  id: cartData.items.values.toList()[i].id,
                  productId: cartData.items.keys.toList()[i],
                  title: cartData.items.values.toList()[i].title,
                  price: cartData.items.values.toList()[i].price,
                  quantity: cartData.items.values.toList()[i].quantity,
                  imgUrl: cartData.items.values.toList()[i].imgUrl,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final email = Provider.of<Auth>(context).useremail;
    final password = Provider.of<Auth>(context).userpassword;
    final scaffold = Scaffold.of(context);
    return FlatButton(
      child: _isLoading
          ? CircularProgressIndicator()
          : Text(
              'Order Now!',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
          ? null
          : () async {
              try {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(),
                    widget.cart.totalAmount,
                    email,
                    password);
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              } catch (error) {
                setState(() {
                  _isLoading = false;
                });
                scaffold.showSnackBar(SnackBar(
                  content: Text(
                    'Order Faild',
                    textAlign: TextAlign.center,
                  ),
                  duration: Duration(seconds: 2),
                ));
              }
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
