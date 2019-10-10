import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/cartModel.dart';
import 'package:shopapp/models/userModel.dart';
import 'package:shopapp/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          return ScopedModel<CartModel>(
            model: CartModel(model),
            child: MaterialApp(
              title: 'ShopApp',
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColorLight: Colors.pink[700],
                primaryColorDark: Colors.white,
                primaryColor: Colors.pinkAccent,
              ),
              home: Home(),
            )
          );
        },
      )
  );
  }
}
