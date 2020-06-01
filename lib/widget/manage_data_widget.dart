import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class ManageDataWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ManageDataWidget(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('Attention Please'),
                            content:
                                Text('Are You Sure To Delete This Product'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Okey'),
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  await Provider.of<Products>(context)
                                      .removeProduct(id);
                                },
                              )
                            ],
                          ));
                } catch (error) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
