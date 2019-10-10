import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/userModel.dart';
import 'package:shopapp/screens/login.dart';
import 'package:shopapp/tiles/drawer_tiles.dart';

class MyDrawer extends StatelessWidget {

  final PageController pageController;
  
  MyDrawer(this.pageController);

  @override
  Widget build(BuildContext context) {
   
  Widget buildDrawerBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Colors.pink[300],
          Colors.pink[100]
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight
      )
    ),
  );

  return Drawer(
    child: Stack(
      children: <Widget>[
        buildDrawerBack(),
        ListView(
          padding: EdgeInsets.fromLTRB(30,30,0,0),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(10),
              height: 150,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Column(children: <Widget>[
                      Text('ShopApp',
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    Text('by Gregori Spielmann', style: TextStyle(fontSize: 10),)
                    ],) 
                  ),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: ScopedModelDescendant<UserModel>(
                      builder: (context, child, model){
                        return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text('Olá ${!model.isLoggedIn() ? 'visitante' : model.userData['name'].contains(' ') ? model.userData['name'].split(' ')[0] : model.userData['name']}!',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      GestureDetector(
                        child: Text(
                          !model.isLoggedIn() ? 'Entre ou cadastre-se >' : 'Logout',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: (){
                          if(!model.isLoggedIn()){
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => LoginScreen())
                            );
                          } else {
                            model.signOut();
                          }
                          
                        },
                      )
                    ],);
                      },
                    )
                  )
                ],
              )
            ),
            Divider(),
            DrawerTile(Icons.home,'Início', pageController, 0),
            DrawerTile(Icons.list, 'Produtos',pageController, 1),
            DrawerTile(Icons.location_on, 'Lojas',pageController, 2),
            DrawerTile(Icons.playlist_add_check,'Meus pedidos',pageController, 3),
          ],
        )
      ],
    )
  );

  }
}