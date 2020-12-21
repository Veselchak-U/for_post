import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:for_post/import.dart';

part 'login.g.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({this.dataRepository}) : super(const LoginState());

  final DatabaseRepository dataRepository;

  void updateUser(MemberModel newUser) {
    emit(state.copyWith(user: newUser));
  }

  Future<bool> login() async {
    bool result = false;
    emit(state.copyWith(status: LoginStatus.busy));
    MemberModel loginResult;
    try {
      loginResult = await dataRepository.loginMember(state.user);
    } catch (error) {
      out('LoginCubit: login(): $error');
      errorSnackbar(error);
    }
    if (loginResult == null) {
      errorSnackbar('Failed to login with this credentials.');
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

  Future<bool> signup() async {
    bool result = false;
    emit(state.copyWith(status: LoginStatus.busy));
    MemberModel loginResult;
    try {
      loginResult = await dataRepository.upsertMember(state.user);
    } catch (error) {
      out('LoginCubit: signup(): $error');
      errorSnackbar(error);
    }
    if (loginResult == null) {
      errorSnackbar('Failed to register a new user.');
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

  String validateEmail(String value) {
    return (value == null || value.isEmpty || value.length < 5)
        ? 'Input correct e-mail'
        : null;
  }

  String validatePhone(String value) {
    return (value == null || value.isEmpty || value.length < 5)
        ? 'Input correct phone'
        : null;
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
