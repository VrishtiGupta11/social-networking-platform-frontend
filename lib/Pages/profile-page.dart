import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_networking/Pages/view-users-page.dart';
import 'package:social_networking/Widgets/interest-widget.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Util/constants.dart';

class ProfilePage extends StatefulWidget {
  static String route = '/profile';
  int? userid;
  ProfilePage({Key? key, this.userid}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {


  Future getConnectionsOfUsers() async{
    String url = "http://localhost:8080/api/user/${Util.user.userid}/friend";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  parseConnections(response) {
    List list = convert.jsonDecode(response);
    // list.forEach((element) {
    //   if(element['userid'] == Util.user.userid) {
    //     isConnected = true;
    //   }
    // });
    return list;
  }

  Future getInterest() async{
    String interestURL = "http://localhost:8080/api/user/${Util.user.userid.toString()}/interest";
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
    return !Util.isLoggedIn ? const Scaffold(
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
              future: getConnectionsOfUsers(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  List connectionList = parseConnections(snapshot.data.toString());
                  return Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Container(
                          height: 100,
                          width: 100,
                          child: Icon(Icons.person, size: 100, color: Colors.black38,),
                          color: Colors.grey[200],
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(Util.user.firstName! + " " + Util.user.lastName!, style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Text("Connections: ${connectionList.length}", style: TextStyle(color: Colors.black38),),
                      SizedBox(height: 10,),
                      InkWell(
                        child: Text("View all Connections", style: TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline),),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUsers(usersList: connectionList)));
                        },
                      ),
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
          ),
          Column(
            children: [
              Container(
                width: sized.width*0.54,
                // height: sized.height*0.3,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                      child: Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                    ),
                    Row(
                      children: [
                        const Text("First Name", style: TextStyle(fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text(Util.user.firstName!, style: TextStyle(color: Colors.black38),),
                      ],
                    ),

                    Divider(),

                    Row(
                      children: [
                        const Text("Last Name", style: TextStyle(fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text(Util.user.lastName!, style: TextStyle(color: Colors.black38),),
                      ],
                    ),

                    Divider(),

                    Row(
                      children: [
                        const Text("Email", style: TextStyle(fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text(Util.user.email!, style: TextStyle(color: Colors.black38),),
                      ],
                    ),

                    Divider(),

                    Row(
                      children: [
                        Text("City", style: TextStyle(fontWeight: FontWeight.bold),),
                        Spacer(),
                        Text(Util.user.city!, style: TextStyle(color: Colors.black38),),
                      ],
                    ),

                  ],
                ),
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
                      return InterestWidget(userid: Util.user.userid, userInterest: userInterest, userInterestMap: userInterestMap,);
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
