import 'package:e_commerce_app/providers/cart.dart';
import 'package:e_commerce_app/providers/orders.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:e_commerce_app/screens/user_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<Products>(
        create: (ctx) => Products(),
      ),
      ChangeNotifierProvider<Cart>(
        create: (ctx) => Cart(),
      ),
      ChangeNotifierProvider.value(
        value: Orders(),
      ),
    ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            fontFamily: 'Lato',
          ),
          home: const ProductsOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductScreen.routeName: (ctx) => const UserProductScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen()
          }),
    );
  }
}
