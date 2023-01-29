import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_networking/Widgets/interest-widget.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int? userid;
  ProfilePage({Key? key, required this.userid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  String? firstName, lastName, email;

  Future getUser() async{
    // print(widget.userid.toString());
    String userURL = "http://localhost:8080/api/user/${widget.userid.toString()}";
    var response = await http.get(Uri.parse(userURL));
    return response.body;
  }

  parseUser(response) {
    var data = convert.jsonDecode(response);
    // print(data);
    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
  }

  Future getInterest() async{
    String interestURL = "http://localhost:8080/api/user/${widget.userid.toString()}/interest";
    var response = await http.get(Uri.parse(interestURL));
    return response.body;
  }

  parseInterest(response) {
    var data = convert.jsonDecode(response);
    // print(data);
    // List<String> userInterestList = [];

    Map<String, int> mp = {};
    data.forEach((element) {
      mp[element['interestname']] = element['interestid'];
    });
    print(mp);
    return mp;
  }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return widget.userid == null ? const Scaffold(
      body: Center(
        child: Text("Please login first"),
      ),
    ) :
    Scaffold(
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
          child: const Text("PROFILE", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.home_filled),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Row(
        children: [
          Container(
            width: sized.width*0.3,
            margin: EdgeInsets.only(top: sized.height*0.05, left: sized.width*0.05, right: sized.width*0.05, bottom: sized.height*0.05),
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
            child: Column(
              children: const [
                Icon(Icons.person, size: 100, color: Colors.grey,)
              ],
            ),
          ),
          Column(
            children: [
              Container(
                width: sized.width*0.54,
                height: sized.height*0.3,
                margin: EdgeInsets.only(top: sized.height*0.05, right: sized.width*0.05),
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
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
                  future: getUser(),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if(snapshot.hasData) {
                      parseUser(snapshot.data.toString());
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                          ),
                          Row(
                            children: [
                              Text("First Name", style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text(firstName!, style: TextStyle(color: Colors.black38),),
                            ],
                          ),

                          Divider(),

                          Row(
                            children: [
                              Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text(lastName!, style: TextStyle(color: Colors.black38),),
                            ],
                          ),

                          Divider(),

                          Row(
                            children: [
                              Text("Email", style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(),
                              Text(email!, style: TextStyle(color: Colors.black38),),
                            ],
                          ),

                          Divider(),

                          Row(
                            children: [
                              Text("City", style: TextStyle(fontWeight: FontWeight.bold),),
                              Spacer(),
                              // Text(city!, style: TextStyle(color: Colors.black38),),
                            ],
                          ),

                        ],
                      );
                    }
                    else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                  }),
              ),
              Container(
                width: sized.width*0.54,
                height: sized.height*0.4,
                margin: EdgeInsets.only(top: sized.height*0.05, right: sized.width*0.05),
                padding: EdgeInsets.all(20),
                alignment: Alignment.topLeft,
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
                  future: getInterest(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      Map<String, int> userInterest = parseInterest(snapshot.data.toString());
                      Map<String, int> userInterestMap = Map.from(userInterest);
                      return InterestWidget(userid: widget.userid, userInterest: userInterest, userInterestMap: userInterestMap,);
                    }
                    else {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          )
        ],
      )
    );
  }
}
