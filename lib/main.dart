import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  int id = 0;
  void _insertDog() async {
    id++;
    var fido = Dog(id: id, name: "fido$id", age: id * 3);
    await insertDog(fido);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sqflite Demo"),
        ),
        body: Container(
          child: FutureBuilder(
            future: getDogs(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text("Age: ${snapshot.data[index].age}"),
                    );
                  },
                );
              } else {
                return Container(
                    child: Center(
                  child: Text("Loading..."),
                ));
              }
            },
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            // Padding(
            //   padding: EdgeInsets.only(left: 30),
            //   child: Align(
            //     alignment: Alignment.bottomLeft,
            //     child: FloatingActionButton(
            //       onPressed: setState(() {
                    
            //       });,
            //       child: Icon(Icons.refresh),
            //     ),
            //   ),
            // ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: _insertDog,
                tooltip: 'Increment',
                child: Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}
