import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_blog_mobile/model/PostProvider.dart';
import 'package:personal_blog_mobile/page/home/CategorySelector.dart';
import 'package:personal_blog_mobile/page/home/PostCard.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 50)).then((value) async {
      PostProvider postProvider = Provider.of(context, listen: false);
      await _refresh(postProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of(context);
    var brightness = Theme.of(context).brightness;
    bool darkModeOn = brightness == Brightness.dark;

    return Material(
      child: CupertinoPageScaffold(
        child: _buildBody(postProvider, context, darkModeOn),
      ),
    );
  }

  Widget _buildBody(
      PostProvider postProvider, BuildContext context, bool darkModeOn) {
    return NestedScrollView(
      controller: scrollController,
      headerSliverBuilder: (context, _) {
        return [
          CupertinoSliverNavigationBar(
            trailing: FlatButton(
              child: Text("Category"),
              onPressed: () async {
                await CupertinoScaffold.showCupertinoModalBottomSheet(
                  context: context,
                  builder: (c) => CategorySelector(),
                );

                await _refresh(postProvider);
              },
            ),
            largeTitle: GestureDetector(
              onTap: () {
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 100),
                    curve: Curves.easeInOut);
              },
              child: Text(
                "${postProvider.selectedCategory == null ? "All" : "${postProvider.selectedCategory.category}"}",
                style: darkModeOn
                    ? TextStyle(color: Colors.white)
                    : TextStyle(
                        color: Colors.black,
                      ),
              ),
            ),
          ),
        ];
      },
      body: Scrollbar(
        child: EasyRefresh(
          topBouncing: false,
          // scrollController: scrollController,
          header: BallPulseHeader(),
          footer: BallPulseFooter(),
          // onRefresh: () async {
          //   await _refresh(postProvider);
          // },
          onLoad: postProvider.nextURL != null
              ? () async {
                  await _loadMore(postProvider);
                }
              : null,
          child: ListView.builder(
            // controller: scrollController,
            itemCount: postProvider.posts.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                  height: 30,
                );
              }

              var post = postProvider.posts[index - 1];
              return Container(height: 500, child: PostCard(post: post));
            },
          ),
        ),
      ),
    );
  }

  Future _loadMore(PostProvider postProvider) async {
    if (postProvider.nextURL != null) {
      try {
        EasyLoading.show(status: "Fetching posts");
        await postProvider.fetchMorePosts();
      } catch (err) {
        EasyLoading.showError(err.toString());
      } finally {
        EasyLoading.dismiss();
      }
    }
  }

  Future _refresh(PostProvider postProvider) async {
    try {
      EasyLoading.show(status: "Fetching posts");
      await postProvider.fetchPosts();
      EasyLoading.show(status: "Fetching categories");
      await postProvider.fetchCategories();
      await scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
      );
    } catch (err) {
      EasyLoading.showError(err.toString());
    } finally {
      EasyLoading.dismiss();
    }
  }
}
