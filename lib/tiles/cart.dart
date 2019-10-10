import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/data/cart_product.dart';
import 'package:shopapp/data/product_data.dart';
import 'package:shopapp/models/cartModel.dart';

class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent(){

      CartModel.of(context).updatePrice();
      
      return Row(
        children: <Widget>[
          Container(
            width: 120,
            child: Image.network(cartProduct.productData.images[0],
              fit: BoxFit.cover,
            ),
            padding: EdgeInsets.all(8)
          ),
          Expanded(
            child:
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Text(cartProduct.productData.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text('Tamanho: ${cartProduct.size}', style: TextStyle(fontWeight: FontWeight.w300),),
                Text('R\$ ${cartProduct.productData.price.toStringAsFixed(2).replaceAll('.', ',')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                  IconButton(icon: Icon(Icons.remove),
                    color: Theme.of(context).primaryColor,
                    onPressed: cartProduct.quantity > 1 ? (){

                      CartModel.of(context).decProduct(cartProduct);

                    } : null,
                  ),
                  Text(cartProduct.quantity.toString()),
                  IconButton(icon: Icon(Icons.add),
                    color: Theme.of(context).primaryColor,
                    onPressed: (){

                      CartModel.of(context).incProduct(cartProduct);

                    },
                  ),
                  FlatButton(
                    child: Text('Remover'),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    onPressed: (){
                      CartModel.of(context).removeCartItem(cartProduct);
                    },
                  )
                ],)

              ],)
            )
          )
      ],);
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: cartProduct.productData == null ? 
        FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance.collection('products').document(cartProduct.category).collection('items').document(cartProduct.pid).get(),
          builder: (context, snapshot){
            if(snapshot.hasData){
              cartProduct.productData = ProductData.fromDocument(snapshot.data);
              return _buildContent();
            } else {
              return Container(
                height: 70,
                child: CircularProgressIndicator(),
                alignment: Alignment.center
              );
            }
          },
        ) :
        _buildContent()
    );
  }
}