import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_post/import.dart';
import 'package:get/get.dart';

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
        // final user = MemberModel(
        //   email: 'JohnDoe@live.net',
        //   phone: '44444',
        // );
        // loginCubit.updateUser(user);
        // loginCubit.login();
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

class _LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<_LoginBody> {
  final _formKey = GlobalKey<FormState>();
  LoginCubit loginCubit;
  // MemberModel loginUser;

  @override
  void initState() {
    super.initState();
    loginCubit = BlocProvider.of<LoginCubit>(context);
    // loginUser = loginCubit.state.user;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'For Post',
                style: Theme.of(context).textTheme.headline4,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'E-mail',
                  helperText: '',
                ),
                initialValue: loginCubit.state.user.email,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                onSaved: (value) {
                  out('onSaved E-mail=$value');
                  loginCubit.updateUser(loginCubit.state.user.copyWith(email: value));
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    (value == null || value.isEmpty || value.length < 7)
                        ? 'Input correct e-mail'
                        : null,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Phone',
                  helperText: '',
                ),
                initialValue: loginCubit.state.user.phone,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.phone,
                onSaved: (value) {
                  out('onSaved Phone=$value');
                  loginCubit.updateUser(loginCubit.state.user.copyWith(phone: value));
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                    (value == null || value.isEmpty || value.length < 5)
                        ? 'Input correct phone'
                        : null,
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        out('Form OK');
                        final result = await loginCubit.login();
                        if (result) {
                          Get.offAll(HomeScreen());
                          // navigator.pushAndRemoveUntil(
                          //   HomeScreen().getRoute(),
                          //   (Route route) => false,
                          // );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Login'),
                    ),
                  ),
                  const SizedBox(width: 40),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        out('Form OK');
                        final result = await loginCubit.signup();
                        if (result) {
                          Get.offAll(HomeScreen());
                          // navigator.pushAndRemoveUntil(
                          //   HomeScreen().getRoute(),
                          //   (Route route) => false,
                          // );
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text('Signup'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
