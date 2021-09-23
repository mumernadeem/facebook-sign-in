import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
class LoginWithFacebook extends StatefulWidget {
  const LoginWithFacebook({Key key}) : super(key: key);

  @override
  _LoginWithFacebookState createState() => _LoginWithFacebookState();
}

class _LoginWithFacebookState extends State<LoginWithFacebook> {
  bool isSignIn = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  User _user;
  FacebookLogin facebookLogin = FacebookLogin();
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("facebook login"),
      ),
      body: isSignIn
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: NetworkImage(_user.photoURL),
            ),
            Text(
              _user.displayName,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 30,
            ),
            OutlineButton(
              onPressed: () {
                gooleSignout();
              },
              child: Text(
                "Logout",
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        ),
      )
          : Center(
        child: OutlineButton(
          onPressed: () async {
            await SignFB();
          },
          child: Text(
            "Login with facebook",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      setState(() {
        facebookLogin.logOut();
        isSignIn = false;
      });
    }
    );
  }
  Future SignFB() async {
    EasyLoading.show(status: 'Loading...');
    final FacebookLogin facebookSignIn = new FacebookLogin();
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);
    final FacebookAccessToken accessToken = result.accessToken;
    AuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
    var a = await _auth.signInWithCredential(credential);
    await FirebaseAuth.instance.signOut();
    await facebookSignIn.logOut();
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        print('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        final facebookAuthCredential =
        FacebookAuthProvider.credential(result.accessToken.token);
        print(facebookAuthCredential);
        final credential = await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
        print(credential.user.email);
        setState(() {
          isSignIn = true;
          _user = a.user;
        });
    }
  }}