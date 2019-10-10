import 'package:flutter/material.dart';
import 'package:shopapp/data/product_data.dart';
import 'package:shopapp/screens/product.dart';

class ProductTile extends StatelessWidget {

  final String type;
  final ProductData product;

  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ProductScreen(product)
        ),);
      },
      child: Card(
        child: type == 'grid' ?
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.9,
              child: Image.network(product.images[0], fit: BoxFit.cover,),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(children: <Widget>[
                  Text(product.title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  ),
                  Text('R\$ ${product.price.toStringAsFixed(2).replaceAll('.',',')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) 
                  )
                ],)
              ),
            )
        ],) :
        Row(children: <Widget>[
            Flexible(
              flex: 2,
              child: Image.network(product.images[0],
              fit: BoxFit.cover,
  
              )
            ),
            Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  Text(product.title,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)
                  ),
                  Text('R\$ ${product.price.toStringAsFixed(2).replaceAll('.',',')}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold) 
                  )
                ],)
              )
            )
        ],),
      ),
    );
  }
}