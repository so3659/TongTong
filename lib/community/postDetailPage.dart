import 'package:flutter/material.dart';
import 'package:tongtong/theme/theme.dart';

class PostDetailPage extends StatefulWidget {
  const PostDetailPage({super.key});

  @override
  State<PostDetailPage> createState() => PostDetailPageState();
}

class PostDetailPageState extends State<PostDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(
                color: Colors.grey.shade200,
                height: 1.0,
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(),
                Container(
                  height: 6,
                  width: double.infinity,
                  color: TwitterColor.mystic,
                )
              ],
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              //!Removed container
              const Center()
            ]),
          )
        ],
      ),
    );
  }
}
