import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/data/cart_product.dart';
import 'package:shopapp/data/product_data.dart';
import 'package:shopapp/models/cartModel.dart';
import 'package:shopapp/models/userModel.dart';
import 'package:shopapp/screens/cart.dart';
import 'package:shopapp/screens/login.dart';

class ProductScreen extends StatefulWidget {

  final ProductData product;

  ProductScreen(this.product);

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

  final ProductData product;

  String size;

  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.title),
          centerTitle: true,
        ),
        body: ListView(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 0.9,
              child: Carousel(
                autoplay: true,
                images: product.images.map((url){
                  return NetworkImage(url);
                }).toList(),
                dotSize: 5,
                dotBgColor: Colors.transparent,
                animationCurve: Curves.easeInOutCubic,
                animationDuration: Duration(seconds: 1),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(product.title,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  maxLines: 3,
                  ),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(fontSize: 35),
                  ),
                  SizedBox(height: 16,),
                  Text('Tamanho', style: TextStyle(fontSize: 12),),
                  SizedBox(
                    height: 35,
                    child: GridView(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(vertical: 5),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 0,
                        childAspectRatio: 0.5,
                      ),
                      children: product.sizes.map((s){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              size = s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: Colors.pink),
                              color: s == size ? Colors.pinkAccent : Colors.transparent,
                            ),
                            width: 50,
                            alignment: Alignment.center,
                            child: Text(s.toUpperCase())
                          ),
                        );
                      }).toList(),
                    )
                  ),
                  SizedBox(height: 16,),
                  SizedBox(
                    height: 45,
                    child: RaisedButton(
                      color: Colors.pinkAccent,
                      onPressed: size != null ? (){
                        if(UserModel.of(context).isLoggedIn()){
                          
                          CartProduct cartProduct = CartProduct();

                          cartProduct.size = size;
                          cartProduct.quantity = 1;
                          cartProduct.pid = product.id;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CartScreen())
                          );

                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => LoginScreen())
                          );
                        }
                      } : null,
                      child: Text(UserModel.of(context).isLoggedIn() ? 'Adicionar ao carrinho' : 'Entre para comprar',
                      style: TextStyle(color: Colors.white, fontSize: 18),),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Text('Descrição do produto', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10,),
                  Text(product.description.toString(), style: TextStyle(fontSize: 15),),
              ],),
            )
          ],
        )
      )
    );
  }
}