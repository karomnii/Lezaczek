import 'package:flutter/material.dart';
import 'package:frontend/api/news_api.dart';
import 'package:frontend/components/side_bar.dart';
import 'package:frontend/models/error.dart';
import 'package:frontend/pages/news/news_details_page.dart';
import 'package:frontend/pages/news/news_form.dart';
import 'package:intl/intl.dart';
import '../../helpers/http_helper.dart';
import '../../helpers/storage_helper.dart';
import '../../models/news.dart';
import '../../models/user.dart';
import '../login/LoginPage.dart';
import '../../api/user_api.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<News>> newsList;
  String? errorMsg;
  bool admin = false;
  late User userDetails;

  void addNews(News news) async {
    try {
      News createdNews = await NewsApi().createNews(news);
      setState(() {
        newsList = newsList.then((news) {
          news.add(createdNews);
          return news;
        });
      });
    }
    catch (e){
      setState(() {
        if(e is Error){
          errorMsg = e.text;
        }
        else{
          errorMsg = 'Unexpected error has occured';
        }
      });
    }
  }

  void updateNews(News updatedNews) async{
    try{
      News updateNews = await NewsApi().updateNews(updatedNews);
      setState(() {
        newsList = newsList.then((news){
          int updatedNewsIndex = news.indexWhere((news) => news.newsId == updateNews.newsId);
          news[updatedNewsIndex] = updateNews;
          return news;
        });
      });
    }
    catch(e){
      setState(() {
        if(e is Error){
          errorMsg = e.text;
        }
        else{
          errorMsg = 'Unexpected error has occurred';
        }
      });
    }
  }

  void deleteNews(News newsToDelete) async {
    try{
      await NewsApi().deleteNews(newsToDelete.newsId);
      setState(() {
        newsList = newsList.then((news){
          news.removeWhere((news) => news.newsId == newsToDelete.newsId);
          return news;
        });
      });
    }
    catch(e){
      setState(() {
        if(e is Error){
          errorMsg = e.text;
        }
        else{
          errorMsg = 'Unexpected error has occurred';
        }
      });
    }
  }

  ValueNotifier<User?> userNotifier = ValueNotifier(null);
  Future<User?> asyncInitUser() async {
    String? accessToken = await StorageHelper.get("accessToken");
    String? refreshToken = await StorageHelper.get("refreshToken");
    String? name = await StorageHelper.get("name");
    String? surname = await StorageHelper.get("surname");
    String? email = await StorageHelper.get("email");
    String? gender = await StorageHelper.get("gender");
    Gender? userGender;
    if (gender != null) {
      userGender = Gender.values[int.parse(gender)];
    }
    if (refreshToken != null && accessToken != null && userGender != null) {
      HttpHelper.setCookieVal("accessToken=${accessToken}");
      HttpHelper.setCookieVal("refreshToken=${refreshToken}");
      HttpHelper.updateCookieFromHeaders();
      return User(accessToken: accessToken,
          refreshToken: refreshToken,
          name: name,
          surname: surname,
          email: email,
          gender: userGender);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(future: asyncInitUser(),
        builder: (BuildContext context, AsyncSnapshot<User?> user) {
          if (user.hasData) {
            userNotifier.value = user.data;
          }
          return ValueListenableBuilder<User?>(
              valueListenable: userNotifier,
              builder: (BuildContext context, User? userValue,
                  Widget? child) {
                if (userValue == null) {
                  return LoginPage(user: userNotifier);
                }
                refreshData();

                return Scaffold(
                  drawer: SideBar(user: userNotifier),
                  appBar: AppBar(
                    title: const Text(
                      'News',
                    ),
                    centerTitle: true,
                    scrolledUnderElevation: 0.0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: true,
                    actions: [
                      Visibility(
                        visible: admin == true,
                        child: IconButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => NewsForm
                                  (onSave: (newsToAdd){
                                  addNews(newsToAdd);
                                  Navigator.pop(context);
                                })
                                )
                            );

                          },
                          icon: Icon(Icons.add)
                      ),)

                    ],
                  ),
                  body: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Expanded(
                            child: FutureBuilder<List<News>>(
                              future: newsList,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Center(
                                      child: CircularProgressIndicator());
                                }
                                else if(snapshot.hasError){
                                  if(snapshot.error is Error){
                                    errorMsg = (snapshot.error as Error).text;
                                  }
                                  else{
                                    errorMsg = 'Unexpected error has occurred';
                                  }
                                  return Center(
                                      child:Text(
                                          errorMsg!,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      )
                                  );
                                }
                                else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Center(
                                      child: Text(
                                          'No news has been found',
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
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
                                                onTap: (){
                                                  Navigator.push(context,
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
          );
        });
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

  void refreshData() async{
      newsList = NewsApi().getNews();
  }

  @override
  void initState() {
    super.initState();
    refreshData();
    initUser();
  }

  Future<User?> initUser()async{
    User? user = await asyncInitUser();
    if(user != null){
      userDetails = user;
      fetchAdminStatus();
    }
  }

  Future<void> fetchAdminStatus() async{
    try {
      final isAdmin = await UserApi().isUserAnAdmin(userDetails); // Replace with your logic
      setState(() {
        admin = isAdmin;
      }); // Update the local variable
    } catch (error) {
      print('Error fetching admin status: $error');
      // Handle the error (show an error message, retry, etc.)
    }
  }
}
