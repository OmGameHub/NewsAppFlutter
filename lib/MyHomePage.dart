import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert';
import 'dart:io';
import 'ApiDate.dart';
import 'FullArticlePage.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String topHeadlinesApi = 'https://newsapi.org/v2/top-headlines?country=in&';
  String apiKey = 'test';    // <= TODO insert api key from newsapi.org
  String category = '';
  String appBarTitle = 'News App';

  List articles = [];
  bool hasData = false;
  bool isInternetConn = false;
  String message = "";

  bool isDarkThemeEnable = false;

  @override
  void initState() 
  {
    getTopHeadlines();
    super.initState();
  }

  void setTheme(bool value)
  {
    setState(() {
      this.isDarkThemeEnable = !this.isDarkThemeEnable;
    });

    DynamicTheme.of(context).setBrightness(isDarkThemeEnable? Brightness.dark : Brightness.light);
    DynamicTheme.of(context).setThemeData(isDarkThemeEnable? ThemeData.dark() : ThemeData.light());
  }

  void setNewsCategory(String category)
  {
    category = category.trim();
    setState(() {
      this.category = category.isNotEmpty? 'category=$category&' : '';
      this.appBarTitle = category.isNotEmpty? 
        category[0].toUpperCase() + category.substring(1) : 
        'News App';

      this.articles = [];
      hasData = false;
    });

    Navigator.pop(context);

    getTopHeadlines();
  }

  Future getTopHeadlines() async 
  {
    try 
    {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) 
      {

        if (this.apiKey == 'test' || this.apiKey.isEmpty) {
          setState(() {
            articles = apiDate['articles'];
            hasData = true;
            this.isInternetConn = true;
          });
          print("Plese insert your api key");
          return;
        }

        setState(() => this.isInternetConn = true);
        var url = topHeadlinesApi + category + 'apiKey=' + apiKey;
        var respones = await http.get(Uri.encodeFull(url));
        var jsonRespones = json.decode(respones.body);

        if (jsonRespones['status'] == "ok") 
        {  
          setState(() {
            articles = jsonRespones['articles'];
            hasData = true;
            this.isInternetConn = true;
          });
        }
        else
        {
          print("Error message: ${jsonRespones['message']}");
        }
      }
      else
      {
        setState(() {
          this.isInternetConn = false;
          this.message = "Check you internet connection";
        });
      }
    } 
    on SocketException catch (_) 
    {
      print('not connected');
      setState(() {
        this.isInternetConn = false;
        this.message = "Check you internet connection";
      });
    }
  }

  void openFullArticle(int intdex) 
  {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (BuildContext context) => FullArticlePage(articles[intdex])
      )
    );
  }

  // article list item start
  Widget article(int index) => 
  Card(
    child: InkWell(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[

            // article image start
            articles[index]['urlToImage'] == null?
            Container() :
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Color(0xFFEAF0F1),
                child: Image.network(
                  articles[index]['urlToImage'].startsWith('https://') ||
                  articles[index]['urlToImage'].startsWith('http://')?
                  articles[index]['urlToImage'] :
                  'http://${articles[index]['urlToImage']}',
                  loadingBuilder: (context, child, progress) => 
                    progress == null? 
                    child : 
                    Container(
                      height: 100,
                      width: 100,
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator()
                    ),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // article image end  

            // article title start
            Expanded(
              child: Container(
                height: 100,
                margin: EdgeInsets.only(left: 10),
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Expanded(
                      flex: 1,
                      child: Container(
                        child: Text(
                          articles[index]['title'],
                          softWrap: true,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Text(
                      articles[index]['source']['name'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textSelectionHandleColor,
                      ),
                    ),

                  ],
                ),
              ),
            ),
            // article title end

          ],
        ),
      ),
      onTap: () => this.openFullArticle(index),
    ),
  );
  // article list item end

  // app drawer start
  Widget _drawer() =>
  Drawer(
    child: ListView(
      children: <Widget>[

        DrawerHeader(
          child: Row(
            children: <Widget>[
              
              CircleAvatar(
                radius: 45,
                backgroundImage: NetworkImage('https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
              ),

              Expanded(
                child: Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Text("Om Prakash"),
                      
                      Text("om@gmail.com"),

                    ],
                  ),
                ),
              ),

            ],
          ),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.home),
          title: Text("Home"),
          onTap: () => this.setNewsCategory(''),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.briefcase),
          title: Text("Business"),
          onTap: () => this.setNewsCategory('business'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.film),
          title: Text("Entertainment"),
          onTap: () => this.setNewsCategory('entertainment'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.users),
          title: Text("General"),
          onTap: () => this.setNewsCategory('general'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.heartbeat),
          title: Text("Health"),
          onTap: () => this.setNewsCategory('Health'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.atom),
          title: Text("Science"),
          onTap: () => this.setNewsCategory('Science'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.baseballBall),
          title: Text("Sports"),
          onTap: () => this.setNewsCategory('sports'),
        ),

        ListTile(
          leading: Icon(FontAwesomeIcons.robot),
          title: Text("Technology"),
          onTap: () => this.setNewsCategory('technology'),
        ),

        Divider(),

        Container(
          padding: EdgeInsets.all(10),
          child: Text(
            "Setting",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          )
        ),

        ListTile(
          title: Text("Datk Theme"),
          trailing: Switch(
            value: this.isDarkThemeEnable,
            onChanged: (bool value) => this.setTheme(value), 
          ),
          onTap: () => this.setNewsCategory('technology'),
        ),

      ],
    ),
  );
  // app drawer end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: this._drawer(),
      appBar: AppBar(
        title: Text(this.appBarTitle),
      ),
      body: !this.isInternetConn? 
        Center(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  this.message,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),

                Container(height: 16,),

                MaterialButton(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  color: Theme.of(context).textSelectionHandleColor,
                  child: Text(
                    "Retry",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: getTopHeadlines,
                )
              ],
            ),
          ),
        ) :
        hasData?
        ListView.builder(
          itemCount: articles.length,
          itemBuilder: (BuildContext context, int index) => article(index),
        ) : 
        Center(child: CircularProgressIndicator()),
    );
  }
}