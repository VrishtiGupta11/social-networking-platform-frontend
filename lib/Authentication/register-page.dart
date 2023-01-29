import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:social_networking/Util/constants.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cityController = TextEditingController();

  toggle(){
    setState(() {
      obscureText = !obscureText;
    });
  }
  final _formKey = GlobalKey<FormState>();
  var showLoader = false;
  var obscureText = true;

  Future registerUser() async {
    String registerUrl = "http://localhost:8080/api/user";
    var response = await http.post(Uri.parse(registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: convert.json.encode({
          'firstName': firstNameController.text.trim(),
          'lastName': lastNameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'city': cityController.text.trim()
        })
    );
    print(response.body);
    if(response.statusCode == 409) {
      ShowSnackBar(context: context, message: "User already exists");
    }
    else if(response.statusCode == 400) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else if (response.body != null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return showLoader
        ? Center(
      child: CircularProgressIndicator(),
    )
        : Scaffold(
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
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
                  child: Text('REGISTER', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white),),
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
                              controller: firstNameController,
                              autofocus: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'First Name is required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'First Name',
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey,
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
                                focusedBorder: OutlineInputBorder(
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
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: lastNameController,
                              autofocus: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'Last Name is required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Last Name',
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey,
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
                                focusedBorder: OutlineInputBorder(
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
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: emailController,
                              autofocus: false,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.account_circle,
                                  size: 25,
                                  color: Colors.grey,
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
                                focusedBorder: OutlineInputBorder(
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
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: cityController,
                              autofocus: false,
                              textCapitalization: TextCapitalization.words,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'City is required';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'City',
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  size: 25,
                                  color: Colors.grey,
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
                                focusedBorder: OutlineInputBorder(
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
                            SizedBox(
                              height: 15,
                            ),
                            TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: passwordController,
                              autofocus: false,
                              obscureText: obscureText,
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'Password is required';
                                } else if (value.trim().length < 6) {
                                  return 'Password must be 6 characters';
                                }
                              },
                              decoration: InputDecoration(
                                hintText: 'Password',
                                filled: true,
                                isDense: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  size: 25,
                                  color: Colors.grey,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
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
                                focusedBorder: OutlineInputBorder(
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
                            SizedBox(
                              height: 15,
                            ),
                            // Image Picker widget
                            SizedBox(
                              height: 20,
                            ),
                            InkWell(
                              onTap: () {},
                              child: Text(
                                'By Registering in You accept our Terms & Conditions',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 35,
                              width: 100,
                              child: TextButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // setState(() {
                                    //   showLoader = true;
                                    // });
                                    registerUser();
                                  }
                                },
                                child: Text(
                                  'REGISTER',
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  elevation: 8,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            InkWell(
                              child: Text(
                                'Terms & Conditions',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onTap: () {
                                // Change Password
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
        )
    );
  }
}