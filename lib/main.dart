import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helper/custom_route.dart';
import 'package:shop_app/provider/auth.dart';
import 'package:shop_app/provider/cart.dart';
import 'package:shop_app/provider/order.dart';
import 'package:shop_app/provider/product_provider.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/editing_product_screen.dart';
import 'package:shop_app/screens/order_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
// import 'package:shop_app/screens/splash_screen.dart';
//import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_product_screen.dart';

void main() {
  runApp(const MyApp());
}

final ThemeData theme = ThemeData();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider(
      create: (ctx)=>Auth(),
      ),
      ChangeNotifierProxyProvider<Auth,Products>(
        update: (ctx,auth,previousProducts)=>Products(auth.token ?? "",auth.userId ?? "", previousProducts == null ? []:previousProducts.items),
      create: (ctx) => Products("","",[]),
      ),
      ChangeNotifierProvider(
      create: (ctx) => Cart(),
      ),
      ChangeNotifierProxyProvider<Auth,Orders>(
      update: (ctx,auth,previousOrder)=>Orders(auth.token ?? "",auth.userId ?? "", previousOrder == null ? []:previousOrder.orders),
      create: (ctx) => Orders("","",[]),
      ),
    ],

    
      child: Consumer<Auth>(builder: (context,auth,_)=>
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: theme.copyWith(
          pageTransitionsTheme: PageTransitionsTheme(
            builders: {
              TargetPlatform.android:CustomPageTransitionBuilder(),
            }
          ),
          
          primaryColor: Colors.purple,
          colorScheme: theme.colorScheme.copyWith(secondary: Colors.deepOrange,primary: Colors.purple,primaryVariant: Colors.white),
        ),
        home: auth.isAuth ? const ProductOverviewScreen() : FutureBuilder(
          future: auth.tryAutoLogin(),
          
        builder: (ctx,snapshot)=>const AuthScreen(),),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName : (ctx)=> const CartScreen(),
          OrderScreen.routeName : (ctx)=> const OrderScreen(),
          UserProductsScreen.routeName : (ctx) => const UserProductsScreen(),
          EditProductScreen.routeName : (ctx)=> const EditProductScreen(),

        },
      ),

      ),
      
    );
  }
}
