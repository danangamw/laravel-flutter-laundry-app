import 'package:dartz/dartz.dart';
import 'package:dilaundry/config/app_response.dart';
import 'package:dilaundry/config/config.dart';
import 'package:http/http.dart' as http;

class ShopDatasource {
  static Future<Either<Failure, Map>> readRecommendationLimit() async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/shop/recommendation/limit');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }

  static Future<Either<Failure, Map>> searchByCity(String name) async {
    Uri url = Uri.parse('${AppConstants.baseUrl}/shop/search/city/$name');
    final token = await AppSession.getBearerToken();

    try {
      final response = await http.get(
        url,
        headers: AppRequest.header(token),
      );
      final data = AppResponse.data(response);
      return Right(data);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(FetchFailure(e.toString()));
    }
  }
}
