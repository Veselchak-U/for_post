import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_post/import.dart';

class LoginScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/login',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final loginCubit = LoginCubit(
          dataRepository: RepositoryProvider.of<DatabaseRepository>(context),
        );
        return loginCubit;
      },
      lazy: false,
      child: _LoginView(),
    );
  }
}

class _LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder(
      cubit: BlocProvider.of<LoginCubit>(context),
      builder: (BuildContext context, LoginState loginState) {
        return Stack(
          children: [
            Scaffold(
              body: _LoginBody(),
            ),
            if (loginState.status == LoginStatus.busy)
              Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        );
      },
    );
  }
}

class _LoginBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [],
      ),
    );
  }
}
