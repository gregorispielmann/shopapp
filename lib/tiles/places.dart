import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  PlaceTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
        SizedBox(
          height: 150,
          child: Image.network(
            snapshot.data['image'],
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(snapshot.data['title'], 
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
              Text(snapshot.data['address'],
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.start,
              ),
          ]
          ,),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            FlatButton(
              child: Text('Ver no mapa', style: TextStyle(color: Colors.blue)),
              padding: EdgeInsets.all(0),
              onPressed: (){
                launch('https://www.google.com/maps/search/?api=1&query=${snapshot.data['lat']},${snapshot.data['long']}');
              },
            ),
            FlatButton(
              child: Text('Ligar', style: TextStyle(color: Colors.blue)),
              padding: EdgeInsets.all(0),
              onPressed: (){
                launch('tel:${snapshot.data['phone']}');
              },
            ),

          ],
        )
        

      ],),
    );
  }
}