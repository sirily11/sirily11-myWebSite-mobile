import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:personal_blog_mobile/model/post_object.dart';

class PostProvider with ChangeNotifier {
  bool isSearching = false;
  static String getURL(String path) {
    var base = "https://api.sirileepage.com/blog";

    return "$base$path";
  }

  PostCategory _selectedCategory;

  List<Post> posts = [];
  List<PostCategory> categories = [];
  String nextURL;
  Dio dio = Dio();

  Future<void> refresh() async {
    this.nextURL = null;
    isSearching = false;
    notifyListeners();
    await this.fetchPosts();
  }

  PostCategory get selectedCategory => _selectedCategory;

  set selectedCategory(PostCategory c) {
    _selectedCategory = c;
    notifyListeners();
  }

  Future<void> searchPosts(String keyword) async {
    isSearching = true;
    notifyListeners();
    var url = PostProvider.getURL("/post/?search=$keyword");
    var response = await dio.get(url);
    var data = (response.data['results'] as List)
        .map((e) => Post.fromJson(e))
        .toList();
    this.posts = data;
    notifyListeners();
  }

  Future<void> fetchPosts() async {
    String url;
    print("Fetching");
    if (_selectedCategory == null) {
      url = PostProvider.getURL("/post/");
    } else {
      url = PostProvider.getURL("/post?category=${_selectedCategory.id}");
    }
    var response = await dio.get(url);
    nextURL = response.data['next'];
    var data = (response.data['results'] as List)
        .map((e) => Post.fromJson(e))
        .toList();
    this.posts = data;
    notifyListeners();
  }

  Future<void> fetchCategories() async {
    var url = PostProvider.getURL("/category/");
    var response = await dio.get(url);
    var data = (response.data['results'] as List)
        .map((e) => PostCategory.fromJson(e))
        .toList();
    this.categories = data;
    notifyListeners();
  }

  Future<void> fetchMorePosts() async {
    assert(nextURL != null);
    var response = await dio.get(nextURL);
    nextURL = response.data['next'];
    var data = (response.data['results'] as List)
        .map((e) => Post.fromJson(e))
        .toList();
    this.posts = posts..addAll(data);
    notifyListeners();
  }
}
