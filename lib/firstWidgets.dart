import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:english_words/english_words.dart';


/*--------------------Non-Immutable Sample Stateless Widget--------------------*/
class MyMainWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final wp = WordPair.random();
    //Its like React's functional components
    return MaterialApp(
      title: 'Marklar to Marklar',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Marklar in AppBar'),
        ),
        body: Center(
          child: Text(wp.asPascalCase),
        ),
      ),
    );
  }
}

/*----------------------Stateful bit ------------------- */
///Created a second stateless widget to invoke stateful widget.

class MyMainWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Its like React's functional components
    return MaterialApp(
      title: 'Marklar to Marklar',
      ///theme parameter can be used to configure
      ///app visuals. Tweak Primary color and have fun.
      theme: ThemeData(
        primaryColor: Colors.lightGreen,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Marklar Green in AppBar'),
        ),        
        body: Center(
          child: MyStatefulMain(),
        ),
      ),
    );
  }
}

/// Non immutable stateful widget
class MyStatefulMain extends StatefulWidget {
  @override
  InteractiveInfiScrollState createState() => InteractiveInfiScrollState();
}

/// Immutable states

/// Provides text widget with random widget
class RandomWordState extends State<MyStatefulMain> {
  /// State has build method because it has updated data. This way whenever build is called on stateful widget it invokes build on state and shows dynamic data.
  @override
  Widget build(BuildContext context) {
    final wp = WordPair.random();
    return Text('stateless ' + wp.asPascalCase);
  }
}

/// Provides infinite scroll list
class InfiScrollState extends State<MyStatefulMain> {
  final List<WordPair> _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }

  ///Now our build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
      ),
      body: _buildSuggestions(),
    );
  }
}

/*---------------Part 2 tutorial starts-------------------------- */
/// Features: Interactivity, routing and theme change
/// Provides infinite scroll list with favorite icons
class InteractiveInfiScrollState extends State<MyStatefulMain> {
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _saved = Set<WordPair>();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved =
        _saved.contains(pair); //added to store storage state

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        // Favorite icon added here
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red[200] : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  ///Now our build function
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Startup Name Generator'),
        //Add button to app bar to navigate to another screen
        actions: <Widget>[
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: _buildSuggestions(),
    );
  }
  /// Please Note our structure: 
  /// Stateless main widget returns materialApp widget 
  ///                 ↓
  /// MaterialApp provides Stateful widget
  ///                 ↓
  /// Stateful widget uses State to build out dynamic app
  /// 
  /// This was done for simplicity and our education. 
  /// We can directly return the materialApp widget in the build function 
  /// here in the state.

  ///Saves list of saved items 
  ///to be viewed in another widget
  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context){

        ///create an iterator that 
        ///returns tiles for every pair stored in list 
        final Iterable<ListTile> tiles = _saved.map(
          (WordPair pair) {
            return ListTile(
              title: Text(
                pair.asPascalCase,
                style: _biggerFont,
              ),
            );
          },
        );


        // convert iterator into list(array) of ListTiles 
        final List<Widget> divided = ListTile
          .divideTiles(
            context: context,
            tiles: tiles,
          )
              .toList();


        /// pass list(array) of ListTiles 
        /// into the body of a scaffold
        return Scaffold(
          appBar: AppBar(
            title: Text('Saved names'),
          ),
          body: ListView(
            children: divided,
          ),
        );
      })
    );
  }
}
