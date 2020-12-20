import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_post/import.dart';

part 'add.g.dart';

class AddCubit extends Cubit<AddState> {
  AddCubit({this.dataRepository}) : super(const AddState());

  final DatabaseRepository dataRepository;

  void updateArticle(ArticleModel newArticle) {
    // out('newArticle.title=${newArticle.title}');
    emit(state.copyWith(newArticle: newArticle));
  }

  Future<bool> addArticle() async {
    bool result = false;
    emit(state.copyWith(status: AddStatus.busy));
    try {
      await dataRepository.createArticle(state.newArticle);
      result = true;
    } catch (e) {
      out(e);
    } finally {
      emit(state.copyWith(status: AddStatus.ready));
    }
    return result;
  }
}

enum AddStatus { initial, busy, ready }

@CopyWith()
class AddState extends Equatable {
  const AddState({
    this.status = AddStatus.initial,
    this.newArticle = const ArticleModel(
      member: MemberModel.test,
    ),
  });

  final AddStatus status;
  final ArticleModel newArticle;

  @override
  List<Object> get props => [
        status,
        newArticle,
      ];
}
