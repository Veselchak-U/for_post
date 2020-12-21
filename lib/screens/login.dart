import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_post/import.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
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

  @override
  void initState() {
    super.initState();
    loginCubit = BlocProvider.of<LoginCubit>(context);
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
                  final newUser = loginCubit.state.user.copyWith(email: value);
                  loginCubit.updateUser(newUser);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => loginCubit.validateEmail(value),
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
                  final newUser = loginCubit.state.user.copyWith(phone: value);
                  loginCubit.updateUser(newUser);
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => loginCubit.validatePhone(value),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        final result = await loginCubit.login();
                        if (result) {
                          // ignore: unawaited_futures
                          Get.offAll(HomeScreen());
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
                        final result = await loginCubit.signup();
                        if (result) {
                          // ignore: unawaited_futures
                          Get.offAll(HomeScreen());
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
