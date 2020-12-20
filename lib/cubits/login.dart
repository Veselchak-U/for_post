import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:for_post/import.dart';

part 'login.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({this.dataRepository}) : super(const LoginState());

  final DatabaseRepository dataRepository;

  void updateUser(MemberModel newUser) {
    out('updateUser: newUser.email=${newUser.email}');
    emit(state.copyWith(user: newUser));
    out('updateUser: state.user.email=${state.user.email}');
  }

  Future<bool> signup() async {
    bool result = false;
    out('state.user.email=${state.user.email}');
    emit(state.copyWith(status: LoginStatus.busy));
    final MemberModel loginResult = await dataRepository.upsertMember(state.user);
    out('loginResult.email=${loginResult.email}');

    if (loginResult == null) {
      emit(state.copyWith(
        status: LoginStatus.unauthenticated,
      ));
    } else {
      emit(state.copyWith(
        status: LoginStatus.authenticated,
        user: loginResult,
      ));
      result = true;
    }
    return result;
  }

  Future<bool> login() async {
    bool result = false;
    emit(state.copyWith(status: LoginStatus.busy));
    final MemberModel loginResult = await dataRepository.loginMember(state.user);
    if (loginResult == null) {
      emit(state.copyWith(
        status: LoginStatus.unauthenticated,
      ));
    } else {
      emit(state.copyWith(
        status: LoginStatus.authenticated,
        user: loginResult,
      ));
      result = true;
    }
    return result;
  }

  void logout() {
    emit(const LoginState());
  }
}

enum LoginStatus { authenticated, unauthenticated, busy }

@CopyWith()
class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.unauthenticated,
    this.user = MemberModel.empty,
  });

  final LoginStatus status;
  final MemberModel user;

  @override
  List<Object> get props => [
        status,
        user,
      ];
}
