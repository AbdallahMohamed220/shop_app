import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:food_app/screens/details_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ItemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cartItem = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Column(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                DetailsPage.routName,
                arguments: product.id,
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                elevation: 3,
                child: Container(
                  padding: EdgeInsets.only(top: 8),
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Hero(
                            tag: product.imgUrl,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 8),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  image: DecorationImage(
                                      image: NetworkImage(product.imgUrl))),
                              height: height * 0.3,
                              width: width * 0.3,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 8),
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
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                      Container(
                        height: 41,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  size: 20,
                                ),
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
                                  color: Colors.red, size: 20.0),
                            ),
                          ],
                        ),
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
