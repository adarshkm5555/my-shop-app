import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOption {
  favourite,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  @override
  void initState() {
    // Provider.of<Products>(context)
    //     .fetchData();                            //This won't work in initState, but it will work listen: is set to false.

    // Future.delayed(Duration.zero).then((_) {
    //   //alternate way of fetching data from server.
    //   Provider.of<Products>(context).fetchData();
    // });
    super.initState();
  }

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
      _isLoading = true;
      });
      Provider.of<Products>(context).fetchData().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  var _showOnlyFavourites = false;

  Color get color => Colors.redAccent;
  @override
  Widget build(BuildContext context) {
    // final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Shop"),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) =>
                Badge(color, value: cart.itemCounts.toString(), child: ch!),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart)),
          ),
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOption selectedValue) {
                setState(() {
                  if (selectedValue == FilterOption.favourite) {
                    // productsContainer.showFavouritesOnly();
                    _showOnlyFavourites = true;
                  } else {
                    // productsContainer.showAll();
                    _showOnlyFavourites = false;
                  }
                });
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      child: Text("Only Favourite"),
                      value: FilterOption.favourite,
                    ),
                    const PopupMenuItem(
                      child: Text("Show All"),
                      value: FilterOption.all,
                    ),
                  ]),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ProductsGrid(_showOnlyFavourites),
    );
  }
}
