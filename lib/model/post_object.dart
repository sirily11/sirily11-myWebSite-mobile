// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  Post({
    this.id,
    this.title,
    this.postCategory,
    this.postLanguage,
    this.content,
    this.rightSidebar,
    this.author,
    this.postedTime,
    this.category,
    this.imageUrl,
    this.coverColor,
    this.settings,
  });

  int id;
  String title;
  PostCategory postCategory;
  PostLanguage postLanguage;
  String content;
  dynamic rightSidebar;
  Author author;
  DateTime postedTime;
  int category;
  String imageUrl;
  List<CoverColor> coverColor;
  String settings;

  Post copyWith({
    int id,
    String title,
    PostCategory postCategory,
    PostLanguage postLanguage,
    String content,
    dynamic rightSidebar,
    Author author,
    DateTime postedTime,
    int category,
    String imageUrl,
    List<CoverColor> coverColor,
    String settings,
  }) =>
      Post(
        id: id ?? this.id,
        title: title ?? this.title,
        postCategory: postCategory ?? this.postCategory,
        postLanguage: postLanguage ?? this.postLanguage,
        content: content ?? this.content,
        rightSidebar: rightSidebar ?? this.rightSidebar,
        author: author ?? this.author,
        postedTime: postedTime ?? this.postedTime,
        category: category ?? this.category,
        imageUrl: imageUrl ?? this.imageUrl,
        coverColor: coverColor ?? this.coverColor,
        settings: settings ?? this.settings,
      );

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["id"] == null ? null : json["id"],
        title: json["title"] == null ? null : json["title"],
        postCategory: json["post_category"] == null
            ? null
            : PostCategory.fromJson(json["post_category"]),
        postLanguage: json["post_language"] == null
            ? null
            : PostLanguage.fromJson(json["post_language"]),
        content: json["content"] == null ? null : json["content"],
        rightSidebar: json["right_sidebar"],
        author: json["author"] == null ? null : Author.fromJson(json["author"]),
        postedTime: json["posted_time"] == null
            ? null
            : DateTime.parse(json["posted_time"]),
        category: json["category"] == null ? null : json["category"],
        imageUrl: json["image_url"] == null ? null : json["image_url"],
        coverColor: json["cover_color"] == null
            ? null
            : List<CoverColor>.from(
                json["cover_color"].map((x) => CoverColor.fromJson(x))),
        settings: json["settings"] == null ? null : json["settings"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "title": title == null ? null : title,
        "post_category": postCategory == null ? null : postCategory.toJson(),
        "post_language": postLanguage == null ? null : postLanguage.toJson(),
        "content": content == null ? null : content,
        "right_sidebar": rightSidebar,
        "author": author == null ? null : author.toJson(),
        "posted_time": postedTime == null ? null : postedTime.toIso8601String(),
        "category": category == null ? null : category,
        "image_url": imageUrl == null ? null : imageUrl,
        "cover_color": coverColor == null
            ? null
            : List<dynamic>.from(coverColor.map((x) => x.toJson())),
        "settings": settings == null ? null : settings,
      };
}

class Author {
  Author({
    this.url,
    this.username,
    this.email,
  });

  String url;
  String username;
  String email;

  Author copyWith({
    String url,
    String username,
    String email,
  }) =>
      Author(
        url: url ?? this.url,
        username: username ?? this.username,
        email: email ?? this.email,
      );

  factory Author.fromJson(Map<String, dynamic> json) => Author(
        url: json["url"] == null ? null : json["url"],
        username: json["username"] == null ? null : json["username"],
        email: json["email"] == null ? null : json["email"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "username": username == null ? null : username,
        "email": email == null ? null : email,
      };
}

class CoverColor {
  CoverColor({
    this.post,
    this.red,
    this.green,
    this.blue,
  });

  int post;
  int red;
  int green;
  int blue;

  CoverColor copyWith({
    int post,
    int red,
    int green,
    int blue,
  }) =>
      CoverColor(
        post: post ?? this.post,
        red: red ?? this.red,
        green: green ?? this.green,
        blue: blue ?? this.blue,
      );

  factory CoverColor.fromJson(Map<String, dynamic> json) => CoverColor(
        post: json["post"] == null ? null : json["post"],
        red: json["red"] == null ? null : json["red"],
        green: json["green"] == null ? null : json["green"],
        blue: json["blue"] == null ? null : json["blue"],
      );

  Map<String, dynamic> toJson() => {
        "post": post == null ? null : post,
        "red": red == null ? null : red,
        "green": green == null ? null : green,
        "blue": blue == null ? null : blue,
      };
}

class PostCategory {
  PostCategory({
    this.id,
    this.category,
  });

  int id;
  String category;

  PostCategory copyWith({
    int id,
    String category,
  }) =>
      PostCategory(
        id: id ?? this.id,
        category: category ?? this.category,
      );

  factory PostCategory.fromJson(Map<String, dynamic> json) => PostCategory(
        id: json["id"] == null ? null : json["id"],
        category: json["category"] == null ? null : json["category"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category": category == null ? null : category,
      };
}

class PostLanguage {
  PostLanguage({
    this.id,
    this.language,
  });

  int id;
  String language;

  PostLanguage copyWith({
    int id,
    String language,
  }) =>
      PostLanguage(
        id: id ?? this.id,
        language: language ?? this.language,
      );

  factory PostLanguage.fromJson(Map<String, dynamic> json) => PostLanguage(
        id: json["id"] == null ? null : json["id"],
        language: json["language"] == null ? null : json["language"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "language": language == null ? null : language,
      };
}
