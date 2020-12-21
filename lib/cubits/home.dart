import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:for_post/import.dart';
import 'package:flutter/foundation.dart';

part 'home.g.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({@required this.dataRepository}) : super(const HomeState());

  final DatabaseRepository dataRepository;

  Future<void> init({bool isRefresh = false}) async {
    if (isRefresh) {
      emit(state.copyWith(status: HomeStatus.refresh));
    } else {
      emit(state.copyWith(status: HomeStatus.busy));
    }
    try {
      final articles = await dataRepository.readArticles();
      emit(state.copyWith(
        status: HomeStatus.ready,
        articles: articles,
      ));
    } catch (error) {
      out('HomeCubit: init(): $error');
      errorSnackbar(error);
      // return Future.error(error);
    }
  }

  void addArticle(ArticleModel newArticle) async {
    if (newArticle == null) {
      return;
    }
    // local changes (optimistic update)
    final List<ArticleModel> localArticles = [newArticle, ...state.articles];
    emit(state.copyWith(articles: localArticles));
    // database changes
    List<ArticleModel> dbArticles;
    try {
      dbArticles = await dataRepository.readArticles();
    } catch (error) {
      out('HomeCubit: addArticle(): $error');
      errorSnackbar(error);
    }
    emit(state.copyWith(articles: dbArticles));
  }
}

enum HomeStatus { initial, busy, refresh, ready }

@CopyWith()
class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.articles = const [],
  });

  final HomeStatus status;
  final List<ArticleModel> articles;

  @override
  List<Object> get props => [
        status,
        articles,
      ];
}
