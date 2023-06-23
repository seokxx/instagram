import 'package:flutter/material.dart';
import 'style.dart' as style;

void main() {
  runApp(MaterialApp(
    theme: style.theme,
    home: MyApp()
    )
  );
}

var bodyText = TextStyle(color: Colors.red);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram'),
          actions:[
            IconButton(
              icon: Icon(Icons.add_box_outlined),
              onPressed: (){},
              iconSize: 30,
            )
        ]
      ),
      body: TextButton(onPressed: (){}, child: Text('안녕'),)
    );
  }
}
