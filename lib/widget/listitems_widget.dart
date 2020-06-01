import 'package:flutter/material.dart';
import '../providers/products.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../widget/items_widget.dart';

class ListItemsWidgets extends StatelessWidget {
  ListItemsWidgets();
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = productData.item;

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        productData.item.isEmpty
            ? Column(
                children: <Widget>[
                  SizedBox(
                    height: 200,
                  ),
                  Center(
                    child: Text('No Product Yet, Starting Add Some'),
                  )
                ],
              )
            : Expanded(
                child: GridView.builder(
                  itemCount: products.length,
                  itemBuilder: (ctx, i) =>
                      ChangeNotifierProvider<Product>.value(
                    value: products[i],
                    child: ItemWidget(),
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                ),
              ),
      ],
    );
  }
}
