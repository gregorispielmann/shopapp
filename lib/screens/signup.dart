import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/userModel.dart';

class SignupScreen extends StatefulWidget {

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addController = TextEditingController();

  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Cadastro'),
        centerTitle: true,
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) { 
        if(model.isLoading){
          return Center(child: CircularProgressIndicator(),);
        }
        return Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(10),
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              validator: (text){ 
                if(text.isEmpty) return 'Nome inválido'; 
                },
              decoration: InputDecoration(
                prefix: SizedBox(
                  width: 60,
                  child: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                hintText: 'Digite seu nome completo',
              ),
            ),
            TextFormField(
              controller: _emailController,
              validator: (text){ 
                if(text.isEmpty || !text.contains('@')) return 'E-mail inválido'; 
                },
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefix: SizedBox(
                  width: 60,
                  child: Text('Email', style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                hintText: 'Digite seu E-mail',
              ),
            ),
            SizedBox(
              height: 60,
              child:
            TextFormField(
              controller: _passController,
              validator: (text){ 
                if(text.isEmpty || text.length < 6) return 'Senha inválida'; 
                },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15),
                prefix: SizedBox(
                  width: 60,
                  child: Text('Senha', style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                hintText: 'Digite sua Senha',
                suffix: IconButton(
                  // padding: EdgeInsets.fromLTRB(0,10,0,0),
                  tooltip: 'Mostrar/Esconder senha',
                  alignment: Alignment.bottomCenter,
                  icon: Icon( (_hidePass ? Icons.visibility_off : Icons.visibility), size: 20),
                  onPressed: (){ 
                      setState(() {
                          _hidePass = !_hidePass;
                      });
                  },
                ),
              ),
              obscureText: _hidePass,
            ),),
            TextFormField(
              controller: _addController,
              validator: (text){ 
                if(text.isEmpty) return 'Endereço inválido'; 
                },
              decoration: InputDecoration(
                prefix: SizedBox(
                  width: 60,
                  child: Text('End.', style: TextStyle(fontWeight: FontWeight.bold),)
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 20),
                hintText: 'Digite seu endereço completo',
              ),
            ),
            SizedBox(height: 16,),
            RaisedButton(
              child: Text('Criar conta',
              style: TextStyle(fontSize: 18),),
              onPressed: (){
                if(_formKey.currentState.validate()){

                  Map<String, dynamic> userData = {
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'address': _addController.text,
                  };

                  model.signUp(
                    onError: _onError,
                    onSuccess: _onSuccess,
                    userData: userData,
                    pass: _passController.text,
                  );
                }
              },
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              padding: EdgeInsets.symmetric(vertical: 15),
            )
          ],
        )
      ); }
    )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Usuário criado com sucesso!', style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColorLight,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(Duration(seconds: 2)).then((a){
      Navigator.of(context).pop(); 
    });
  } 

  void _onError(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Erro ao criar usuário! Verifique os campos digitados!', style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

}