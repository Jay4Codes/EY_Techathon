import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ey_hack/universal/apicall.dart';
import 'package:http/http.dart' as http;
import 'package:ey_hack/screens/details.dart';
import 'package:ey_hack/privacy.dart';

class DataWidget extends StatefulWidget {
  final String text;
  DataWidget({required this.text});

  @override
  State<DataWidget> createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  List<dynamic> users = [];
  bool isLoading = true;
  @override
  void initState() {
    fetchdata();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.text,
                  style: GoogleFonts.dmSerifText(
                      color: Colors.amber,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyWidget(
                          text: widget.text,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    child: Row(
                      children: [
                        Text(
                          "More",
                          style: GoogleFonts.dmSerifText(
                            color: Colors.black,
                            fontSize: 30,
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.amber,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320, // Set a fixed height for the horizontal slider
            child: Stack(
              children: [
                ListView.builder(
                  scrollDirection:
                      Axis.horizontal, // Set scroll direction to horizontal
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final title = user['jawSummary']['title'];
                    final photo = user['jawSummary']['backgroundImage']['url'];
                    final description = user['jawSummary']['synopsis'];
                    final imageurl =
                        user['jawSummary']['backgroundImage']['url'];
                    final logoimgurl = user['jawSummary']['logoImage']['url'];
                    List<Map<String, dynamic>> genres =
                        (user['jawSummary']['genres'] as List<dynamic>)
                            .cast<Map<String, dynamic>>();
                    List<String> genrelist =
                        genres.map((item) => item["name"] as String).toList();
                    List<Map<String, dynamic>> castlist =
                        (user['jawSummary']['cast'] as List<dynamic>)
                            .cast<Map<String, dynamic>>();
                    List<String> cast =
                        castlist.map((item) => item["name"] as String).toList();
                    int id = user['summary']['id'];
                    final type = user["summary"]['type'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Details(
                              title: title,
                              desc: description,
                              backgroundimg: imageurl,
                              logoimgurl: logoimgurl,
                              genres: genrelist,
                              castlist: cast,
                              id: id,
                              type: type,
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            width: 200,
                            margin: const EdgeInsets.all(8),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                photo,
                                width: 200,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            title,
                            style: GoogleFonts.bebasNeue(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ), // Circular loading indicator
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void fetchdata() async {
    final url = Uri.https(
      'netflix-data.p.rapidapi.com',
      '/search/',
      {
        'query': widget.text,
        'offset': '0',
        'limit_titles': '4',
        'limit_suggestions': '1',
      },
    );

    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'netflix-data.p.rapidapi.com',
    };

    final response = await http.get(url, headers: headers);
    final body = response.body;
    final json = jsonDecode(body);
    print(json);
    setState(() {
      users = json["titles"];
      isLoading = false;
    });
  }
}
