import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/models/cartModel.dart';

class DiscountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(
          'Cupom de desconto',
          textAlign: TextAlign.start,
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey[700]),
        ),
        leading: Icon(Icons.card_giftcard),
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: TextFormField(
            initialValue: CartModel.of(context).couponCode ?? '',
            onFieldSubmitted: (text){
              Firestore.instance.collection('coupons').document(text).get().then((doc){
                if(doc.data != null){
                  
                  CartModel.of(context).setCoupon(text, doc.data['value']);

                  Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text('Cupom inserido! Desconto de ${doc.data['value']}% aplicado!',
                    style: TextStyle(fontSize: 16),
                   ),
                    backgroundColor: Theme.of(context).primaryColor,
                   )
                   );
                } else {
                  CartModel.of(context).setCoupon(null, 0);
                  Scaffold.of(context).showSnackBar(
                   SnackBar(content: Text('Cupom Inválido!',
                    style: TextStyle(fontSize: 16),
                   ),
                    backgroundColor: Colors.red,
                   )
                  );
                }
              });
            },
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu cupom',
              ),
            )
          )

        ],
      ),
    );
  }
}