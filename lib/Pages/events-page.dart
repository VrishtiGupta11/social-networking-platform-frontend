import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/profile-page.dart';
import 'package:social_networking/Pages/view-event-page.dart';

class EventsPage extends StatefulWidget {
  int? userid;
  EventsPage({Key? key, required this.userid}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  Future getEvents() async{
    String eventsURL = "http://localhost:8080/api/event";
    var response = await http.get(Uri.parse(eventsURL));
    // print(response.body.runtimeType);
    return response.body;
  }

  parseEvents(response) {
    var mapAsData = convert.jsonDecode(response);
    // print(mapAsData.runtimeType);
    // print(mapAsData);
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewEventPage(userid: widget.userid, eventid: element['id']),));
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

    var arg = ModalRoute.of(context)!.settings.arguments;
    // if(arg == null) {
    //   print("args null");
    // }
    // print("arg " + arg['userid'].toString());

    Size sized = MediaQuery.of(context).size;
    return
    //   (widget.userid == null)
    //   ? const Scaffold(
    //   body: Center(
    //     child: Text("Please Login first"),
    //   ),
    // )
    //   :
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
          child: const Text("EVENTS", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userid: widget.userid,)));
            },
            icon: const Icon(Icons.person),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(sized.width*0.1, 0, sized.width*0.1, 0),
            child: Wrap(
              children: [
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.19, 0),
                  ),
                  child: const Text(
                    'ALL',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.19, 0),
                  ),
                  child: const Text(
                    'INTEREST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.19, 0),
                  ),
                  child: const Text(
                    'CITY && INTEREST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.19, 0),
                  ),
                  child: const Text(
                    'REGISTERED',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: sized.height*0.8,
            margin: EdgeInsets.fromLTRB(sized.width*0.1, 10, sized.width*0.1, 10),
            child: FutureBuilder(
              future: getEvents(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  var list = parseEvents(snapshot.data.toString());
                  // return GridView.builder(
                  //   // shrinkWrap: true,
                  //   itemCount: list.length,
                  //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 3,
                  //       crossAxisSpacing: 4.0,
                  //       mainAxisSpacing: 4.0
                  //   ),
                  //   itemBuilder:  (BuildContext context, int index){
                  //     return list[index];
                  //   },
                  // );
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Wrap(
                      children: list,
                    ),
                  );
                }
                else {
                  // print("No Data");
                  return Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
