import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/cartModel.dart';
import 'package:shopapp/models/userModel.dart';
import 'package:shopapp/screens/login.dart';
import 'package:shopapp/screens/order.dart';
import 'package:shopapp/tiles/cart.dart';
import 'package:shopapp/widgets/cart_price.dart';
import 'package:shopapp/widgets/discount_card.dart';
import 'package:shopapp/widgets/ship_cart.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carrinho'),
        centerTitle: true,
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(0,0,10,0),
            child: ScopedModelDescendant<CartModel>(
              builder: (context, child, model){
                int p = model.products.length;
                return Text(
                  '${p ?? 0} ${p == 1 ? 'item' : 'itens'}',
                  style: TextStyle(fontSize: 20),
                );
              },
            ) 
          ),
        ],
      ),
      body: ScopedModelDescendant<CartModel>(
        builder: (context, child, model) {
          if(model.isLoading && UserModel.of(context).isLoggedIn()){
            return Center(
              child: CircularProgressIndicator()
            );
          } else if (!UserModel.of(context).isLoggedIn()){
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.remove_shopping_cart, size: 80, color: Theme.of(context).primaryColor,),
                  SizedBox(height: 16,),
                  Text('Faça o login para comprar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                    ),
                    textAlign: TextAlign.center,
                  ),
                  RaisedButton(
                    child: Text('Entrar',
                    style: TextStyle(fontSize: 18),),
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen())
                      );
                    },
                  )
              ],),
            );
          } else if(model.products == null || model.products.length == 0){
            return Center(
              child: Text('Nenhum produto no carrinho',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ));
          } else {
            return ListView(
              children: <Widget>[
                Column(
                  children: model.products.map((p){
                    return CartTile(p);
                  }).toList(), 
              ),
              DiscountCard(),
              ShipCard(),
              CartPrice(() async {
                String orderId = await model.finishOrder();
                if(orderId != null){
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => OrderScreen(orderId))
                  );
                } 
              }),
              ],
            );
          }
        }
      ),
    );
  }
}