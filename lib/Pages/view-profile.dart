import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/view-event-page.dart';
import 'package:social_networking/Util/constants.dart';

class ViewProfile extends StatefulWidget {
  int? userid;
  String? firstName, lastName;
  ViewProfile({Key? key, required this.userid, required this.firstName, required this.lastName}) : super(key: key);

  @override
  _ViewProfileState createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  Future getInterest() async{
    String interestURL = "http://localhost:8080/api/user/${widget.userid.toString()}/interest";
    var response = await http.get(Uri.parse(interestURL));
    return response.body;
  }

  parseInterest(response) {
    var data = convert.jsonDecode(response);

    List interests = [];
    data.forEach((element) {
      interests.add(element['interestname']);
    });

    return interests;
  }

  Future getConnectionsOfUsers() async{
    String url = "http://localhost:8080/api/user/${widget.userid}/friend";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  parseConnections(response) {
    List list = convert.jsonDecode(response);
    return list;
  }

  Future getRegisteredEvents() async{
    String eventsURL = "http://localhost:8080/api/user/${widget.userid}/event";
    var response = await http.get(Uri.parse(eventsURL));
    print(response.body.length);
    return response.body;
  }

  parseEvents(response) {
    var mapAsData = convert.jsonDecode(response);
    List<Widget> tileWidgets = [];

    mapAsData.forEach((element) {
      tileWidgets.add(InkWell(
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
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  height: 70,
                  width: 70,
                  child: Image.asset(
                    "rupeek-events.png",
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Wrap(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Interest:\t", style: TextStyle(fontWeight: FontWeight.bold),),
                  Text(element['name']['text']),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              (element['description']['text'] == null)
                  ? Text("Event Name",)
                  : Text(element['description']['text'].substring(0, element['description']['text'].indexOf(':')),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black38),),
              SizedBox(
                height: 5,
              ),
              (element['description']['text'] == null)
                  ? Text("Description",)
                  : Text(element['description']['text'].substring(element['description']['text'].indexOf(':')+1), overflow: TextOverflow.ellipsis),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventPage(userid: Util.user.userid, eventid: element['id']),));
                },
                style: TextButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  elevation: 8,
                ),
                child: const Text(
                  'VIEW',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ));
    });
    return tileWidgets;
  }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
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
          child: const Text("PROFILE", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                width: sized.width*0.3,
                height: sized.height*0.3,
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
                            Text("${widget.firstName} ${widget.lastName}", style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),),
                            SizedBox(height: 10,),
                            Text("Connections: ${connectionList.length}", style: TextStyle(color: Colors.black38),),
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
              FutureBuilder(
                future: getInterest(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    List interestList = parseInterest(snapshot.data);
                    return Container(
                      width: sized.width*0.5,
                      height: sized.height*0.3,
                      margin: EdgeInsets.only(top: sized.height*0.05, right: sized.width*0.05, bottom: sized.height*0.05),
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
                            Text("Interests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                            SizedBox(
                              height: 20,
                            ),
                            Wrap(
                              children: interestList.map((interest) {
                                return InkWell(
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(color: Colors.deepPurple, width: 2)
                                        ),
                                        child: Text(interest, style: TextStyle(color: Colors.deepPurple, fontSize: 14),),
                                      )),
                                );
                              },
                              ).toList(),
                            ),
                          ],
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
            ],
          ),
          Text("Registered Events", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          FutureBuilder(
            future: getRegisteredEvents(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                var list = parseEvents(snapshot.data.toString());
                if(list.length == 0) {
                  return Center(
                    child: Text("No Events Found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 25),),
                  );
                }
                else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      children: list,
                    ),
                  );
                }
              }
              else {
                // print("No Data");
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
