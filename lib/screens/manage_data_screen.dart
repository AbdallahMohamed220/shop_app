import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widget/manage_data_widget.dart';

import './edit_product_screen.dart';

class ManageData extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchAndSetData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);
    print('rebuilding...');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routName);
            },
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Provider.of<Auth>(context).logout();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemCount: productsData.item.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              ManageDataWidget(
                                productsData.item[i].id,
                                productsData.item[i].title,
                                productsData.item[i].imgUrl,
                              ),
                              Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
