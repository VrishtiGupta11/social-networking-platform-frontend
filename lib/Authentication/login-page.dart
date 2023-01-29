import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/events-page.dart';
import 'dart:convert' as convert;
import 'package:social_networking/Util/constants.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  toggle(){
    setState(() {
      obscureText = !obscureText;
    });
  }

  var showLoader = false;
  var obscureText = true;

  Future loginUser() async {
    String loginUrl = "http://localhost:8080/api/user/login";
    var response = await http.post(Uri.parse(loginUrl),
        headers: {'Content-Type': 'application/json'},
        body: convert.json.encode({
          'email': emailController.text.trim(),
          'password': passwordController.text.trim()
        })
    );
    print(response.body);
    var mapAsData = convert.jsonDecode(response.body);
    if(response.statusCode == 404) {
      ShowSnackBar(context: context, message: "Invalid email or password");
    }
    else if(response.statusCode == 400) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else if (response.body != null) {
      print(mapAsData['userid']);
      // Navigator.pushNamed(context, "/events", arguments: mapAsData['userid']);
      Navigator.push(context, MaterialPageRoute(builder: (context) => EventsPage(userid: mapAsData['userid'],)));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: sized.height*0.14, left: sized.width*0.05),
              child: ShaderMask(
                shaderCallback: (bounds) {
                  return LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    colors: [Colors.redAccent.shade100, Colors.black87, ],
                    tileMode: TileMode.mirror,
                  ).createShader(bounds);
                },
                child: Text('LOGIN', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
              ),
            ),
            Align(
              alignment: Alignment.center,
              // padding: EdgeInsets.only(top: sized.width*0.48),
              child: Container(
                // height: 300,
                // width: 400,
                margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                      )
                    ]
                ),
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.topCenter,
                    width: sized.width*0.5,
                    // margin: EdgeInsets.fromLTRB(sized.width*0.1, 0, sized.width*0.1, 0),
                    padding: EdgeInsets.all(10),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: emailController,
                            autofocus: false,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Email is required';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.account_circle, size: 25, color: Colors.grey,),
                              // contentPadding: EdgeInsets.only(left: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 0,
                                borderSide: BorderSide.none,
                              ),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15,),
                          TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: passwordController,
                            autofocus: false,
                            obscureText: obscureText,
                            validator: (value){
                              if(value!.isEmpty || value.trim().isEmpty){
                                return 'Password is required';
                              }else if(value.trim().length<6){
                                return 'Password must be 6 characters';
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Password',
                              filled: true,
                              isDense: true,
                              prefixIcon: Icon(Icons.lock, size: 25, color: Colors.grey,),
                              suffixIcon: IconButton(
                                icon: Icon(obscureText ? Icons.visibility_off: Icons.visibility, color: Colors.grey, ),
                                onPressed: (){
                                  toggle();
                                },
                              ),
                              // contentPadding: EdgeInsets.only(left: 30),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                gapPadding: 0,
                                borderSide: BorderSide.none,
                              ),
                              enabled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder : OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.deepPurple,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 30,),
                          InkWell(
                            child: Text('Forgot Password?', style: TextStyle(color: Colors.grey),),
                            onTap: (){
                              // Change Password
                            },
                          ),
                          SizedBox(height: 10,),
                          Container(
                            height: 35,
                            width: 100,
                            child: TextButton(
                              onPressed: () {
                                if(_formKey.currentState!.validate()){
                                  loginUser();
                                  // setState(() {
                                  //
                                  //   showLoader = true;
                                  // });
                                }
                              },
                              child: Text('LOGIN', style: TextStyle(color: Colors.white),),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                elevation: 8,
                              ),
                            ),
                          ),

                          SizedBox(height: 10,),
                          InkWell(
                            child: const Text('New User? REGISTER', style: TextStyle(color: Colors.grey),),
                            onTap: (){
                              Navigator.pushNamed(context, '/register');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}
