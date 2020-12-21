import 'package:flutter/material.dart';
import 'package:for_post/import.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen({
    @required this.article,
  });

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _SliverAppBar(article),
          _SliverToBoxAdapter(article),
        ],
      ),
    );
  }
}

class _SliverAppBar extends StatelessWidget {
  const _SliverAppBar(this.article);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenWidth / kGoldenRatio;
    // TODO: research this
    final double systemTabBarHeight = 24;

    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      expandedHeight: imageHeight - systemTabBarHeight,
      flexibleSpace: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: Hero(
          tag: article.id,
          child: FadeInImage.assetNetwork(
            image: article.bannerUrl,
            fit: BoxFit.cover,
            placeholder: '${kAssetPath}placeholder_banner.jpg',
            imageErrorBuilder: (context, object, stack) => Image.asset(
              '${kAssetPath}placeholder_banner.jpg',
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class _SliverToBoxAdapter extends StatelessWidget {
  const _SliverToBoxAdapter(this.article);

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Text(
                  article.title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'by ${article.member.displayName}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    Text(
                      ', ${dateTimeformatter.format(article.createdAt)}',
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  article.description,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
