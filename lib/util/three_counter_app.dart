import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MyApp(): super(){
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   MyApp StatelessWidget being created. Constructor called.");
  }
  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   MyApp build() called! and created MaterialApp");
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Home Page'),
    );
  }
}

/// High-level variable. Identifies the widget. New key? New widget!
Key _key = UniqueKey();

class MyHomePage extends StatefulWidget {
  // constructor
  MyHomePage({Key key, this.title}) : super(key: key){
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   MyHomePage StatefulWidget being created. Constructor called.");
  }
  final String title;

  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  // constructor
  _MyHomePageState() : super() {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState being created. Constructor called.");
  }
  int _counter = 0;

  void initState() {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState initState() called.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _MyHomePageState build() called!");
    return _FirstPage(
      key: _key,
      title: "${widget.title} counter pressed: $_counter",
      state: this,
    );
  }
}

class _FirstPage extends StatefulWidget {
  // constructor
  _FirstPage({Key key, @required this.title, @required this.state})
      : super(key: key) {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   FirstPage StatefulWidget being created. Constructor called.");
  }
  final String title;
  final _MyHomePageState state;

  @override
  _FirstPageState createState() {
    return _FirstPageState();
  }
}

class _FirstPageState extends State<_FirstPage> {
  // constructor
  _FirstPageState() : super() {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   _FirstPageState being created. Constructor called.");
  }
  int _counter = 0;

  void initState() {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _FirstPageState initState() called.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _FirstPageState build() called!");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
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
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          child: Text(
            'Home Page Counter',
          ),
          onPressed: () {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>   'Home Page Counter' button pressed.");
            widget.state.setState(() {
              widget.state._counter++;
            });
          },
        ),
        RaisedButton(
          child: Text(
            'Second Page',
          ),
          onPressed: () {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>   'Second Page' button pressed.");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        _SecondPage(title: "You're on the Second Page", state: widget.state)));
          },
        ),
      ],
    );
  }

  void deactivate() {
    super.deactivate();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _FirstPageState deactiviated.");
  }

  void dispose() {
    super.dispose();
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   _FirstPageState disposed. Counter was $_counter");
  }
}

class _SecondPage extends StatefulWidget {
  _SecondPage({Key key, @required this.title, @required this.state}) : super(key: key) {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   SecondPage StatefulWidget being created. Constructor called.");
  }
  final String title;
  final _MyHomePageState state;


  @override
  _SecondPageState createState() {
    return _SecondPageState();
  }
}

class _SecondPageState extends State<_SecondPage> {
  _SecondPageState() : super() {
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   _SecondPageState being created. Constructor called.");
  }
  int _counter = 0;

  void initState() {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _SecondPageState initState() called.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _SecondPageState build() called!");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("You're on this second page."),
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(
              ">>>>>>>>>>>>>>>>>>>>>>>>>   Second page 'Floating Blue' button pressed. setState() called.");
          setState(() {
            _counter++;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: <Widget>[
        RaisedButton(
          child: Text(
            'New Key',
          ),
          onPressed: () {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>   'New Key' button pressed.");
            _key = UniqueKey();
          },
        ),
        RaisedButton(
          child: Text(
            'Home Page Counter',
          ),
          onPressed: () {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>   'Home Page Counter' button pressed.");
            widget.state.setState(() {
              widget.state._counter++;
            });
          },
        ),
        RaisedButton(
          child: Text(
            'First Page',
          ),
          onPressed: () {
            print(">>>>>>>>>>>>>>>>>>>>>>>>>   'First Page' button pressed.");
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  void deactivate() {
    super.deactivate();
    print(">>>>>>>>>>>>>>>>>>>>>>>>>   _SecondPageState deactiviated.");
  }

  void dispose() {
    super.dispose();
    print(
        ">>>>>>>>>>>>>>>>>>>>>>>>>   _SecondPageState disposed. Counter was $_counter");
  }
}