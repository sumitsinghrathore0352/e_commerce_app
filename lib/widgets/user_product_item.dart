import 'package:e_commerce_app/providers/products.dart';
import 'package:e_commerce_app/screens/edit_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class UserProductItem extends StatelessWidget {
   final String id;
   final String title;
   final String imageUrl;
   const UserProductItem(this.id,this.title, this.imageUrl, {super.key});
  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(title),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(onPressed: (){
              Navigator.of(context).pushNamed(
                EditProductScreen.routeName,
                arguments: id,
              );
            }, icon:const Icon(Icons.edit), color: Theme.of(context).primaryColor,),
            IconButton(onPressed: (){
              Provider.of<Products>(context,listen: false).deleteProduct(id);
            }, icon:const Icon(Icons.delete) , color: Colors.red,),
          ],
        ),
      ),
    );
  }
}
