import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shopapp/models/userModel.dart';
import 'package:shopapp/screens/signup.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool _hidePass = true;

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
        actions: <Widget>[
            FlatButton(
              child: Text('Criar conta',
              style: TextStyle(
                fontSize: 15
              ),
              ),
              textColor: Colors.white,
              onPressed: (){
                  Navigator.of(context).pushReplacement( 
                    MaterialPageRoute(builder: (context) => SignupScreen())
                  );
              },
            )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoading){
            return Center( child: CircularProgressIndicator());
          } else {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(30,30,30,10),
                children: <Widget>[
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
                  TextFormField(
                    controller: _passController,
                    validator: (text){ 
                      if(text.isEmpty || text.length < 6) return 'Senha inválida'; 
                      },
                    decoration: InputDecoration(
                      prefix: SizedBox(
                        width: 60,
                        child: Text('Senha', style: TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      hintText: 'Digite sua Senha',
                      suffix: IconButton(
                        icon: Icon( _hidePass ? Icons.visibility_off : Icons.visibility),
                        onPressed: (){ 
                            setState(() {
                                _hidePass = !_hidePass;
                            });
                        },
                      ),
                    ),
                    obscureText: _hidePass,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child: Text('Esqueci a senha'),
                      onPressed: (){
                        if(_emailController.text.isEmpty){
                        _scaffoldKey.currentState.showSnackBar(
                          SnackBar(content: Text('Insira seu e-mail para redefinir', style: TextStyle(fontSize: 16, color: Colors.white),),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 5),
                          ),
                        );
                        } else {
                          model.recoverPass(_emailController.text);
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(content: Text('Confira seu e-mail para redefinir!', style: TextStyle(fontSize: 16, color: Colors.white),),
                              backgroundColor: Theme.of(context).primaryColorLight,
                              duration: Duration(seconds: 5),
                            ),
                          );
                        }
                      },
                      padding: EdgeInsets.all(0),
                    )
                  ),
                  SizedBox(height: 16,),
                  RaisedButton(
                    child: Text('Entrar',
                    style: TextStyle(fontSize: 18),),
                    onPressed: (){
                      if(_formKey.currentState.validate()){
                        
                      }

                      model.signIn(
                        email: _emailController.text,
                        pass: _passController.text,
                        onError: _onError,
                        onSuccess: _onSuccess 
                      );
                    },
                    textColor: Colors.white,
                    color: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 15),
                  )
                ],
              )
            );
        } }
      )
    );
  }

  void _onSuccess(){
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text('Login realizado com sucesso!', style: TextStyle(fontSize: 16, color: Colors.white),),
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
      SnackBar(content: Text('Erro ao fazer login! Verifique e-mail e/ou senha!', style: TextStyle(fontSize: 16, color: Colors.white),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

}