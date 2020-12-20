import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:for_post/import.dart';

part 'login.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({this.dataRepository}) : super(const LoginState());

  final DatabaseRepository dataRepository;

  void updateUser(MemberModel newUser) {
    out('newUser.email=${newUser.email}');
    out('newUser.phone=${newUser.phone}');
    emit(state.copyWith(user: newUser));
  }

  void signup() {}

  void login() async {
    emit(state.copyWith(status: LoginStatus.busy));
    final MemberModel loginResult = await dataRepository.login(state.user);
    if (loginResult == null) {
      emit(state.copyWith(
        status: LoginStatus.unauthenticated,
      ));
    } else {
      emit(state.copyWith(
        status: LoginStatus.authenticated,
        user: loginResult,
      ));
    }
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
