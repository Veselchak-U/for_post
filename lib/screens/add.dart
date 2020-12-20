import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:for_post/import.dart';

class AddScreen extends StatelessWidget {
  Route<T> getRoute<T>() {
    return buildRoute<T>(
      '/add',
      builder: (_) => this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        final addCubit = AddCubit(
          dataRepository: RepositoryProvider.of<DatabaseRepository>(context),
        );
        return addCubit;
      },
      lazy: false,
      child: _AddView(),
    );
  }
}

class _AddView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<AddCubit, AddState>(
      builder: (BuildContext context, AddState addState) {
        return Stack(
          children: [
            Scaffold(
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 0.0,
                    expandedHeight: screenHeight / 4,
                    title: Text(
                      'Add article',
                      // style: TextStyle(color: theme.primaryColor),
                    ),
                    centerTitle: true,
                    flexibleSpace: (addState.newArticle.bannerUrl == null ||
                            addState.newArticle.bannerUrl.isEmpty)
                        ? Center(
                            child: _AddPhotoButton(),
                          )
                        : FadeInImage.assetNetwork(
                            image: addState.newArticle.bannerUrl,
                            fit: BoxFit.cover,
                            placeholder: '${kAssetPath}placeholder_img.png',
                            imageErrorBuilder: (context, object, stack) =>
                                Image.asset('${kAssetPath}placeholder_img.png'),
                          ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _AddForm(),
                    ),
                  ),
                ],
              ),
            ),
            if (addState.status == AddStatus.busy)
              Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        );
      },
    );
  }
}

class _AddPhotoButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddCubit addCubit = BlocProvider.of<AddCubit>(context);
    return ElevatedButton(
      onPressed: () {
        // // изменяем URL фото "извне" формы
        // addCubit.updateNewPet(addCubit.state.newArticle.copyWith(
        //     photos:
        //         'https://cdn.pixabay.com/photo/2014/11/30/14/11/cat-551554_960_720.jpg'));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add_a_photo),
            SizedBox(width: 16),
            Text('Add banner'),
          ],
        ),
      ),
    );
  }
}

class _AddForm extends StatefulWidget {
  @override
  _AddFormState createState() => _AddFormState();
}

class _AddFormState extends State<_AddForm> {
  final _formKey = GlobalKey<FormState>();
  AddCubit addCubit;

  @override
  void initState() {
    super.initState();
    addCubit = BlocProvider.of<AddCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    final ArticleModel newArticle = addCubit.state.newArticle;
    // при изменении URL фото "извне" обновляем содержимое соответствующего поля
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Banner url',
              helperText: '',
            ),
            // initialValue: 'Photo url',
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              // addCubit.updateNewPet(newArticle.copyWith(photos: value));
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              var result = 'Unknown error';
              if (value.isEmpty) {
                result = 'Input banner URL';
              } else if (Uri.parse(value).isAbsolute) {
                addCubit.updateArticle(newArticle.copyWith(bannerUrl: value));
                result = null;
              } else {
                result = 'Input correct url';
              }
              return result;
            },
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Title',
              helperText: '',
            ),
            initialValue: 'Title',
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (value) {
              addCubit.updateArticle(newArticle.copyWith(title: value));
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Input title' : null,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Description',
              helperText: '',
            ),
            initialValue: 'Description',
            minLines: 5,
            maxLines: 10,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.multiline,
            onFieldSubmitted: (value) {
              addCubit.updateArticle(newArticle.copyWith(description: value));
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Input description' : null,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState.validate()) {
                  out('Form OK');
                  final result = await addCubit.addArticle();
                  if (result) {
                    navigator.pop(addCubit.state.newArticle);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Add article'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
