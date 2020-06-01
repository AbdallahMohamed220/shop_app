import 'package:flutter/material.dart';
import 'package:food_app/providers/auth.dart';
import 'package:food_app/providers/order.dart';
import 'package:food_app/providers/products.dart';
import 'package:food_app/screens/auth_screen.dart';
import 'package:food_app/screens/cart_screen.dart';
import 'package:food_app/screens/details_screen.dart';
import 'package:food_app/screens/edit_product_screen.dart';
import 'package:food_app/screens/favorite_screen.dart';
import 'package:food_app/screens/home_screen.dart';
import 'package:food_app/screens/manage_data_screen.dart';
import 'package:food_app/screens/search_screen.dart';
import 'package:food_app/screens/tab_screen.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.item),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrder) => Orders(auth.token, auth.userId,
              previousOrder == null ? [] : previousOrder.orders),
        ),
        ChangeNotifierProvider<Cart>.value(
          value: Cart(),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: Color(0xff06beb6),
              accentColor: Colors.red,
              cardColor: Colors.white,
              fontFamily: 'future'),
          home: auth.isAuth ? TabsScreen() : AuthScreen(),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
            SearchScreen.routName: (ctx) => SearchScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            FavoritesScreen.routName: (ctx) => FavoritesScreen(),
            ManageData.routeName: (ctx) => ManageData(),
            MyHomePage.routName: (ctx) => MyHomePage(),
            DetailsPage.routName: (ctx) => DetailsPage(),
            EditProductScreen.routName: (ctx) => EditProductScreen()
          },
        ),
      ),
    );
  }
}
