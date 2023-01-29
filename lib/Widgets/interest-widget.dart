import 'package:flutter/material.dart';
import 'package:social_networking/Util/constants.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class InterestWidget extends StatefulWidget {
  int? userid;
  Map<String, int>? userInterest;
  Map<String, int>? userInterestMap;
  InterestWidget({Key? key, required this.userid, required this.userInterest, required this.userInterestMap}) : super(key: key);

  @override
  _InterestWidgetState createState() => _InterestWidgetState();
}

class _InterestWidgetState extends State<InterestWidget> {

  List<String> interestList = [
    'Music',
    'Coding',
    'Engineering',
    'Singing',
    'Sports',
    'Vlogging',
    'Cooking'
  ];

  Future saveInterest(String interest, int id) async {
    String interestURL = "http://localhost:8080/api/user/${widget.userid.toString()}/interest";
    var response = await http.put(Uri.parse(interestURL),
        headers: {'Content-Type': 'application/json'},
        body: convert.json.encode({
          'interestId': id,
          'interestName': interest,
        })
    );
    print(response.body);
    if(response.statusCode != 200) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else {
      ShowSnackBar(context: context, message: "Interests saved");
    }
  }

  Future deleteInterest(String interest, int id) async {
    print("interest $interest");
    print("id ${id.toString()}");
    String interestURL = "http://localhost:8080/api/user/${widget.userid.toString()}/interest/${id.toString()}";
    var response = await http.put(Uri.parse(interestURL));
    print(response.body);
    if(response.statusCode != 200) {
      ShowSnackBar(context: context, message: "Something went wrong");
    }
    else {
      ShowSnackBar(context: context, message: "Interests saved");
    }
  }

  Map<String, int>? selectedUserInterest;

  @override
  Widget build(BuildContext context) {
    selectedUserInterest = widget.userInterest as Map<String, int>;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 50,
            child: Text("Select Interest", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          ),
          Wrap(
            children: interestList.map((interest) {
              bool isSelected = false;
              if (selectedUserInterest!.containsKey(interest)) {
                isSelected = true;
              }
              return InkWell(
                onTap: () {
                  if (!selectedUserInterest!.containsKey(interest)) {
                    selectedUserInterest![interest] = interestList.indexOf(interest);
                    setState(() {});
                    print(selectedUserInterest);
                  }
                  else {
                    selectedUserInterest!.removeWhere((key, value) => key == interest);
                    setState(() {});
                    print(selectedUserInterest);
                  }
                },
                child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: isSelected ? Colors.deepPurple : Colors.grey, width: 2)
                      ),
                      child: Text(interest, style: TextStyle(color: isSelected ? Colors.deepPurple : Colors.grey, fontSize: 14),),
                    )),
              );
            },
          ).toList(),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              selectedUserInterest?.forEach((key, value) {
                saveInterest(key, value);
              });
              widget.userInterestMap?.forEach((key, value) {
                if(!selectedUserInterest!.containsKey(key)) {
                  print(key);
                  print(value);
                  deleteInterest(key, value);
                }
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent,
              elevation: 8,
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
