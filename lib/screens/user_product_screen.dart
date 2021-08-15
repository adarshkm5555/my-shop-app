import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/editing_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/userProductScreen";
  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async{
    await Provider.of<Products>(context,listen: false).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder:(ctx,snapshot)=> snapshot.connectionState == ConnectionState.waiting ? const Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh: ()=> _refreshProducts(context),
          child: Consumer<Products>(
            builder: (ctx,productData,_)=>
            Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productData.items.length,
                itemBuilder: (ctx, i) => Column(
                  children: [
                    UserProductItem(
                        id: productData.items[i].id,
                        title: productData.items[i].title,
                        imageUrl: productData.items[i].imageUrl),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
