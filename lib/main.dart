import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => new LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
//  final FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormState>();
  bool _validate = false;
  String email;
  String password;
  String resetEmail;

  // The controller for the email field
  final _emailController = TextEditingController();

  // The controller for the password field
  final _passwordController = TextEditingController();

  // Creates the 'forgot password' and 'create account' buttons
  Widget _accountButtons() {
    return Container(
      child: Expanded(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    child: new FlatButton(
                      padding: const EdgeInsets.only(top: 50.0, right: 150.0),
                      onPressed: () => sendPasswordResetEmail(),
                      child: Text("Forgot Password",
                          style: TextStyle(color: Colors.black)),
                    ),
                  )
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  child: new FlatButton(
                    padding: const EdgeInsets.only(top: 50.0),
                    onPressed: () {},
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            )
          ])),
    );
  }

  // Creates the email and password text fields
  Widget _textFields() {
    return Form(
        key: _formKey,
        autovalidate: _validate,
        child: Column(
          children: <Widget>[
            Container(
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(width: 0.5, color: Colors.grey),
                ),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 65.0),

              // Email text field
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Icon(
                      Icons.email,
                      color: Colors.white,
                    ),
                  ),
                  new Expanded(
                    child: TextFormField(
                      validator: validateEmail,
                      onSaved: (String val) {
                        email = val;
                      },
                      keyboardType: TextInputType.emailAddress,
                      autofocus: true,
                      // cursorColor: Colors.green,
                      controller: _emailController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',

                        //  contentPadding: EdgeInsets.fromLTRB(45.0, 10.0, 20.0, 1.0),
                        contentPadding: EdgeInsets.only(left: 55.0, top: 15.0),
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),

            // Password text field
            Container(
              decoration: new BoxDecoration(
                border: new Border(
                  bottom: new BorderSide(
                    width: 0.5,
                    color: Colors.grey,
                  ),
                ),
              ),
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 65.0),
              child: Row(
                children: <Widget>[
                  new Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  new Expanded(
                    child: TextFormField(
                        validator: _validatePassword,
                        onSaved: (String val) {
                          password = val;
                        },
                        //  cursorColor: Colors.green,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Password',
                          contentPadding:
                              EdgeInsets.only(left: 50.0, top: 15.0),
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),

                        // Make the characters in this field hidden
                        obscureText: true),
                  )
                ],
              ),
            )
          ],
        ));
  }

  // Creates the button to sign in
  Widget _signInButton() {
    return new Container(
        width: 200.0,
        margin: const EdgeInsets.only(top: 20.0),
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: RaisedButton(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  splashColor: Colors.white,
                  color: Colors.green,
                  child: new Row(
                    children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Text(
                          "Sign in",
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _signIn();
                    });
                  }),
            ),
          ],
        ));
  }

  // Signs in the user
  void _signIn() async {
    // Grab the text from the text fields
    final email = _emailController.text;
    final password = _passwordController.text;

    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Fluttertoast.showToast(
            msg: "Signing in...",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 2);

//        firebaseUser = await _auth.signInWithEmailAndPassword(
//            email: email, password: password);

        // If user successfully signs in, go to the pro categories page
//        Navigator.pushReplacement(
//            context,
//            MaterialPageRoute(
//                builder: (context) => ProCategories(firebaseUser)));
      } catch (exception) {
        print(exception.toString());

        Fluttertoast.showToast(
            msg: "${exception.toString()}",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 3);
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  // Creates an alertDialog for the user to enter their email
  Future<String> _resetDialogBox() {
    final resetEmailController = TextEditingController();

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text(
            'Reset Password',
            style: TextStyle(color: Colors.black),
          ),
          content: new SingleChildScrollView(
              child: new Form(
            key: _resetKey,
            autovalidate: _validate,
            child: ListBody(
              children: <Widget>[
                new Text(
                  'Enter the Email Address associated with your account.',
                  style: TextStyle(fontSize: 14.0),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                ),
                Row(
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Icon(
                        Icons.email,
                        size: 20.0,
                      ),
                    ),
                    new Expanded(
                      child: TextFormField(
                        validator: validateEmail,
                        onSaved: (String val) {
                          resetEmail = val;
                        },
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        decoration: new InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Email',
                            contentPadding:
                                EdgeInsets.only(left: 70.0, top: 15.0),
                            hintStyle:
                                TextStyle(color: Colors.black, fontSize: 14.0)),
                        style: TextStyle(color: Colors.black),
                      ),
                    )
                  ],
                ),
                new Column(children: <Widget>[
                  Container(
                    decoration: new BoxDecoration(
                        border: new Border(
                            bottom: new BorderSide(
                                width: 0.5, color: Colors.black))),
                  )
                ]),
              ],
            ),
          )),
          actions: <Widget>[
            new FlatButton(
              child: new Text(
                'CANCEL',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                Navigator.of(context).pop("");
              },
            ),
            new FlatButton(
              child: new Text(
                'SEND EMAIL',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: () {
                setState(() {
                  _sendResetEmail();
                });
                Navigator.of(context).pop(resetEmail);
              },
            ),
          ],
        );
      },
    );
  }

  // Sends a password-reset link to the given email address
  void sendPasswordResetEmail() async {
    String resetEmail = await _resetDialogBox();

    // When this is true, the user pressed 'cancel', so do nothing
    if (resetEmail == "") {
      return;
    }

    try {
      Fluttertoast.showToast(
          msg: "Sending password-reset email to: $resetEmail",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 4);

      //_auth.sendPasswordResetEmail(email: resetEmail);
    } catch (exception) {
      print(exception);

      Fluttertoast.showToast(
          msg: "${exception.toString()}",
          toastLength: Toast.LENGTH_LONG,
          timeInSecForIos: 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // prevent pixel overflow when typing
      resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  "",
                ),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // QuickCarl logo at the top
            Image(
              alignment: Alignment.bottomCenter,
              image: AssetImage(""),
              width: 180.0,
              height: 250.0,
            ),
            new Text('',
                style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12.0,
                    color: Colors.white)),
            _textFields(),
            _signInButton(),
            _accountButtons()
          ],
        ),
      ),
    );
  }

  String validateEmail(String value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String _validatePassword(String value) {
    if (value.length == 0) {
      return 'Password is required';
    }

    if (value.length < 4) {
      return 'Incorrect password';
    }
  }

  void _sendResetEmail() {
    final resetEmailController = TextEditingController();
    resetEmail = resetEmailController.text;

    if (_resetKey.currentState.validate()) {
      _resetKey.currentState.save();

      try {
        Fluttertoast.showToast(
            msg: "Sending password-reset email to: $resetEmail",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 4);

        //  _auth.sendPasswordResetEmail(email: resetEmail);
      } catch (exception) {
        print(exception);

        Fluttertoast.showToast(
            msg: "${exception.toString()}",
            toastLength: Toast.LENGTH_LONG,
            timeInSecForIos: 4);
      }
    } else {
      setState(() {
        _validate = true;
      });
    }
  }
}
