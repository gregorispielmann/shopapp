import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {

  String id;
  String category;
  String title;
  
  double price;
  String description;
  
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot){

    id = snapshot.documentID;
    title = snapshot.data['title'];
    description = snapshot.data['description'];
    price = double.parse(snapshot.data['price']) + 0.0; // forçar int em double (Ex: 20 em 20.00)
    images = snapshot.data['images'];
    sizes = snapshot.data['sizes'];

  }

  Map<String, dynamic> toResumeMap(){
    return {
      'title': title,
      'description': description,
      'price': price
    };
  }

}