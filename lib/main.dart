import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const PiAquarium(),
    );
  }
}

class PiAquarium extends StatefulWidget {
  const PiAquarium({super.key});

  @override
  State<StatefulWidget> createState() => _PiAquariumState();
}

class _PiAquariumState extends State<PiAquarium> {
  int counter = 0;

  void count() {
    setState(() {
      counter++;
    });
  }

  void reset() {
    setState(() {
      counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    PiTexts piTexts = PiTexts(counter: counter);

    return Scaffold(
      appBar: AppBar(
        title: const Text('円周率の水族館'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              count();
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              reset();
            },
          ),
        ],
      ),
      body: Center(
        child: piTexts,
      ),
    );
  }
}

class PiTexts extends StatelessWidget {
  PiTexts({super.key, required this.counter});

  final String pi = '''3.
  1415926535 8979323846 2643383279 5028841971 6939937510
  5820974944 5923078164 0628620899 8628034825 3421170679
  8214808651 3282306647 0938446095 5058223172 5359408128
  4811174502 8410270193 8521105559 6446229489 5493038196
  4428810975 6659334461 2847564823 3786783165 2712019091
  4564856692 3460348610 4543266482 1339360726 0249141273
  7245870066 0631558817 4881520920 9628292540 9171536436
  7892590360 0113305305 4882046652 1384146951 9415116094
  3305727036 5759591953 0921861173 8193261179 3105118548
  0744623799 6274956735 1885752724 8912279381 8301194912
  9833673362 4406566430 8602139494 6395224737 1907021798
  6094370277 0539217176 2931767523 8467481846 7669405132
  0005681271 4526356082 7785771342 7577896091 7363717872
  1468440901 2249534301 4654958537 1050792279 6892589235
  4201995611 2129021960 8640344181 5981362977 4771309960
  5187072113 4999999837 2978049951 0597317328 1609631859
  5024459455 3469083026 4252230825 3344685035 2619311881
  7101000313 7838752886 5875332083 8142061717 7669147303
  5982534904 2875546873 1159562863 8823537875 9375195778
  1857780532 1712268066 1300192787 6611195909 2164201989
  '''.replaceAll(RegExp(r"\s+"), '');
  final int counter;

  @override
  Widget build(BuildContext context) {
    int lengthShowingPi = 12;
    int beginPi = counter * lengthShowingPi;
    int endPi = beginPi + lengthShowingPi;
    Iterable<StatefulWidget> piTexts =
        pi.runes.toList().sublist(beginPi, endPi).asMap().entries.map((entry) {
      int index = entry.key;
      double moveX = index % 2 != 0 ? 0 : 2 / lengthShowingPi;
      double beginX = -0.5 + index / lengthShowingPi;
      double endX = beginX + moveX;
      double moveY = -1.0 + index * 2 / lengthShowingPi;
      double beginY = 0.0;
      double endY = moveY;
      String piCharacter = String.fromCharCode(entry.value);
      return MyAnimatedText(
        text: piCharacter,
        index: index,
        beginX: beginX,
        beginY: beginY,
        endX: endX,
        endY: endY,
      );
    });
    return Stack(children: piTexts.toList());
  }
}

class MyAnimatedText extends StatefulWidget {
  const MyAnimatedText({
    super.key,
    required this.text,
    required this.index,
    required this.beginX,
    required this.beginY,
    required this.endX,
    required this.endY,
  });

  final String text;
  final int index;
  final double beginX;
  final double beginY;
  final double endX;
  final double endY;

  @override
  _MyAnimatedTextState createState() => _MyAnimatedTextState();
}

class _MyAnimatedTextState extends State<MyAnimatedText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<Offset>(
      begin: Offset(widget.beginX, widget.beginY),
      end: Offset(widget.endX, widget.endY),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: _animation.value * 250, // テキストの移動距離を設定
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 32.0),
          ),
        );
      },
    );
  }
}

// 以下。未使用コード

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
