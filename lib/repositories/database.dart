import 'package:for_post/import.dart';
import 'package:graphql/client.dart';

import '../local.dart';

const _kTimeoutMillisec = 10000;

class DatabaseRepository {
  DatabaseRepository() {
    _client = _getClient();
  }

  MemberModel _currentUser = MemberModel.empty;
  MemberModel get currentUser => _currentUser;
  GraphQLClient _client;

  GraphQLClient _getClient() {
    final httpLink = HttpLink(
      uri: kGraphQLEndpoint,
      headers: {
        // TODO: remove secret and add user role
        'x-hasura-admin-secret': kSecret,
        // 'x-hasura-role': 'user',
      },
    );
    // final authLink = AuthLink(
    //   getToken: () async {
    //     final idToken = await authRepository.getIdToken(forceRefresh: true);
    //     // out('!!! authRepository.getIdToken !!!');
    //     return 'Bearer $idToken';
    //   },
    // );
    // final link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: InMemoryCache(),
      link: httpLink,
    );
  }

  Future<List<ArticleModel>> readArticles() async {
    final List<ArticleModel> result = [];

    final options = QueryOptions(
      documentNode: _API.readLastArticles,
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['article'] as List).cast<Map<String, dynamic>>();
    for (final item in dataItems) {
      try {
        result.add(ArticleModel.fromJson(item));
      } catch (error) {
        rethrow;
        // out(error);
        // return Future.error(error);
      }
    }
    return result;
  }

  Future<ArticleModel> createArticle(ArticleModel newArticle) async {
    out('newArticle.member.id=${newArticle.member.id}');
    out('newArticle.title=${newArticle.title}');
    out('newArticle.description=${newArticle.description}');
    out('newArticle.bannerUrl=${newArticle.bannerUrl}');
    final options = MutationOptions(
      documentNode: _API.createArticle,
      variables: {
        // TODO: handle member_id
        'member_id': newArticle.member.id,
        'title': newArticle.title,
        'description': newArticle.description,
        'banner_url': newArticle.bannerUrl,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult = await _client
        .mutate(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (mutationResult.hasException) {
      throw mutationResult.exception;
    }
    // out(mutationResult.data);
    final dataItem =
        mutationResult.data['insert_article_one'] as Map<String, dynamic>;
    try {
      return ArticleModel.fromJson(dataItem);
    } catch (error) {
      rethrow;
      // out(error);
      // return Future.error(error);
    }
  }

  Future<MemberModel> loginMember(MemberModel user) async {
    MemberModel result;

    final options = QueryOptions(
      documentNode: _API.findMember,
      variables: {
        'email': user.email,
        'phone': user.phone,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final queryResult = await _client
        .query(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (queryResult.hasException) {
      throw queryResult.exception;
    }
    // out(queryResult.data);
    final dataItems =
        (queryResult.data['member'] as List).cast<Map<String, dynamic>>();
    // TODO: remake to Future.error
    if (dataItems.isEmpty) {
      return result;
    }
    // TODO: remake to Future.error
    if (dataItems.length > 1) {
      return result;
    }
    try {
      result = MemberModel.fromJson(dataItems[0]);
      _currentUser = result;
    } catch (error) {
      rethrow;
      // out(error);
      // return Future.error(error);
    }
    // out('result.displayName=${result.displayName}');
    return result;
  }

  Future<MemberModel> upsertMember(MemberModel user) async {
    MemberModel result;

    final options = MutationOptions(
      documentNode: _API.upsertMember,
      variables: {
        'display_name': user.displayName,
        'photo_url': user.photoUrl,
        'email': user.email,
        'phone': user.phone,
      },
      fetchPolicy: FetchPolicy.noCache,
      errorPolicy: ErrorPolicy.all,
    );
    final mutationResult = await _client
        .mutate(options)
        .timeout(Duration(milliseconds: _kTimeoutMillisec));
    if (mutationResult.hasException) {
      throw mutationResult.exception;
    }
    // out(mutationResult.data);
    final dataItem =
        mutationResult.data['insert_member_one'] as Map<String, dynamic>;
    try {
      result = MemberModel.fromJson(dataItem);
      _currentUser = result;
    } catch (error) {
      rethrow;
      // out(error);
      // return Future.error(error);
    }
    return result;
  }
}

class _API {
  static final upsertMember = gql(r'''
    mutation UpsertMember(
      $display_name: String,
      $photo_url: String,
      $email: String!,
      $phone: String!,
    ) {
      insert_member_one(object: {
        display_name: $display_name,
        photo_url: $photo_url,
        email: $email,
        phone: $phone
      },
      on_conflict: {
        constraint: member_email_phone_key,
        update_columns: [display_name, photo_url]
      }) {
        ...MemberFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final findMember = gql(r'''
    query FindMember(
      $email: String!,
      $phone: String!,
    ) {
      member(where: {
          email: {_eq: $email},
          _and: {phone: {_eq: $phone}}
        }
      ) {
        ...MemberFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final createArticle = gql(r'''
    mutation CreateArticle(
      $member_id: uuid!,
      $title: String!,
      $description: String!,
      $banner_url: String!,
    ) {
      insert_article_one(object: {
        member_id: $member_id,
        title: $title,
        description: $description,
        banner_url: $banner_url,
        }) {
        ...ArticleFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final readLastArticles = gql(r'''
    query ReadLastArticles {
      article(order_by: {updated_at: desc}, limit: 10) {
        ...ArticleFields
      }
    }
  ''')..definitions.addAll(fragments.definitions);

  static final fragments = gql(r'''
    fragment ArticleFields on article {
      id
      created_at
      updated_at
      # member_id
      title
      description
      banner_url
      member {
        id
        display_name
        photo_url
        email
        phone
      }
    }
    fragment MemberFields on member {
      id
      created_at
      updated_at
      display_name
      photo_url
      email
      phone
    }
  ''');
}
