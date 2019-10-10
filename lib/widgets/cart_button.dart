import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/cartModel.dart';
import 'package:shopapp/screens/cart.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CartModel>(
    builder: (context, child, model){
    return Stack(children: <Widget>[
      FloatingActionButton(
      child: Icon(Icons.shopping_cart, color: Colors.white,),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CartScreen())
        );
      },
      backgroundColor: Theme.of(context).primaryColor,
      ),
      Positioned(
        right: 0,
        top: 0,
        child: new Container(
          padding: EdgeInsets.all(2),
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0,0,0,0.7),
                offset: Offset(2,2),
                blurRadius: 2,
              )
            ],
            color: Colors.red[900],
            borderRadius: BorderRadius.circular(12),
          ),
          constraints: BoxConstraints(
            minWidth: 18,
            minHeight: 18,
          ),
          child: Text(
            model.products.length.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      )
      ],);
              });
  }
}