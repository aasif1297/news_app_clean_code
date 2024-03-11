import 'package:clean_code_practice/features/daily_news/domain/entities/article.dart';

import '../../../../core/resources/data_state.dart';

abstract class ArticleRepository {
  Future<DataState<List<ArticleEntity>>> getNewsArticles();
}
