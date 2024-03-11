import 'dart:io';

import 'package:clean_code_practice/core/resources/data_state.dart';
import 'package:clean_code_practice/features/daily_news/data/data_sources/news_api_service.dart';
import 'package:clean_code_practice/features/daily_news/data/models/article.dart';
import 'package:clean_code_practice/features/daily_news/domain/repository/article_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/constants/constants.dart';

class ArticleRepositoryImpl extends ArticleRepository {
  final NewsApiService _newsApiService;
  ArticleRepositoryImpl(this._newsApiService);
  @override
  Future<DataState<List<ArticleModel>>> getNewsArticles() async {
    try {
      final httpResponse = await _newsApiService.getNewsArticles(
        apiKey: dotenv.env['newsApiKey'],
        country: countryQuery,
        category: categoryQuery,
      );

      if (httpResponse.response.statusCode == HttpStatus.ok) {
        return DataSuccess(httpResponse.data);
      } else {
        return DataFailure(
          DioException(
            requestOptions: httpResponse.response.requestOptions,
            response: httpResponse.response,
            error: httpResponse.response.statusMessage,
            type: DioExceptionType.badResponse,
          ),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        return DataFailure(
          DioException(
            requestOptions: e.requestOptions,
            type: DioExceptionType.connectionTimeout,
            error: e.error,
          ),
        );
      } else if (e.type == DioExceptionType.sendTimeout) {
        return DataFailure(
          DioException(
            requestOptions: e.requestOptions,
            type: DioExceptionType.sendTimeout,
          ),
        );
      } else if (e.type == DioExceptionType.receiveTimeout) {
        return DataFailure(
          DioException(
            requestOptions: e.requestOptions,
            type: DioExceptionType.receiveTimeout,
            error: e.error,
          ),
        );
      } else {
        return DataFailure(e);
      }
    }
  }
}
