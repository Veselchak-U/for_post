import 'package:flutter/material.dart';
import 'package:for_post/import.dart';

class DetailScreen extends StatefulWidget {
  DetailScreen({
    @required this.item,
  });

  final ArticleModel item;

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ArticleModel item;

  @override
  void initState() {
    super.initState();
    item = widget.item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View article'),
        centerTitle: true,
      ),
      body: _Body(item),
    );
  }
}

class _Body extends StatelessWidget {
  _Body(this.item);

  final ArticleModel item;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headline6,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'by ${item.member.displayName}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  Text(
                    ', ${dateTimeformatter.format(item.createdAt)}',
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                ],
              ),
              Text(
                item.description,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
