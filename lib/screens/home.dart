import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:for_post/import.dart';
import 'package:for_post/screens/detail.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final homeCubit = HomeCubit(
          dataRepository: RepositoryProvider.of<DatabaseRepository>(context),
        );
        homeCubit.init();
        return homeCubit;
      },
      lazy: false,
      child: _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('For Post'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Logout',
            icon: Icon(Icons.logout),
            onPressed: () {
              Get.offAll(LoginScreen());
            },
          )
        ],
      ),
      body: BlocBuilder(
        cubit: homeCubit,
        builder: (BuildContext context, HomeState state) {
          return Stack(
            children: [
              _Body(),
              if (state.status == HomeStatus.busy)
                Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'New article',
        onPressed: () {
          final Future<ArticleModel> newArticle = Get.to(AddScreen());
          newArticle.then((value) => homeCubit.addArticle(value));
        },
        child: FaIcon(FontAwesomeIcons.fileAlt),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final homeCubit = BlocProvider.of<HomeCubit>(context);
    final articles = homeCubit.state.articles;
    final double screenWidth = MediaQuery.of(context).size.width;
    final double imageHeight = screenWidth / kGoldenRatio;
    return RefreshIndicator(
      onRefresh: () => homeCubit.init(isRefresh: true),
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return _PostCart(articles[index], imageHeight / 2);
        },
      ),
    );
  }
}

class _PostCart extends StatelessWidget {
  _PostCart(this.article, this.imageHeight);

  final ArticleModel article;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Get.to(DetailScreen(item: article)),
        child: Column(
          children: [
            SizedBox(
              height: imageHeight,
              width: double.infinity,
              child: FadeInImage.assetNetwork(
                image: article.bannerUrl,
                fit: BoxFit.fitWidth,
                placeholder: '${kAssetPath}placeholder_banner.jpg',
                imageErrorBuilder: (context, object, stack) => Image.asset(
                  '${kAssetPath}placeholder_banner.jpg',
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            ListTile(
              leading: FaIcon(FontAwesomeIcons.bookmark),
              title: Text(
                article.title,
                style: Theme.of(context).textTheme.headline6,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                'by ${article.member.displayName}',
                style: Theme.of(context).textTheme.subtitle1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
