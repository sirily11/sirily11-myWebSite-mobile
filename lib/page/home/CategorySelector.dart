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
                    return RadioListTile(
                      onChanged: (v) {
                        postProvider.selectedCategory = null;
                      },
                      value: null,
                      groupValue: postProvider.selectedCategory?.id,
                      title: Text("All"),
                    );
                  }

                  var category = postProvider.categories[index - 1];
                  return RadioListTile<int>(
                    onChanged: (v) {
                      var category = postProvider.categories
                          .firstWhere((element) => element.id == v);
                      postProvider.selectedCategory = category;
                    },
                    value: category.id,
                    groupValue: postProvider.selectedCategory?.id,
                    title: Text("${category.category}"),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
