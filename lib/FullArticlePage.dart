import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class FullArticlePage extends StatefulWidget {

  final Map article;

  FullArticlePage(this.article);

  @override
  _FullArticlePageState createState() => _FullArticlePageState(this.article);
}

class _FullArticlePageState extends State<FullArticlePage> {

  final Map article;

  _FullArticlePageState(this.article);

  void _launchURL() async 
  {
    var url = this.article['url'];
    if (await canLaunch(url)) 
    {
      await launch(url);
    } 
    else 
    {
      throw 'Could not launch $url';
    }
  }

  Future shareArticle() async => await Share.share(this.article['url']);

  String getDate(String utcDate)
  {
    var date = DateTime.parse(utcDate);
    return "${date.day}-${date.month}-${date.year}" ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("News App"),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.share),
      //       onPressed: shareArticle,
      //     )
      //   ],
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                // article image start
                Stack(
                  children: <Widget>[

                    // article image start
                    article['urlToImage'] == null?
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      child: Image(
                        height: 200,
                        width: double.infinity,
                        image: AssetImage('assets/images/no_image.png'),
                        fit: BoxFit.cover,
                      ),
                    ) :
                    Container(
                      height: 200,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 16),
                      alignment: Alignment.center,
                      child: Image(
                        height: 200,
                        width: double.infinity,
                        image: NetworkImage(
                          article['urlToImage'].startsWith('https://') ||
                          article['urlToImage'].startsWith('http://')?
                          article['urlToImage'] : 
                          'https://${article['urlToImage']}' 
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    // article image end

                    // share btn start
                    Container(
                      height: 220,
                      padding: EdgeInsets.only(right: 8),    
                      alignment: Alignment.bottomRight,                
                      child: FloatingActionButton(
                        child: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        onPressed: () => shareArticle(),
                      ),
                    ),
                    // share btn end

                    // back btn start
                    Container(
                      padding: EdgeInsets.all(16),                    
                      child: InkWell(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onTap: () => Navigator.pop(context),
                      ),
                    ),
                    // back btn end


                  ],
                ),
                // article image end

                // article title start
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: Text(
                    article['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // article title end

                

                // article details start
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      // article published time & source name start
                      Row(
                        children: <Widget>[

                          // article source name start
                          Container(
                            child: Text(
                              article['source']['name'],
                              style: TextStyle(
                                fontSize: 12,
                                color: Theme.of(context).textSelectionHandleColor,
                              ),
                            ),
                          ),
                          // article source name end

                          // divider start
                          Container(
                            height: 10,
                            width: 1,
                            color: Colors.black,
                            margin: EdgeInsets.symmetric(horizontal: 8),
                          ),
                          // divider end

                          // article published time start
                          Container(
                            child: Row(
                              children: <Widget>[
                                Icon(
                                  Icons.calendar_today,
                                  size: 12,
                                ),

                                Text(
                                  " ${this.getDate(article['publishedAt'])}",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // article published time end
                        ],
                      ),
                      // article source name end

                      // article author start
                      article['author'] == null?
                      Container() :
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 8),
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Edited By: ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700
                              ),
                            ),

                            Text(
                              article['author'],
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // article author end

                      Divider(),

                      Container(height: 16,),

                      // article description start
                      article['description'] == null?
                      Container() :
                      Container(
                        child: Text(
                          article['description'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // article description end

                      Container(height: 16,),

                      // article content start
                      article['content'] == null?
                      Container() :
                      Container(
                        width: double.infinity,
                        child: Text(
                          article['content'],
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // article content end

                    ],
                  ),
                ),
                // article details end

                Container(height: 16,),

                // Read full article btn start
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: MaterialButton(
                    color: Theme.of(context).textSelectionHandleColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      "Read full article",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () => this._launchURL(),
                  ),
                ),
                // Read full article btn end

              ],
            ),
          ),
        ),
      ),
    );
  }
}