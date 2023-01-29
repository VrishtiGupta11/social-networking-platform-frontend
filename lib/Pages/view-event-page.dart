import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/view-participants-page.dart';

class ViewEventPage extends StatefulWidget {
  int? userid;
  String? eventid;
  ViewEventPage({Key? key, required this.userid, required this.eventid}) : super(key: key);

  @override
  _ViewEventPageState createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage> {

  String? eventName;
  String? eventDescription;

  Future getEvent() async{
    String interestURL = "http://localhost:8080/api/event/${widget.eventid.toString()}";
    var response = await http.get(Uri.parse(interestURL));
    return response.body;
  }

  parseEvent(response) {
    var mp = convert.jsonDecode(response);
    return mp;
  }

  Future getVenue(venueid) async{
    String interestURL = "http://localhost:8080/api/venue/$venueid";
    var response = await http.get(Uri.parse(interestURL));
    return response.body;
  }

  parseVenue(response) {
    var mp = convert.jsonDecode(response);
    return mp;
  }

  Future getUsersOfEvent() async{
    String url = "http://localhost:8080/api/event/${widget.eventid.toString()}/user";
    var response = await http.get(Uri.parse(url));
    return response.body;
  }

  parseUsers(response) {
    var list = convert.jsonDecode(response);
    return list;
  }

  // Future registerForEvent() async {
  //   String registerUrl = "http://localhost:8080/api/user";
  //   var response = await http.post(Uri.parse(registerUrl),
  //       headers: {'Content-Type': 'application/json'},
  //       body: convert.json.encode({
  //         'firstName': firstNameController.text.trim(),
  //         'lastName': lastNameController.text.trim(),
  //         'email': emailController.text.trim(),
  //         'password': passwordController.text.trim(),
  //         'city': cityController.text.trim()
  //       })
  //   );
  //   print(response.body);
  //   if(response.statusCode == 409) {
  //     ShowSnackBar(context: context, message: "User already exists");
  //   }
  //   else if(response.statusCode == 400) {
  //     ShowSnackBar(context: context, message: "Something went wrong");
  //   }
  //   else if (response.body != null) {
  //     Navigator.pop(context);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Size sized = MediaQuery.of(context).size;
    return
    //   widget.userid == null ? const Scaffold(
    //   body: Center(
    //     child: Text("Please login first"),
    //   ),
    // ) :
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
            child: const Text("EVENT", style: TextStyle(fontWeight: FontWeight.bold),),
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
        body: FutureBuilder(
          future: getEvent(),
          builder: (context, snapshot) {
            if(snapshot.hasData) {
              var eventMap = parseEvent(snapshot.data);
              return Row(
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
                      future: getUsersOfEvent(),
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          List list = parseUsers(snapshot.data.toString());
                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(90),
                                child: Container(
                                  height: 170,
                                  width: 170,
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
                              SizedBox(height: 20,),
                              Text(eventMap['description']['text'].substring(0, eventMap['description']['text'].indexOf(':')), style: TextStyle(fontSize: 20, color: Colors.black38, fontWeight: FontWeight.bold),),
                              SizedBox(height: 10,),
                              Text(eventMap['name']['text'], style: TextStyle(color: Colors.black38, fontSize: 17),),
                              SizedBox(height: 10,),
                              Text("Total Participants: ${list.length}", style: TextStyle(color: Colors.black38),),
                              SizedBox(height: 10,),
                              InkWell(
                                child: Text("View all Participants", style: TextStyle(color: Colors.deepPurple, decoration: TextDecoration.underline),),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewParticipants(participants: list)));
                                },
                              ),
                              SizedBox(height: 10,),
                              TextButton(
                                onPressed: () {

                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.deepPurpleAccent,
                                  elevation: 8,
                                ),
                                child: const Text(
                                  'REGISTER',
                                  style: TextStyle(color: Colors.white),
                                ),
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
                          children: [
                            Text("About Event", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                Text("Name          \t", style: TextStyle(fontWeight: FontWeight.bold),),
                                // Spacer(),
                                Flexible(
                                  child: Text(eventMap['description']['text'].substring(0, eventMap['description']['text'].indexOf(':')), style: TextStyle(color: Colors.black38),)
                                ),
                              ],
                            ),

                            Divider(),

                            Row(
                              children: [
                                Text("Description\t", style: TextStyle(fontWeight: FontWeight.bold),),
                                // Spacer(),
                                Flexible(
                                  child: Text(eventMap['description']['text'].substring(eventMap['description']['text'].indexOf(':')+1), style: TextStyle(color: Colors.black38),)
                                ),
                              ],
                            ),

                            Divider(),
                          ],
                        )
                      ),
                      Container(
                        width: sized.width*0.54,
                        // height: sized.height*0.4,
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
                            future: getVenue(eventMap['venue_id']),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                var venueMap = parseVenue(snapshot.data.toString());
                                return Column(
                                  children: [
                                    Text("Other Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text("Date", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Text(eventMap['start']['local'].substring(0, eventMap['start']['local'].indexOf('T')), style: TextStyle(color: Colors.black38),),
                                      ],
                                    ),
                                    Divider(),

                                    Row(
                                      children: [
                                        Text("Time", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Text(eventMap['start']['local'].substring(eventMap['start']['local'].indexOf('T')+1), style: TextStyle(color: Colors.black38),),
                                      ],
                                    ),
                                    Divider(),

                                    Row(
                                      children: [
                                        Text("Venue", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Text(venueMap['name'], style: TextStyle(color: Colors.black38),),
                                      ],
                                    ),
                                    Divider(),

                                    Row(
                                      children: [
                                        Text("City", style: TextStyle(fontWeight: FontWeight.bold),),
                                        Spacer(),
                                        Text(venueMap['address']['city'], style: TextStyle(color: Colors.black38),),
                                      ],
                                    ),
                                    Divider(),
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
                    ],
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
        )
    );
  }
}
