import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gbpn_messages/bloc/app_bloc.dart';
import 'package:gbpn_messages/bloc/bloc.dart';
import 'package:gbpn_messages/widget/animation/FadeAnimation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final TextEditingController _controllerEmail = TextEditingController(),
      _controllerPassword = TextEditingController();
  bool _visiblePassword = false;

  @override
  void initState() {
    super.initState();
    //_controllerEmail.text = "eric+apitester@gbpn.com";
    //_controllerPassword.text = "apitestpassword";
  }

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailedState) {
              Fluttertoast.showToast(msg: "Invalid email or password");
            }
          },
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 400,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/background.png'),
                              fit: BoxFit.fill
                          )
                      ),
                      child: Stack(
                        children: <Widget>[
                          Positioned(
                            left: 30,
                            width: 80,
                            height: 200,
                            child: FadeAnimation(1, Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/light-1.png')
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            left: 140,
                            width: 80,
                            height: 150,
                            child: FadeAnimation(1.3, Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/light-2.png')
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            right: 40,
                            top: 40,
                            width: 80,
                            height: 150,
                            child: FadeAnimation(1.5, Container(
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage('assets/images/clock.png')
                                  )
                              ),
                            )),
                          ),
                          Positioned(
                            child: FadeAnimation(1.6, Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: const Center(
                                child: Text("Welcome", style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold),),
                              ),
                            )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Column(
                        children: <Widget>[
                          FadeAnimation(1.8, Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10)
                                  )
                                ]
                            ),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                      border: Border(bottom: BorderSide(color: Colors.grey[100]!))
                                  ),
                                  child: TextField(
                                    controller: _controllerEmail,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Email",
                                        hintStyle: TextStyle(color: Colors.grey[400])
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Expanded(child: TextField(
                                        controller: _controllerPassword,
                                        obscureText: !_visiblePassword,
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Password",
                                            hintStyle: TextStyle(color: Colors.grey[400])
                                        ),
                                      )),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _visiblePassword = !_visiblePassword;
                                            });
                                          },
                                          icon: Icon(!_visiblePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.grey,))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                          const SizedBox(height: 30,),
                          FadeAnimation(2, Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => handleLogin(),
                              splashColor: Colors.grey,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(116, 124, 255, 1.0),
                                          Color.fromRGBO(143, 148, 251, .8),
                                        ]
                                    )
                                ),
                                child: const Center(
                                  child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
                                ),
                              ),
                            ),
                          )),
                          const SizedBox(height: 70,),
                          /*FadeAnimation(1.5, TextButton(
                          style: TextButton.styleFrom(backgroundColor: Colors.transparent),
                          onPressed: () {

                          },
                          child: const Text("Forgot Password?", style: TextStyle(color: Color.fromRGBO(116, 124, 255, 1.0)),),
                        )),*/
                        ],
                      ),
                    )
                  ],
                ),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  if (state is AuthLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          ),
        )
    );
  }

  void handleLogin() {
    String email = _controllerEmail.text.toString();
    String password = _controllerPassword.text.toString();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: "Email is required");
      return;
    } else if (password.isEmpty) {
      Fluttertoast.showToast(msg: "Password is required");
      return;
    } else {
      AppBloc.authBloc.add(AuthLoginEvent(email: email, password: password));
    }
  }
}
