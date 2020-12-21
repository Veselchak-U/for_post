import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:for_post/import.dart';
import 'package:for_post/screens/detail.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/home',
      builder: (_) => this,
    );
  }

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
              // navigator.pushAndRemoveUntil(
              //   LoginScreen().getRoute(),
              //   (Route route) => false,
              // );
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
          // navigator.push(AddScreen().getRoute());
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
    return RefreshIndicator(
      onRefresh: () => homeCubit.init(isRefresh: true),
      child: ListView.builder(
        itemCount: articles.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: FaIcon(FontAwesomeIcons.bookmark),
            title: Text(
              articles[index].title,
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              'by ${articles[index].member.displayName}',
              style: Theme.of(context).textTheme.headline6,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () => Get.to(DetailScreen(item: articles[index])),
            // navigator.push(DetailScreen(item: articles[index]).getRoute()),
          );
        },
      ),
    );
  }
}
