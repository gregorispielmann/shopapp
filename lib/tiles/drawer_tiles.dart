import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 70,
          child: Row(children: <Widget>[
            Icon(icon,
            size: 30,
            color: controller.page.round() == page ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,
            ),
            SizedBox(width: 32,),
            Text(
              text,
              style: TextStyle(fontSize: 16, color: controller.page.round() == page ? Theme.of(context).primaryColorDark : Theme.of(context).primaryColorLight,),
            )
          ],),
        ),
      ),
    );
  }
}