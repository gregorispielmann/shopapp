import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {

  String orderId;

  OrderTile (this.orderId);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance.collection('orders').document(orderId).snapshots(),
          builder: (context, snapshot){
            if(!snapshot.hasData){
              return Center(child: CircularProgressIndicator(),);
            } else {
              int status = snapshot.data['status'];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Código do pedido: ${snapshot.data.documentID}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16,),
                  Text(
                    _buildProductsText(snapshot.data)
                  ),
                  SizedBox(height: 16,),
                  Divider(),
                  Text('Status do pedido',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildCircle('1', 'Preparação', status, 1),
                      Container(height: 1, width: 50, color: Colors.grey[500],),
                      _buildCircle('2', 'Envio', status, 2),
                      Container(height: 1, width: 50, color: Colors.grey[500],),
                      _buildCircle('3', 'Entregue', status, 3),
                  ],)
                ],
              );
            }
          }
        )
      )
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot){
    String text = 'Descrição:\n';
    for(LinkedHashMap p in snapshot.data['products']){
      text += '${p['quantity']} x ${p['product']['title']} R\$ ${p['product']['price'].toStringAsFixed(2).replaceAll('.',',')}\n';
    }

    text += 'Total: R\$ ${snapshot.data['totalPrice'].toStringAsFixed(2).replaceAll('.',',')}';
    return text;
  }

  Widget _buildCircle(String number, String subtitle, int status, int thisStatus){

    Color backColor;
    Widget child;

    if(status < thisStatus){
      backColor = Colors.grey[500];
      child = Text(number, style: TextStyle(color: Colors.white));
    } else if (status == thisStatus){
      backColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Text(number, style: TextStyle(color: Colors.white),),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
      );
    } else {
      backColor = Colors.green;
      child = Icon(Icons.check, color: Colors.white,);
    }

    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 20,
          backgroundColor: backColor,
          child: child,
        ),
        Text(subtitle)
    ],);
  }

}