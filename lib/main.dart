import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'notification.dart';
import 'style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c)=>Store1()),
      ChangeNotifierProvider(create: (c)=>Store2()),
    ],
    child: MaterialApp(
      theme: style.theme,
      home: MyApp()
      ),
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
  var userImage;
  var userContent;

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = {'age' : 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? 'null';
    print(jsonDecode(result)['age']);
  }

  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0,myData);
    });
  }

  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  addData(a){
    setState(() {
      data.add(a);
    });
  }

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
    initNotification(context);
    getData();
    saveData();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(child: Text('+'), onPressed: (){
        showNotification2();
      },),
      appBar: AppBar(
          title: Text('Instagram'),
          actions:[
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: () async{
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if(image != null){
                  setState(() {
                    userImage = File(image.path);
                  });
                }

                Image.file(userImage);

                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Upload(
                        userImage: userImage,
                        setUserContent: setUserContent,
                        addMyData: addMyData
                    ))
                );
              },
              iconSize: 30,
            )
        ]
      ),
      body: [Home(data : data, addData: addData),Text('Shop')][tab],
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

class Home extends StatefulWidget {
  Home({super.key, this.data, this.addData});
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        getMore();
      }
    });
  }
  @override
  Widget build(BuildContext context) {



    if(widget.data.isNotEmpty){
      return ListView.builder(
          itemCount: widget.data.length,
          controller : scroll,
          itemBuilder: (context,i){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 3/4,
                  child:
                  widget.data[i]['image'].runtimeType == String
                      ? Image.network(widget.data[i]['image'],fit:BoxFit.fill)
                      : Image.file(widget.data[i]['image'], fit:BoxFit.fill),
                ),
                GestureDetector(
                  child: Text(widget.data[i]['user']),
                  onTap: (){
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, a1,a2) => Profile(),
                        transitionsBuilder: (context, a1, a2, child) =>
                            SlideTransition(
                              position: Tween(
                                begin: Offset(1.0, 0.0),
                                end: Offset(0.0, 0.0),
                              ).animate(a1),
                              child: child,
                            ),
                      )
                    );
                  },
                ),
                Text('좋아요: ${widget.data[i]['likes']}'),
                Text(widget.data[i]['date']),
                Text(widget.data[i]['content'], style: TextStyle(
                    fontSize: fontSize1(context)
                )),
              ],
            );
          });
    } else {
      return Text('loading...');
    }
  }
}

fontSize1(context){
  if(MediaQuery.of(context).size.width > 600){
    return 30;
  } else {
    return 16;
  }
}

class Upload extends StatelessWidget {
  const Upload({super.key, this.userImage, this.setUserContent, this.addMyData});

  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: (){
          addMyData();
        }, icon: Icon(Icons.send))
      ],),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          Text('이미지 업로드 화면'),
          TextField(onChanged: (text){
            setUserContent(text);
          },),
          IconButton(onPressed:(){
            Navigator.pop(context);
          }, icon: Icon(Icons.close)
          ),
        ],
      )
    );
  }
}

class Store1 extends ChangeNotifier {
  var follower = 0;
  var checkFollower = false;
  var profileImage = [];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));
    var result2 = jsonDecode(result.body);
    profileImage = result2;
    print(profileImage);
    notifyListeners();
  }

  addFollower(){
    if(checkFollower == false) {
      follower++;
      checkFollower = true;
    }
    else{
      follower--;
      checkFollower = false;
    }
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier{
  var name = 'john kim';
}

class Profile extends StatefulWidget {
  const Profile({super.key});


  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name),),
      body: CustomScrollView(
        slivers:[
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                  (context,i) => Image.network(context.watch<Store1>().profileImage[i]),
                  childCount: context.watch<Store1>().profileImage.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3)
          )
        ],
      )
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().addFollower();
        }, child: Text('팔로우')),
        ElevatedButton(onPressed: (){
          context.read<Store1>().getData();
        }, child: Text('사진 가져오기')),
      ],
    );
  }
}