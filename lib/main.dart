import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flare_dart/actor.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_medialogin/OurCOntainer.dart';
import 'OurTheme.dart';

void main() => runApp(Myapp());

class Myapp extends StatefulWidget {
  const Myapp({Key key}) : super(key: key);
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool _isLoggedIn = false;
  Map userProfile;
  final facebookLogin = FacebookLogin();

  _loginwithFacebook() async {
    final result = await facebookLogin.logInWithReadPermissions(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = JSON.jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          _isLoggedIn = true;
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  _logout() {
    facebookLogin.logOut();
    setState(() {
      _isLoggedIn = false;
    });
  }

  //google part

  bool _isLoggedInG = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  _login() async {
    try {
      await _googleSignIn.signIn();
      setState(() {
        _isLoggedInG = true;
      });
    } catch (err) {
      print(err);
    }
  }

  _logoutgoogle() {
    _googleSignIn.signOut();
    setState(() {
      _isLoggedInG = false;
    });
  }

  // flare animation Part

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: OurTheme().buildTheme(),
      home: Scaffold(
        body: LayoutBuilder(builder: (ctx, constrains) {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: constrains.maxHeight,
              child: Center(
                child: Column(children: [
                  OurContainer(
                    child: _isLoggedInG
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    _googleSignIn.currentUser.photoUrl),
                                radius: 60,
                              ),
                              Text(
                                _googleSignIn.currentUser.displayName,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.pinkAccent),
                              ),
                              OutlineButton(
                                child: Text("Logout"),
                                onPressed: () {
                                  _logoutgoogle();
                                },
                              )
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 200,
                                  width: 500,
                                  child: new FlareActor(
                                    "assets/google logo.flr",
                                    alignment: Alignment.center,
                                    animation: "idle",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              OutlineButton(
                                splashColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                highlightElevation: 0,
                                borderSide: BorderSide(color: Colors.blueGrey),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          image: AssetImage(
                                              "assets/google_logo.png"),
                                          height: 35.0),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Login with Google',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  _login();
                                },
                              ),
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  OurContainer(
                    child: _isLoggedIn
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userProfile["picture"]["data"]["url"]),
                                radius: 60,
                                backgroundColor: Colors.pinkAccent,
                              ),
                              Text(
                                userProfile["name"],
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                              OutlineButton(
                                  child: Text("LogOut"),
                                  onPressed: () {
                                    _logout();
                                  })
                            ],
                          )
                        : Column(
                            children: [
                              Center(
                                child: Container(
                                  height: 100,
                                  width: 500,
                                  child: new FlareActor(
                                    "assets/FaceBookLogo.flr",
                                    alignment: Alignment.center,
                                    animation: "line",
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              OutlineButton(
                                splashColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                highlightElevation: 0,
                                borderSide: BorderSide(color: Colors.blueGrey),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          image: AssetImage(
                                              "assets/facebook_logo.png"),
                                          height: 35.0),
                                      Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Text(
                                            'Login with Facebook',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                                onPressed: () {
                                  _loginwithFacebook();
                                },
                              ),
                            ],
                          ),
                  ),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
