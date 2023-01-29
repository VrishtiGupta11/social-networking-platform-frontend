import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:social_networking/Pages/view-event-page.dart';
import 'package:social_networking/Util/constants.dart';


class EventsPage extends StatefulWidget {
  static String route = '/events';
  int? userid;
  EventsPage({Key? key, this.userid}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {

  bool isAllTrue = true,
      isInterestTrue = false,
      isCityAndInterestTrue = false,
      isRegisteredTrue = false,
      isCityTrue = false;

  bool clear = false;

  Future getEvents() async{
    String eventsURL = "http://localhost:8080/api/event";
    var response = await http.get(Uri.parse(eventsURL));
    // print(response.body.runtimeType);
    return response.body;
  }

  Future getEventsBasedOnInterest() async{
    String eventsURL = "http://localhost:8080/api/user/${Util.user.userid}/interest/event";
    var response = await http.get(Uri.parse(eventsURL));
    print(response.body.length);
    return response.body;
  }

  Future getEventsBasedOnCity() async{
    String eventsURL = "http://localhost:8080/api/user/${Util.user.userid}/city/event";
    var response = await http.get(Uri.parse(eventsURL));
    print(response.body.length);
    return response.body;
  }

  Future getEventsBasedOnCityAndInterest() async{
    String eventsURL = "http://localhost:8080/api/user/${Util.user.userid}/city/interest/event";
    var response = await http.get(Uri.parse(eventsURL));
    print(response.body.length);
    return response.body;
  }

  Future getRegisteredEvents() async{
    String eventsURL = "http://localhost:8080/api/user/${Util.user.userid}/event";
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

    // var arg = ModalRoute.of(context)!.settings.arguments;
    // if(arg == null) {
    //   print("args null");
    // }
    // print("arg " + arg['userid'].toString());
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
          child: const Text("EVENTS", style: TextStyle(fontWeight: FontWeight.bold),),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userid: Util.user.userid,)));
              Navigator.pushNamed(context, "/profile");
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(userid: Util.user.userid,)));
              Navigator.pushNamed(context, "/explore");
            },
            icon: const Icon(Icons.search),
          ),
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
                  onPressed: () {
                    isAllTrue = true;
                    isInterestTrue = false;
                    isCityTrue = false;
                    isCityAndInterestTrue = false;
                    isRegisteredTrue = false;
                    clear = true;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isAllTrue ? Colors.deepPurple : Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.15, 0),
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
                  onPressed: () {
                    isAllTrue = false;
                    isInterestTrue = true;
                    isCityTrue = false;
                    isCityAndInterestTrue = false;
                    isRegisteredTrue = false;
                    clear = true;
                    print("events based on Interest");
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isInterestTrue ? Colors.deepPurple : Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.15, 0),
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
                  onPressed: () {
                    isAllTrue = false;
                    isInterestTrue = false;
                    isCityTrue = true;
                    isCityAndInterestTrue = false;
                    isRegisteredTrue = false;
                    clear = true;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isCityTrue ? Colors.deepPurple : Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.15, 0),
                  ),
                  child: const Text(
                    'CITY',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {
                    isAllTrue = false;
                    isInterestTrue = false;
                    isCityTrue = false;
                    isCityAndInterestTrue = true;
                    isRegisteredTrue = false;
                    clear = true;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isCityAndInterestTrue ? Colors.deepPurple : Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.15, 0),
                  ),
                  child: const Text(
                    'CITY & INTEREST',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                TextButton(
                  onPressed: () {
                    isAllTrue = false;
                    isInterestTrue = false;
                    isCityTrue = false;
                    isCityAndInterestTrue = false;
                    isRegisteredTrue = true;
                    clear = true;
                    setState(() {});
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isRegisteredTrue ? Colors.deepPurple : Colors.deepPurpleAccent,
                    elevation: 8,
                    fixedSize: Size(sized.width*0.15, 0),
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
              future: isAllTrue ? getEvents()
                  : (isInterestTrue) ? getEventsBasedOnInterest()
                    : (isCityTrue) ? getEventsBasedOnCity()
                      : (isCityAndInterestTrue) ? getEventsBasedOnCityAndInterest()
                        : (isRegisteredTrue) ? getRegisteredEvents()
                          : getEvents(),
              builder: (context, snapshot) {
                // AsyncSnapshot<dynamic>? variable;
                // snapshot = variable ;

                if(snapshot.hasData && !clear) {
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
                  if(list.length == 0) {
                    return Center(
                      child: Text("No Events Found", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black38, fontSize: 25),),
                    );
                  }
                  else {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Wrap(
                        children: list,
                      ),
                    );
                  }
                }
                else {
                  // print("No Data");
                  clear = false;
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
