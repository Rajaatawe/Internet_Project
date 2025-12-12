import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_application_project/core/models/GovernmentAgency.dart';
import 'package:internet_application_project/core/network/error_handling/error_code.dart';
import 'package:internet_application_project/core/models/Service.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/network/error_handling/remote_exceptions.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'home_page_state.dart';

class HomePageCubit extends Cubit<HomePageState> {
  final RemoteService _remoteService;

  HomePageCubit({required RemoteService remoteService})
      : _remoteService = remoteService,
        super(const HomePageState());

  Future<void> loadHomePage() async {
    emit(state.copyWith(state: StateValue.loading, message: ""));

    try {
      final governmentAgencies =
          await _remoteService.performGetListRequest<GovernmentAgencyclass>(
        "agencies",
        (json) => GovernmentAgencyclass.fromJson(json),
        useToken: true,
        isResponseEncrypted: false,
      );

      emit(
        state.copyWith(
          state: StateValue.loaded,
          governmentAgencies: governmentAgencies,
        ),
      );
    } on RemoteExceptions catch (e) {
      emit(
        state.copyWith(
          state: StateValue.error,
          message: e.errorCode.getLocalizedMessage(),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          state: StateValue.error,
          message: e.toString(),
        ),
      );
    }
  }
}