import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sport_db/global.dart' as global;
import 'package:sport_db/searchCountry.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
      routes: {SearchCountry.routeName: (ctx) => SearchCountry()},
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List countryName = [
    'India',
    'United States',
    'Australia',
    'China',
    'Argentina',
    'Canada'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'The Sports DB',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              height: 400,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 6,
                padding: const EdgeInsets.all(0),
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18.0, vertical: 10),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      dense: true,
                      title: Text(
                        countryName[i],
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      tileColor: Colors.red[100],
                      onTap: () {
                        setState(() {
                          global.selectedCountry = countryName[i];
                        });
                        Navigator.of(context)
                            .pushNamed(SearchCountry.routeName);
                      },
                      contentPadding: const EdgeInsets.only(left: 20),
                      trailing: SvgPicture.asset('assets/arrow_right.svg'),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
