import 'package:flutter/material.dart';
import 'package:food_app/providers/product.dart';
import 'package:food_app/providers/products.dart';
import 'package:food_app/widget/items_widget.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  static const routName = 'search_screen';
  const SearchScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);

    final products = productData.item;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Searach',
            style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Search',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {},
                          ),
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.teal))),
                    ),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: products.length,
                      itemBuilder: (ctx, i) =>
                          ChangeNotifierProvider<Product>.value(
                            value: products[i],
                            child: ItemWidget(),
                          )),
                )
              ],
            ),
          ),
        ));
  }
}
