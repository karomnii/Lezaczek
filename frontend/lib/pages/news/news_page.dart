import 'package:flutter/material.dart';
import 'package:frontend/api/news_api.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/pages/news/news_details_page.dart';
import 'package:frontend/pages/news/news_form.dart';
import 'package:intl/intl.dart';
import '../../api/user_api.dart';
import '../../models/news.dart';
import '../../models/user.dart';

class NewsPage extends StatefulWidget {
  final User userDetails;
  const NewsPage(this.userDetails, {super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<News>> newsList;
  String? errorMsg;
  bool admin = false;

  @override
  void initState() {
    super.initState();
    refreshData();
    fetchAdminStatus(widget.userDetails);
  }

  Future<void> fetchAdminStatus(User userDetails) async{
    try {
      final isAdmin = await UserApi().isUserAnAdmin(userDetails);
      setState(() {
        admin = isAdmin;
      }); // Update the local variable
    } catch (error) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'Error'
            ),
            content: Text(error is Error ? error.text : 'Unexpected error has occurred'),
            contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                      )),
                ],
              )
            ],
          )
      );
    }
  }

  void refreshData() async{
    try{
      setState(() {
        newsList = NewsApi().getNews();
        if(errorMsg!=null){
          errorMsg = null;
        }
      });
    }
    catch(error){
      if(error is Error){
        errorMsg = error.text;
      }
      else{
        errorMsg = 'Unexpected error has occurred';
      }
    }
  }


  void addNews(News news) async {
    try {
      News createdNews = await NewsApi().createNews(news);
      setState(() {
        newsList = newsList.then((news) {
          news.add(createdNews);
          refreshData();
          return news;
        });
      });
      if(mounted){
        Navigator.pop(context, 'News added successfully');
      }
    }
    catch (error){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Error'
            ),
            content: Text(error is Error ? error.text : 'Unexpected error has occurred'),
            contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                      )),
                ],
              )
            ],
          )
      );
    }
  }

  void updateNews(News updatedNews) async{
    try {
      News createdNews = await NewsApi().updateNews(updatedNews);
      setState(() {
        newsList = newsList.then((news) {
          news.add(createdNews);
          refreshData();
          return news;
        });
      });
      if(mounted){
        Navigator.pop(context, 'News updated successfully');
      }
    }
    catch (error){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'Error'
            ),
            content: Text(error is Error ? error.text : 'Unexpected error has occurred'),
            contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                      )),
                ],
              )
            ],
          )
      );
    }
  }

  void deleteNews(News newsToDelete) async {
    try{
      await NewsApi().deleteNews(newsToDelete.newsId);
      setState(() {
        newsList = newsList.then((news){
          news.removeWhere((news) => news.newsId == newsToDelete.newsId);
          refreshData();
          return news;
        });
      });
      Navigator.pop(context, "News deleted successfully");
    }
    catch (error){
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'Error'
            ),
            content: Text(error is Error ? error.text : 'Unexpected error has occurred'),
            contentTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Close',
                      )),
                ],
              )
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
                  appBar: AppBar(
                    title: const Text(
                      'News',
                    ),
                    centerTitle: true,
                    scrolledUnderElevation: 0.0,
                    backgroundColor: Colors.white,
                    leading: DrawerButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                    actions: [
                      Visibility(
                        visible: admin == true,
                        child: IconButton(
                          onPressed: () async {
                            final res = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewsForm
                                  (onSave: (newsToAdd){
                                  addNews(newsToAdd);
                                  })
                                )
                            );
                            if(res!=null && res is String){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(res),
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.add)
                      ),)

                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        if(errorMsg!=null)
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              errorMsg!,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          ),
                        Expanded(
                            child: FutureBuilder<List<News>>(
                              future: newsList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator()
                                  );
                                }
                                else if(snapshot.hasError){
                                  snapshot.error is Error ? (errorMsg = (snapshot.error as Error).text): ('Unexpected error has occurred');
                                  return Center(
                                      child:Text(
                                          errorMsg!
                                      )
                                  );
                                }
                                else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text(
                                          'No news has been found',
                                      )
                                  );
                                }
                                else {
                                  List<News> listOfNews = snapshot.data!;
                                  return ListView.builder(
                                    itemCount: listOfNews.length,
                                    itemBuilder: (context, index) {
                                      News currentNews = listOfNews[index];
                                      String previousDate = index > 0 ? listOfNews[index-1].dateOfEvent.toString() : '';
                                      String currentDate = currentNews.dateOfEvent.toString();
                                      return Container(
                                          color: Colors.white,
                                          child: Column(
                                            children: [
                                              if(previousDate != currentDate)
                                                createDateContainer(currentNews.dateOfEvent),
                                              GestureDetector(
                                                onTap: () async {
                                                   final res = await Navigator.push(context,
                                                      MaterialPageRoute(
                                                          builder: (context) => NewsDetailsPage(
                                                          news: currentNews.convertToMap(),
                                                          onUpdate: (updatedNews){
                                                            updateNews(updatedNews);
                                                          },
                                                          onDelete: (){
                                                            deleteNews(currentNews);
                                                          },
                                                          admin: admin,
                                                          )
                                                  )
                                                  );
                                                   if(res!=null){
                                                     ScaffoldMessenger.of(context).showSnackBar(
                                                       SnackBar(
                                                         content: Text(res),
                                                       ),
                                                     );
                                                   }
                                                },
                                                child: Container(
                                                  margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                                                  padding: const EdgeInsets.all(10.0),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xff49D3F2),
                                                    borderRadius: BorderRadius.circular(8.0),
                                                    border: Border.all(color: Color(0xff49D3F2), width: 2.0),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              timeFormatter(currentNews.startingTime),
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                              ),
                                                            ),
                                                            Text(
                                                              timeFormatter(currentNews.endingTime),
                                                              style: TextStyle(
                                                                  fontSize: 16,
                                                                  color: Colors.black,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ),
                                                      Expanded(
                                                        flex: 4,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                                          child: Text(
                                                          currentNews.name,
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black,
                                                          ),
                                                          ),
                                                        ),
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                                          child: Text(
                                                            currentNews.place,
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black,
                                                            ),
                                                            textAlign: TextAlign.right,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                    },
                                  );
                                }
                              },
                            )
                        ),
                      ],
                    ),
                  ),
                );
  }

  String timeFormatter(TimeOfDay time){
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"; //hh:mm format
  }

  Widget createDateContainer(DateTime date){
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            DateFormat('dd MMMM yyyy').format(date),
            style: TextStyle(
                fontSize: 18,
            ),
          )
        ],
      ),
    );
  }
}
