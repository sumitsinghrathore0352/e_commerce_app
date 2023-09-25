import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:e_commerce_app/widgets/app_drawer.dart';
import 'package:e_commerce_app/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
class UserProductScreen extends StatelessWidget {
  const UserProductScreen({Key? key}) : super(key: key);
  static const routeName = "/user-products";
  Future<void> _refreshProducts(BuildContext context) async{
  await Provider.of<Products>(context).fetchProducts();
  }
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
         IconButton(onPressed: (){
           Navigator.of(context).pushNamed(
             EditProductScreen.routeName
           );
         }, icon:const  Icon(Icons.add))
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
              itemCount: productData.items.length,
              itemBuilder: (_,i) => Column(
                children: [
                  UserProductItem(productData.items[i].id,productData.items[i].title, productData.items[i].imageUrl),
                  const Divider(),
                ],
              )
          ),
        ),
      ),
    );
  }
}
