import 'package:for_post/import.dart';
import 'package:graphql/client.dart';

import '../local.dart';

const _kTimeoutMillisec = 10000;

class DatabaseRepository {
  DatabaseRepository() {
    _client = _getClient();
  }

  GraphQLClient _client;

  GraphQLClient _getClient() {
    final httpLink = HttpLink(
      uri: kGraphQLEndpoint,
      headers: {
        'x-hasura-admin-secret': kSecret,
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
        out(error);
        return Future.error(error);
      }
    }
    return result;
  }
}

class _API {
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
      member_id
      title
      description
      banner_url
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
