import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';


class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  bool queroEntrar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "YE Gestão de Saúde",
            style: TextStyle(fontSize: 20),
          ),
          backgroundColor: Color.fromARGB(208, 202, 201, 201),
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Color.fromARGB(255, 207, 206, 206),
        body: SingleChildScrollView(
            child: Center(
                child: Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 2.0),
                    child: Form(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          Image.asset(
                            "assets/Logo Escuro.png",
                            height: 250,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 10.0, right: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  label: Text("Login",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 44, 44, 44))),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 44, 44, 44)))),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                  label: Text(
                                    "Senha",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 44, 44, 44)),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 44, 44, 44)))),
                              obscureText: true,
                            ),
                          ),
                          Visibility(
                              visible: !queroEntrar,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        label: Text(
                                          "e-mail",
                                          style: TextStyle(
                                              color: const Color.fromARGB(
                                                  255, 44, 44, 44)),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 44, 44, 44))),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.only(
                                          top: 20.0, left: 10.0, right: 10.0),
                                      child: Theme(
                                        data: ThemeData(
                                            primaryColor:
                                                Color.fromARGB(255, 44, 44, 44),
                                            textTheme: TextTheme(
                                                bodyLarge: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 44, 44, 44)))),
                                        child: InputDatePickerFormField(
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime.now(),
                                          fieldLabelText:
                                              "Nascimento ( Mês/ Dia / Ano)",
                                        ),
                                      ))
                                ],
                              )),
                              SizedBox(height: 30,),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: ElevatedButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all(Colors.grey),
                                ),
                                child: Text(
                                  (queroEntrar) ? "Entrar" : "Cadastrar",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: ElevatedButton(
                              onPressed: () {_logarComGoogle();},
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color.fromARGB(255, 240, 82, 82)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(FontAwesomeIcons.google,
                                      color: Colors.white),
                                  SizedBox(width: 5),
                                  Text(
                                    "Entrar com o Google",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  queroEntrar = !queroEntrar;
                                });
                              },
                              child: Text(
                                (queroEntrar)
                                    ? "Ainda não tem conta? Cadastre-se!"
                                    : "Já tem conta? Entre!",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 44, 44, 44),
                                    fontSize: 20),
                              ))
                        ]))))));
  }
}

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
       
      } else {
        
      }
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        
      } else {
        
      }
      return null;
    }
  }
}

Future<void> _logarComGoogle() async {
    final GoogleSignIn _logarComGoogle = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _logarComGoogle.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        // final UserCredential userCredential =
        //     await _fi.signInWithCredential(credential);

        // // Navegue para a próxima tela após o login com sucesso
        // if (userCredential.user != null) {
        //   Navigator.pushNamed(context as BuildContext, "/home");
        // }
      }
    } catch (e) {
      
    }
  }

    

