import 'package:flutter/material.dart';
import 'package:shopapp/tabs/home.dart';
import 'package:shopapp/tabs/orders.dart';
import 'package:shopapp/tabs/places.dart';
import 'package:shopapp/tabs/products.dart';
import 'package:shopapp/widgets/cart_button.dart';
import 'package:shopapp/widgets/drawer.dart';

class Home extends StatelessWidget {

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          body: HomeTab(),
          drawer: MyDrawer(_pageController),
          floatingActionButton: CartButton(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Produtos'),
            centerTitle: true,
          ),
          floatingActionButton: CartButton(),
          drawer: MyDrawer(_pageController),
          body: Products(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Lojas'),
            centerTitle: true,
          ),
          body: PlacesTab(),
          drawer: MyDrawer(_pageController),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text('Meus Pedidos'),
            centerTitle: true,
          ),
          body: OrdersTab(),
          drawer: MyDrawer(_pageController),
        ),


        
    ],);
  }
}