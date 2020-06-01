import 'package:flutter/material.dart';
import 'package:food_app/widget/itemfavorite_widget.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class FavoritesScreen extends StatelessWidget {
  static const routName = 'favorite_screen';
  @override
  Widget build(BuildContext context) {
    final favoriteList = Provider.of<Products>(context).favoriteItems;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Your Favorite',
            style: TextStyle(
                color: Theme.of(context).cardColor,
                fontSize: 24,
                fontWeight: FontWeight.bold),
          ),
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
          child: ListView.builder(
              itemCount: favoriteList.length,
              itemBuilder: (ctx, i) => ChangeNotifierProvider<Product>.value(
                  value: favoriteList[i], child: ItemFavoriteWidget())),
        ));
  }
}
