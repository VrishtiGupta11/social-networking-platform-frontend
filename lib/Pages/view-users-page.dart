import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/view-profile.dart';
import 'package:social_networking/Util/constants.dart';

class ViewUsers extends StatefulWidget {
  List? usersList;
  ViewUsers({Key? key, required this.usersList}) : super(key: key);

  @override
  _ViewUsersState createState() => _ViewUsersState();
}

class _ViewUsersState extends State<ViewUsers> {


  Future getConnectionsOfUsers() async{
    String url = "http://localhost:8080/api/user/${Util.user.userid}/friend";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  parseConnections(response) {
    List list = convert.jsonDecode(response);
    List connectionList = [];
    list.forEach((element) {
      connectionList.add(element['userid']);
    });
    return connectionList;
  }

  Future addConnection(friendid) async {
    String URL = "http://localhost:8080/api/user/${Util.user.userid}/friend";
    var response = await http.put(Uri.parse(URL),
        headers: {'Content-Type': 'application/json'},
        body: convert.json.encode({
          'friendid': friendid,
        })
    );
    print(response.body);
    if(response.statusCode != 200) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else {
      ShowSnackBar(context: context, message: "Connection Added");
    }
  }

  Future removeConnection(friendid) async {
    String interestURL = "http://localhost:8080/api/user/${Util.user.userid}/friend/${friendid}";
    var response = await http.put(Uri.parse(interestURL));
    print(response.body);
    if(response.statusCode != 200) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else {
      ShowSnackBar(context: context, message: "Connection removed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          child: const Text("USERS", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: getConnectionsOfUsers(),
        builder: (context, snapshot) {
          if(snapshot.hasData) {
            List connectionsList = parseConnections(snapshot.data.toString());

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Wrap(
                children: widget.usersList!.map((e) {
                  String text1 = "CONNECT", text2 = "REMOVE CONNECTION";
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => ViewProfile(
                              userid: e['userid'],
                              firstName: e['firstname'],
                              lastName: e['lastname']
                          )
                      ));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.3,
                      margin: const EdgeInsets.only(top: 30, left: 10, right: 10),
                      padding: EdgeInsets.all(15),
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
                          SizedBox(
                            height: 5,
                          ),
                          Wrap(
                            // mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(e['firstname'] + " " + e['lastname'], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38),),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          connectionsList.contains(e['userid']) ? TextButton(
                            onPressed: () {
                              removeConnection(e['userid']);
                              text2 = "CONNECT";
                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              elevation: 8,
                            ),
                            child: Text(
                              text2,
                              style: TextStyle(color: Colors.white),
                            ),
                          ) : TextButton(
                            onPressed: () {
                              addConnection(e['userid']);
                              text1 = "REMOVE CONNECTION";
                              setState(() {});
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              elevation: 8,
                            ),
                            child: Text(
                              text1,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
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
  }
}
