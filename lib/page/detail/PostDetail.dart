import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:draft_view/draft_view.dart';
import 'package:draft_view/draft_view/view/DraftView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:personal_blog_mobile/model/post_object.dart';

class PostDetail extends StatefulWidget {
  final Post post;

  const PostDetail({Key key, this.post}) : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  Map<String, dynamic> draftData = {};
  Map<String, dynamic> settings = {};
  bool shouldExit = false;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    draftData = JsonDecoder().convert(widget.post.content);
    settings = JsonDecoder().convert(widget.post.settings);
    // scrollController.addListener(() {
    //   if (scrollController.offset < -100) {
    //     scrollController.dispose();
    //     Navigator.pop(context);
    //   }
    // });
  }

  bool get isBrightColor {
    if (widget.post.coverColor.length == 0) {
      return true;
    }
    var color = widget.post.coverColor.first;
    var hsp = sqrt(0.299 * (color.red * color.red) +
        0.587 * (color.green * color.green) +
        0.114 * (color.blue * color.blue));

    return hsp > 190;
  }

  TextStyle get textStyle {
    var style = Theme.of(context).textTheme.headline1.copyWith(
        fontSize: 25,
        color: isBrightColor ? Colors.black : Colors.white,
        fontWeight: FontWeight.bold,
        shadows: [
          Shadow(
            offset: Offset(1, 1.5),
            blurRadius: 0,
            color: !isBrightColor ? Colors.black : Colors.white,
          ),
        ]);

    return style;
  }

  Widget _buildHeaderImage() {
    return Container(
      child: Stack(
        children: [
          if (widget.post.imageUrl != null)
            CachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              fit: BoxFit.cover,
              height: 400,
              width: MediaQuery.of(context).size.width * 1.2,
              placeholder: (c, _) => Center(
                child: CircularProgressIndicator(),
              ),
            ),
          if (widget.post.imageUrl == null)
            Container(
              height: 400,
              color: Colors.pink,
            ),
          Positioned(
            top: 30,
            width: MediaQuery.of(context).size.width * 0.5,
            left: 10,
            child: RichText(
              text: TextSpan(
                text: "${widget.post.title}\n",
                style: textStyle,
                children: [
                  TextSpan(
                    text: "${widget.post.postCategory.category}",
                    style: textStyle.copyWith(fontSize: 15),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).textTheme.bodyText1.color;

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 30),
          headline2: TextStyle(fontSize: 25),
          headline3: TextStyle(fontSize: 20),
          bodyText1: TextStyle(height: 2, fontSize: 17, color: color),
        ),
        primaryColor: Colors.blue,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Scrollbar(
              child: EasyRefresh(
                header: BezierCircleHeader(
                  backgroundColor: Theme.of(context).cardColor,
                ),
                onRefresh: () async {
                  Navigator.pop(context);
                },
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    children: [
                      _buildHeaderImage(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: DraftView(rawDraftData: draftData, plugins: [
                          TextPlugin(),
                          BlockQuotePlugin(),
                          HeaderPlugin(),
                          ImagePlugin(),
                          PostSettingsPlugin(rawSettings: settings),
                          ListPlugin(),
                          AudioPlugin(),
                          LinkPlugin(),
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
                right: 6,
                top: 5,
                child: ClipOval(
                  child: Material(
                    color: Colors.grey, // button color
                    child: InkWell(
                      splashColor: Colors.black, // inkwell color
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: Icon(Icons.close),
                      ),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
