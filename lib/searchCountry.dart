import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport_db/global.dart' as global;
import 'package:http/http.dart' as http;

class SearchCountry extends StatefulWidget {
  static const routeName = 'searchCountry';
  @override
  _SearchCountryState createState() => _SearchCountryState();
}

class _SearchCountryState extends State<SearchCountry> {
  var leaguesResponse;
  getLeagues() async {
    String country = global.selectedCountry;
    final urlLeague = Uri.parse(
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?c=$country');
    var res = await http.get(urlLeague);
    if (res.statusCode == 200) {
      setState(() {
        leaguesResponse = json.decode(res.body);
      });
      print(leaguesResponse);
      print(leaguesResponse['countrys'].length);
    } else {
      print('hey error');
    }
  }

  var searchResponse;
  getSearchLeagues(String name) async {
    String country = global.selectedCountry;
    final urlLeague = Uri.parse(
        'https://www.thesportsdb.com/api/v1/json/1/search_all_leagues.php?s=$name&c=$country');
    var res = await http.get(urlLeague);
    if (res.statusCode == 200) {
      setState(() {
        searchResponse = json.decode(res.body);
      });
      print(searchResponse);
    } else {
      print('hey error');
    }
  }

  var sportsResponse;
  getSports() async {
    final urlSport =
        Uri.parse('https://www.thesportsdb.com/api/v1/json/1/all_sports.php');
    var resp = await http.get(urlSport);
    if (resp.statusCode == 200) {
      setState(() {
        sportsResponse = json.decode(resp.body);
      });
      print(sportsResponse);
    } else {
      print('hey error');
    }
  }

  @override
  void initState() {
    getSports();
    getLeagues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SvgPicture.asset(
              'assets/arrow_left.svg',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.red,
        title: Text(global.selectedCountry),
      ),
      body: leaguesResponse == null || sportsResponse == null
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: StatefulBuilder(
                builder: (context, ss) {
                  return Container(
                    margin: const EdgeInsets.all(18),
                    child: Column(
                      children: [
                        Container(
                          height: 45,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(6)),
                          child: TextFormField(
                            onChanged: (name) {
                              if (name.length == 0) {
                                setState(() {
                                  searchResponse = null;
                                });
                                FocusScope.of(context).unfocus();
                              } else {
                                getSearchLeagues(name);
                              }
                            },
                            decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 15),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                border: InputBorder.none,
                                label: Container(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: const Text("Search leagues.."))),
                          ),
                        ),
                        searchResponse != null
                            ? Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Text('No Leagues Found'),
                              )
                            : Container(
                                margin: const EdgeInsets.only(top: 5),
                                height:
                                    MediaQuery.of(context).size.height - 181,
                                child: GridView.builder(
                                  itemCount: leaguesResponse['countrys'].length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          childAspectRatio: 2.8,
                                          crossAxisCount: 1),
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.yellow,
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 10),
                                      child: Stack(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            child: Image.network(
                                              sportsResponse['sports'][index]
                                                  ['strSportThumb'],
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                              bottom: 10,
                                              left: 15,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: Colors.white,
                                                  ),
                                                  height: 30,
                                                  width: 30,
                                                  child: SvgPicture.asset(
                                                      'assets/facebook.svg'))),
                                          Positioned(
                                              bottom: 10,
                                              left: 60,
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: Colors.white,
                                                  ),
                                                  alignment: Alignment.center,
                                                  height: 30,
                                                  width: 30,
                                                  child: SvgPicture.asset(
                                                      'assets/twitter.svg'))),
                                          Positioned(
                                              left: 20,
                                              top: 10,
                                              child: Text(
                                                leaguesResponse['countrys']
                                                    [index]['strLeague'],
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                          Positioned(
                                              top: 40,
                                              bottom: 40,
                                              right: 10,
                                              child: SizedBox(
                                                height: 50,
                                                width: 100,
                                                child: Image.network(
                                                  leaguesResponse['countrys']
                                                                  [index]
                                                              ['strLogo'] ==
                                                          null
                                                      ? leaguesResponse[
                                                              'countrys'][index]
                                                          ['strBadge']
                                                      : leaguesResponse[
                                                              'countrys'][index]
                                                          ['strLogo'],
                                                  fit: BoxFit.cover,
                                                ),
                                              ))
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}
