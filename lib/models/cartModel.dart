import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/data/cart_product.dart';
import 'package:shopapp/models/userModel.dart';

class CartModel extends Model {

  bool isLoading = false;

  UserModel user;
  
  List<CartProduct> products = [];

  String couponCode;
  int discount = 0;

  Future<String> finishOrder() async {
    if(products.length == 0){
      return null;
    }

    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discountPrice = getDiscount();

    DocumentReference refOrder = await Firestore.instance.collection('orders').add(
      {
        'clientId': user.firebaseUser.uid,
        'products': products.map((cartProduct) => cartProduct.toMap()).toList(),
        'shipPrice': shipPrice,
        'productsPrice': productsPrice,
        'discount': discountPrice + 0.00,
        'totalPrice': productsPrice - discountPrice + shipPrice,
        'status': 1
      }
    );
    await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('orders').document(refOrder.documentID).setData({
      'orderId': refOrder.documentID,
    });

    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    discountPrice = 0;
    couponCode = null;
    isLoading = false;
    notifyListeners();

    return refOrder.documentID;

  }


  void updatePrice(){
    notifyListeners();
  }

  CartModel(this.user){
    if(user.isLoggedIn()){
      _loadCartItems();
    }
  }

  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null){
        price += c.quantity * c.productData.price;
      }
    }
    return price;
  }

  double getShipPrice(){
    return 9.99;
  }

  double getDiscount(){
    return getProductsPrice() * discount / 100;
  }

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').add(cartProduct.toMap()).then((doc){
      cartProduct.cid = doc.documentID;
    });

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).delete();

    products.remove(cartProduct);

    notifyListeners();
  }
  
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--;
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;
    Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').document(cartProduct.cid).updateData(cartProduct.toMap());
    notifyListeners();
  }

  Future _loadCartItems() async {
    QuerySnapshot query = await Firestore.instance.collection('users').document(user.firebaseUser.uid).collection('cart').getDocuments();

    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).toList();

    notifyListeners();
  }

  void setCoupon(String couponCode, int discount){
    this.couponCode = couponCode;
    this.discount = discount;
  }

}