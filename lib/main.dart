import 'package:flutter/material.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    theme: style.theme,
    home: MyApp()
    )
  );
}

var bodyText = TextStyle(color: Colors.red);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    var result2 = jsonDecode(result.body);
    setState(() {
      data = result2;
    });
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions:[
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: (){

              },
              iconSize: 30,
            )
        ]
      ),
      body: [Home(data : data),Text('Shop')][tab],
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i){
          setState(() {
            tab=i;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: 'Shop'),
        ],
      ),
    );
  }
}

class Home extends StatelessWidget {
  Home({super.key, this.data});
  final data;
  @override
  Widget build(BuildContext context) {

    if(data.isNotEmpty){
      return ListView.builder(
          itemCount: 3,
          itemBuilder: (context,i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 3/4,
                  child: Image.network(data[i]['image'],
                      fit:BoxFit.fill
                  ),
                ),
                Text(data[i]['likes'].toString()),
                Text(data[i]['user']),
                Text(data[i]['content']),
              ],
            );
          });
    } else {
      return Text('loading...');
    }
  }
}

