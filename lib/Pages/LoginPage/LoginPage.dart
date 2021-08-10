import 'package:flutter/material.dart';
import 'package:gymmer/ApiIntegration/Authentication.dart';
import 'package:gymmer/Pages/HomePage/Home/HomePage.dart';

class LoginPage extends StatefulWidget {
  static const loginPage = '/loginPage';
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  BackEndServiceAuthentication _backEndServiceAuthentication =
      BackEndServiceAuthentication();

  String _username = '';
  String _password = '';
  bool error = false;
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: Colors.white),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/images/standing_dumbels.jpg'),
                              fit: BoxFit.cover),
                        ),
                        height: height * 0.4,
                        width: width,
                      ),
                      SizedBox(
                        height: height * 0.05,
                      ),
                      Container(
                        child: Center(
                          child: Text(
                            "LOGIN",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Username",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          onChanged: (text) {
                            _username = text;
                          },
                          controller: _usernameController,
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          "Password",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            border: Border.all(color: Colors.black38, width: 2),
                            borderRadius: BorderRadius.circular(10)),
                        child: TextField(
                          onChanged: (text) {
                            _password = text;
                          },
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          cursorColor: Colors.black54,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            fillColor: Colors.black12,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      error
                          ? Container(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Login Error. Please check the credentials again",
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 25,
                      ),
                      GestureDetector(
                        onTap: () async {
                          FocusScope.of(context).unfocus();

                          print(_username);
                          print(_password);

                          ProfileDetails profileDetails =
                              await _backEndServiceAuthentication
                                  .getAuthenticationDetails(
                                      _username, _password);

                          _usernameController.clear();
                          _passwordController.clear();
                          if (profileDetails.description == 'success') {
                            setState(() {
                              error = false;
                            });
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => HomePage(
                                      id: profileDetails.id,
                                    )));
                          } else {
                            setState(() {
                              error = true;
                            });
                          }
                        },
                        child: Container(
                          width: width,
                          child: Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 30),
                              decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                "SUBMIT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: height * 0.6,
                    width: width,
                    margin: EdgeInsets.only(left: 60),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: height * 0.02,
                          width: 16,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: height * 0.07,
                          width: 10,
                          color: Colors.white.withOpacity(0.4),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: height * 0.1,
                          width: 10,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          height: height * 0.13,
                          width: 10,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                "FITNESS",
                                style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Center",
                                style: TextStyle(
                                    fontSize: 30,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20.00))),
                    width: width * 0.4,
                    child: Center(
                      child: Image.asset('assets/images/logo.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
