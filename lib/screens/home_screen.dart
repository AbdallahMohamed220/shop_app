import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:food_app/providers/cart.dart';
import 'package:food_app/providers/products.dart';
import 'package:food_app/widget/badge.dart';
import 'package:provider/provider.dart';
import '../widget/listitems_widget.dart';

class MyHomePage extends StatefulWidget {
  static const routName = 'home_screen';
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isint = true;
  var _isloading = false;

  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  Widget cusSearchBar = Text(
    'Shop App',
    style: TextStyle(color: Colors.white),
  );
  @override
  // void initState() {
  //   Future.delayed(Duration.zero).then((_) {
  //     Provider.of<Products>(context).fetchAndSetData();
  //   });
  //   super.initState();
  // }
  Future<void> didChangeDependencies() async {
    if (_isint) {
      setState(() {
        _isloading = true;
      });
      await Provider.of<Products>(context).fetchAndSetData(false).then((_) {
        setState(() {
          _isloading = false;
        });
      });
    }
    _isint = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(icon: cusIcon, onPressed: () {}),
            Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                child: ch,
                value: cart.itemCount.toString(),
                color: Theme.of(context).accentColor,
              ),
              child: IconButton(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).cardColor,
                ),
                onPressed: () {},
              ),
            ),
          ],
          title: cusSearchBar,
        ),
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
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
                child: ListItemsWidgets(),
              ));
  }
}
