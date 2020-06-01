import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:food_app/screens/details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ItemFavoriteWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartItem = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);

    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              DetailsPage.routName,
              arguments: product.id,
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Flexible(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Hero(
                            tag: "image${product.id}",
                            child: Container(
                              height: 80,
                              width: 80,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage(product.imgUrl),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: FittedBox(
                              child: Text(
                                product.title,
                                textWidthBasis: TextWidthBasis.longestLine,
                                softWrap: true,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Consumer<Product>(
                            builder: (ctx, product, _) => IconButton(
                              onPressed: () {
                                product.toggleFavoriteStauts(
                                    auth.token, auth.userId);
                              },
                              icon: Icon(
                                product.isfavoirte
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ),
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cartItem.addItem(product.id, product.title,
                                  product.price, product.imgUrl);
                              Scaffold.of(context).hideCurrentSnackBar();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Item added to cart!'),
                                duration: Duration(seconds: 2),
                                action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    cartItem.removeSingleItem(product.id);
                                  },
                                ),
                              ));
                            },
                            icon: Icon(Icons.shopping_basket,
                                color: Colors.red, size: 30.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
