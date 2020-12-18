import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:for_post/import.dart';

part 'home.g.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({@required this.dataRepository}) : super(const HomeState());

  final DatabaseRepository dataRepository;

  Future<void> init() async {
    emit(state.copyWith(status: HomeStatus.busy));
    try {
      final articles = await dataRepository.readArticles();
      emit(state.copyWith(
        status: HomeStatus.ready,
        articles: articles,
      ));
    } catch (error) {
      out(error);
      return Future.error(error);
    }
  }
}

enum HomeStatus { initial, busy, ready }

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
