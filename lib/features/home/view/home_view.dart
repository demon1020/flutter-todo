import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:intl/intl.dart';
import 'package:todo/features/todo/view/todo_view.dart';

import '/core.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    var chatProvider = Provider.of<HomeViewViewModel>(context, listen: false);
    chatProvider.init();
    super.initState();
  }

  String get myUserName => AuthViewModel().getUser().toString();

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final provider = Provider.of<HomeViewViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo [${authViewModel.getUser()}]'),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
              onTap: () {
                authViewModel.logout(context);
                Navigator.pushNamed(context, RoutesName.login);
              },
              child: const Center(child: Text('Logout'))),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: provider.todosStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 16),
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data!.docs[index];
                    String name =
                        ds.id.replaceAll(myUserName, "").replaceAll("_", "");
                    String chatRoomId = ds.id;

                    String time = ds['timestamp'];
                    // DateTime date = DateTime.parse(data);
                    // String time = DateFormat.jm().format(date);
                    return GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(arguments: ds.id,
                          navigatorKey.currentContext!,
                          RoutesName.todoView,
                        );
                      },
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          child: Column(
                            children: [
                              ListTile(
                                leading: IconButton(onPressed: (){},icon: Icon(Icons.info,size: 30,)),
                                title: Text('${ds['title']}'),
                                subtitle: Flexible(
                                  child: Text(
                                    '${ds['description']}',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '$time',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              // Container(
                              //   padding: EdgeInsets.symmetric(horizontal: 10),
                              //   child: Row(
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Container(
                              //         padding: EdgeInsets.all(5),
                              //         decoration: ShapeDecoration(
                              //             shape:
                              //                 StadiumBorder(side: BorderSide())),
                              //         child: Text(
                              //           'Created by : ${ds['createdBy']}',
                              //         ),
                              //       ),
                              //       Text(
                              //         '$time',
                              //         overflow: TextOverflow.ellipsis,
                              //         style: TextStyle(
                              //           overflow: TextOverflow.ellipsis,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container();
        },
      ),
      floatingActionButton: SizedBox(
        height: 60,
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pushNamed(
            //   navigatorKey.currentContext!,
            //   RoutesName.todoView,
            // );
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoView(todoId: "")));
          },
          child: Text('Add new todo'),
        ),
      ),
    );
  }

  buildHomeScreen(provider) {
    switch (provider.moviesList.status) {
      case Status.loading:
        return Skeletonizer(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  leading: Image.network(
                    'url',
                    errorBuilder: (context, error, stack) {
                      return const Icon(
                        Icons.error,
                        color: Colors.red,
                      );
                    },
                    height: 40,
                    width: 40,
                    fit: BoxFit.cover,
                  ),
                  title: Text("Title"),
                  subtitle: Text("Subtitle"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(Utils.averageRating([]).toStringAsFixed(1)),
                      const Icon(
                        Icons.star,
                        color: Colors.yellow,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      case Status.error:
        return Center(child: Text(provider.moviesList.message.toString()));
      case Status.completed:
        return Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount: provider.moviesList.data!.movies!.length,
              itemBuilder: (context, index) {
                var item = provider.moviesList.data!.movies![index];
                return Card(
                  child: ListTile(
                    leading: Image.network(
                      item.posterurl.toString(),
                      errorBuilder: (context, error, stack) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                        );
                      },
                      height: 40,
                      width: 40,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.title.toString()),
                    subtitle: Text(item.year.toString()),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(Utils.averageRating(item.ratings!)
                            .toStringAsFixed(1)),
                        const Icon(
                          Icons.star,
                          color: Colors.yellow,
                        )
                      ],
                    ),
                  ),
                );
              }),
        );
      default:
        return const Text('No Data');
    }
  }
}
