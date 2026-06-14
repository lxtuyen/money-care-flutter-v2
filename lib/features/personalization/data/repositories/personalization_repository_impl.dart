import 'package:money_care/core/constants/api_routes.dart';
import 'package:money_care/core/network/api_client.dart';
import 'package:money_care/features/personalization/data/models/personal_finance_profile_model.dart';
import 'package:money_care/features/personalization/domain/repositories/personalization_repository.dart';

class PersonalizationRepositoryImpl implements PersonalizationRepository {
  final ApiClient api;

  const PersonalizationRepositoryImpl({required this.api});

  @override
  Future<PersonalFinanceProfileModel> getProfile() async {
    final res = await api.get<PersonalFinanceProfileModel>(
      ApiRoutes.personalizationProfile,
      fromJsonT: (json) => PersonalFinanceProfileModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<PersonalFinanceProfileModel> rebuildProfile() async {
    final res = await api.post<PersonalFinanceProfileModel>(
      ApiRoutes.personalizationProfileRebuild,
      body: {},
      fromJsonT: (json) => PersonalFinanceProfileModel.fromJson(json as Map<String, dynamic>),
    );
    return res.unwrap();
  }

  @override
  Future<void> retrainForecastingModel() async {
    final res = await api.post<void>(
      ApiRoutes.trainForecastingModel,
      body: {},
      fromJsonT: (_) {},
    );
    res.unwrap();
  }
}
