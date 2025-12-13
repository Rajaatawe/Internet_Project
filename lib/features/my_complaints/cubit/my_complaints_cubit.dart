import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/network/error_handling/error_code.dart';
import 'package:internet_application_project/core/network/error_handling/remote_exceptions.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/features/my_complaints/cubit/my_complaints_state.dart';


class MyComplaintsCubit extends Cubit<MyComplaintsState> {
   final RemoteService _remoteService;

  MyComplaintsCubit({required RemoteService remoteService})
      : _remoteService = remoteService,
        super(const MyComplaintsState());

  Future<void> loadComplaints() async {
    emit(state.copyWith(state: StateValue.loading, message: ""));

    try {
      final complaints =
          await _remoteService.performGetListRequest<Complaint>(
        "my-complaints",
        (json) => Complaint.fromJson(json),
        useToken: true,
        isResponseEncrypted: false,
      );

      emit(
        state.copyWith(
          state: StateValue.loaded,
          complaints: complaints,
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
