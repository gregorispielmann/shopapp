import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/screens/category.dart';

class CategoryTile extends StatelessWidget {
  
  final DocumentSnapshot snapshot;

  CategoryTile(this.snapshot);
  
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(snapshot.data['icon']),
        backgroundColor: Colors.transparent,
        radius: 25,
      ),
      title: Text(snapshot.data['title']),
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Category(snapshot)
          )
        );
      },
    );
  }
}