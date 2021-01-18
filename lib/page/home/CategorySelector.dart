import 'package:flutter/material.dart';
import 'package:personal_blog_mobile/model/PostProvider.dart';
import 'package:personal_blog_mobile/model/post_object.dart';
import 'package:provider/provider.dart';

class CategorySelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PostProvider postProvider = Provider.of(context);

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Card(
            elevation: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                title: Text("Category"),
              ),
            ),
          ),
          Card(
            elevation: 0,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: postProvider.categories.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return RadioListTile<PostCategory>(
                      onChanged: (v) {
                        postProvider.selectedCategory = v;
                      },
                      value: null,
                      groupValue: postProvider.selectedCategory,
                      title: Text("All"),
                    );
                  }

                  var category = postProvider.categories[index - 1];
                  return RadioListTile<PostCategory>(
                    onChanged: (v) {
                      postProvider.selectedCategory = v;
                    },
                    value: category,
                    groupValue: postProvider.selectedCategory,
                    title: Text("${category.category}"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
