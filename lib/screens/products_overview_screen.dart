import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';

import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import './cart_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
   var _isLoading = false;
   var _isInit= true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState((){
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProduct().then((_){
        setState((){
          _isLoading = false;
        });
      });
    }
      _isInit = false;
      super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: FilterOptions.Favorites,
                    child: Text('Only Favorites'),
                  ),
                  const PopupMenuItem(
                    value: FilterOptions.All,
                    child: Text('Show All'),
                  ),
                ],
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              value: cart.itemCount.toString(),
              child: IconButton(
                icon: const Icon(
                  Icons.shopping_cart,
                ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
                 },
              ),
           ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? const Center(
        child: CircularProgressIndicator(),
      ):ProductsGrid(_showOnlyFavorites),
    );
  }
}
