// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:flutter/material.dart';
// import 'package:internet_application_project/core/models/complaints_model.dart';
// import 'package:internet_application_project/core/models/enum/states_enum.dart';
// import 'package:internet_application_project/core/network/error_handling/error_code.dart';
// import 'package:internet_application_project/core/network/error_handling/remote_exceptions.dart';
// import 'package:internet_application_project/core/services/generalized_api.dart';
// import 'package:internet_application_project/features/Form/cubit/form_complaint_state.dart';
// import 'package:internet_application_project/features/my_complaints/cubit/my_complaints_state.dart';


// class FormCubit extends Cubit<FormComplaintState> {
//    final RemoteService _remoteService;

//   FormCubit({required RemoteService remoteService})
//       : _remoteService = remoteService,
//         super(const FormComplaintState());

//   Future<void> submitComplaint({
//     required String title,
//     required String description,
//     required String type,
//     required double latitude,
//     required double longitude,
//     required List email,
//     required String password,
//      required String passwordConfirmation,

//   }) async {
//     emit(state.copyWith(formState: StateValue.loading));
//     try {
//       Map<String,dynamic> data = {
//         'first_name':firstName,
//          'middle_name':middleName,
//           'last_name':lastName,
//            'phone':phone,
//             'identity_number':nationalNumber,
//              'password':password,
//               'password_confirmation':passwordConfirmation,
//               'email': email,
//       };
//       await _remoteService.performPostRequestWithFormData('create-complaint',data , UserClass.fromJson);
//       emit(state.copyWith(
//         formState: StateValue.success,
//         formMessage: "Complaint submitted success",
//       ));
//     } catch (e) {
//       emit(state.copyWith(
//         formState: StateValue.error,
//         formMessage: e.toString(),
//       ));
//     }
//   }


//   Future<void> fetchComplaintsTypes() async {
//     emit(state.copyWith(typesState: StateValue.loading, typesMessage: ""));

//     try {
//       final complaintTypes = await _remoteService.performGetListRequest<ComplaintType>(
//         "agencies",
//         (json) => ComplaintType.fromJson(json),
//         useToken: true,
//         isResponseEncrypted: false,
//       );

//       emit(
//         state.copyWith(
//           typesState: StateValue.loaded,
//           typesMessage: "Types fetched successfuly",
//         ),
//       );
//     } on RemoteExceptions catch (e) {
//       emit(
//         state.copyWith(
//           typesState: StateValue.error,
//           typesMessage: e.errorCode.getLocalizedMessage(),
//         ),
//       );
//     } catch (e) {
//       emit(
//         state.copyWith(
//           typesState: StateValue.error,
//           typesMessage: e.toString(),
//         ),
//       );
//     }
//   }

// }
