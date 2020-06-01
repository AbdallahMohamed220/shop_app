import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class DetailsPage extends StatefulWidget {
  static const routName = 'detils_Page';

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadData =
        Provider.of<Products>(context, listen: false).findById(productId);

    return Scaffold(
      body: ListView(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(height: 300.0),
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/green.jpg'),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(100.0),
                        bottomRight: Radius.circular(100.0))),
              ),
              Positioned(
                  top: 50.0,
                  left: (MediaQuery.of(context).size.width / 2) - 125,
                  child: Container(
                    height: 250.0,
                    width: 250.0,
                    child: Hero(
                      tag: loadData.imgUrl,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(loadData.imgUrl),
                      ),
                    ),
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(Icons.more_horiz),
                  color: Colors.white,
                  onPressed: () {},
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(loadData.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 10.0),
                Text('\$${loadData.price}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 15.0),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('About The Food',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        fontSize: 18.0,
                        color: Colors.black)),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  child: Text(
                    loadData.description,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w500,
                        fontSize: 22.0,
                        color: Colors.black),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
