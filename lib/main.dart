import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  bool show = true;
  ScrollController _controller = ScrollController();
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _controller.addListener(listener);
  }

  void listener() {
    if (_controller.position.userScrollDirection == ScrollDirection.forward) {
      show = true;
    } else if (_controller.position.userScrollDirection ==
        ScrollDirection.reverse) {
      show = false;
    }
    setState(() {});
  }

  int _counter = 0;
  int id = 0;
  Future<List<Dog>> _getDogs() async {
    // return this._memoizer.(() async {
    //   return await getDogs();
    // });
  }

  void _insertDog() async {
    id++;
    var fido = Dog(id: id, name: "fido$id", age: id * 3);
    await insertDog(fido);
    setState(() {});
  }

  void _updateDog(Dog fido) async {
    fido = Dog(
      id: fido.id,
      name: fido.name,
      age: fido.age + 7,
    );
    await updateDog(fido);
    setState(() {});
  }

  void _deleteDog(int id) async {
    await deleteDog(id);
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(listener);
    super.dispose();
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
                  controller: _controller,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data[index].name),
                      subtitle: Text("Age: ${snapshot.data[index].age}"),
                      onTap: () => _updateDog(snapshot.data[index]),
                      onLongPress: () => _deleteDog(snapshot.data[index].id),
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
        floatingActionButton: Visibility(
          visible: show,
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {});
                    },
                    child: Icon(Icons.refresh),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _insertDog,
                  tooltip: 'Increment',
                  child: Icon(Icons.add),
                ),
              ),
            ],
          ),
        ));
  }
}
