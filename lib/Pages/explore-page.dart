import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/view-users-page.dart';
import 'package:social_networking/Util/constants.dart';

class ExplorePage extends StatefulWidget {
  static String route = '/explore';
  const ExplorePage({Key? key}) : super(key: key);

  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  List<String> interestList = [
    'Music',
    'Coding',
    'Engineering',
    'Singing',
    'Sports',
    'Vlogging',
    'Cooking'
  ];

  Future getUsersOfInterest(interestid) async{
    String eventsURL = "http://localhost:8080/api/interest/$interestid/user";
    var response = await http.get(Uri.parse(eventsURL));
    return response.body;
  }

  parseUsers(response) {
    List list = convert.jsonDecode(response);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return (!Util.isLoggedIn) ? Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Please Login first", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 25),),
            SizedBox(height: 10,),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, "/login");
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.deepPurpleAccent,
                elevation: 8,
              ),
              child: const Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ) : Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.grey),
        title: ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              // colors: [Colors.redAccent.shade100, Colors.orangeAccent, ],
              colors: [Colors.redAccent.shade100, Colors.black87],
              tileMode: TileMode.mirror,
            ).createShader(bounds);
          },
          child: const Text("EXPLORE", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/profile");
            },
            icon: const Icon(Icons.person),
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          alignment: WrapAlignment.center,
          children: interestList.map((e) {
            return Container(
              // width: sized.width*0.3,
              margin: EdgeInsets.only(top: sized.height*0.05, left: sized.width*0.05, right: sized.width*0.05, bottom: sized.height*0.05),
              padding: EdgeInsets.all(10),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                    )
                  ]
              ),
              child: FutureBuilder(
                future: getUsersOfInterest(interestList.indexOf(e)),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    List usersList = parseUsers(snapshot.data.toString());
                    return Column(
                      children: [
                        Text("Users of Interest \'$e\'", style: TextStyle(color: Colors.black38, fontSize: 18),),
                        SizedBox(height: 20,),
                        TextButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ViewUsers(usersList: usersList,),
                            ));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            elevation: 8,
                          ),
                          child: Text(
                            "View Users",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    );
                  }
                  else {
                    return Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }
                }
              ),
            );
            }).toList(),
        ),
      ),
    );
  }
}
