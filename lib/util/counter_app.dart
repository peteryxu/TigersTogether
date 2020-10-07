import 'package:flutter/material.dart';


//https://gist.github.com/Andrious?page=3

/*
By design, the State object’s constructor and initState() is not Ored again in such a sequence of events
*/


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  MyHomePage({Key key, this.title}) : super(key: key){
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   MyHomePage being created. Constructor called.");
  }
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // constructor
  _MyHomePageState() : super() {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState being created. Constructor called.");
  }
  int _counter = 0;
//  int _counter;
//
//  @override
//  void initState(){
//    super.initState();
//    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState initState() called.");
//    _counter = 0;
//  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState build() called!");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(">>>>>>>>>>>>>>>>>>>>>>>>>   'Floating Blue' button pressed. Function setState() called.");
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}