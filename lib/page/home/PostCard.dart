import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:personal_blog_mobile/model/post_object.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:personal_blog_mobile/page/detail/PostDetail.dart';

extension on DateTime {
  static String _fourDigits(int n) {
    int absN = n.abs();
    String sign = n < 0 ? "-" : "";
    if (absN >= 1000) return "$n";
    if (absN >= 100) return "${sign}0$absN";
    if (absN >= 10) return "${sign}00$absN";
    return "${sign}000$absN";
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  String toYearString() {
    String y = _fourDigits(year);
    String m = _twoDigits(month);
    String d = _twoDigits(day);

    return "$y-$m-$d ";
  }
}

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({Key key, @required this.post}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool tapped = false;

  Color get coverColor {
    if (widget.post.coverColor.length == 0) {
      return Theme.of(context).cardColor;
    }

    var c = widget.post.coverColor.first;

    return Color.fromARGB(255, c.red, c.green, c.blue);
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

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      padding: tapped
          ? EdgeInsets.symmetric(horizontal: 10, vertical: 5)
          : EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: GestureDetector(
        onTapDown: (details) {
          setState(() {
            tapped = true;
          });
        },
        onTapUp: (details) async {
          await CupertinoScaffold.showCupertinoModalBottomSheet(
            expand: true,
            context: context,
            builder: (c) => PostDetail(
              post: widget.post,
            ),
          );
          setState(() {
            tapped = false;
          });
        },
        onTapCancel: () {
          setState(() {
            tapped = false;
          });
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
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
              Positioned(
                bottom: 0,
                height: 60,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  color: coverColor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 14,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${widget.post.author.username}",
                                style: textStyle.copyWith(
                                  shadows: [],
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              Text(
                                "${widget.post.postedTime.toYearString()}",
                                style: textStyle.copyWith(
                                  shadows: [],
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
