import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:internet_application_project/core/models/complaints_types.dart';
import 'package:internet_application_project/core/models/enum/states_enum.dart';
import 'package:internet_application_project/core/network/error_handling/error_code.dart';
import 'package:internet_application_project/core/network/error_handling/remote_exceptions.dart';
import 'package:internet_application_project/core/services/generalized_api.dart';
import 'package:internet_application_project/features/Form/cubit/form_complaint_state.dart';


class FormComplaintCubit extends Cubit<FormComplaintState> {
   final RemoteService _remoteService;

  FormComplaintCubit({required RemoteService remoteService})
      : _remoteService = remoteService,
        super(const FormComplaintState());

 Future<void> submitComplaint({
    required String title,
    required String description,
    String? customComplaintType,
    int? complaintTypeId,
    required int agencyId,
    required double latitude,
    required double longitude,
    required List<PlatformFile> documents,
  }) async {
    emit(state.copyWith(formState: StateValue.loading));

    try {
      final Map<String, dynamic> data = {
        'title': title,
        'description': description,
        'government_agency_id': agencyId.toString(),
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      };

      if (customComplaintType != null && customComplaintType.isNotEmpty) {
        data['custom_complaint_type'] = customComplaintType;
      }

      if (complaintTypeId != null) {
        data['complaint_type_id'] = complaintTypeId.toString();
      }

      // Convert PlatformFile to MultipartFile and attach media[]
      for (int i = 0; i < documents.length; i++) {
        final file = documents[i];
        
        // Create MultipartFile from PlatformFile
        MultipartFile multipartFile;
        
        if (file.bytes != null) {
          // If bytes are available (mobile/web)
          multipartFile = MultipartFile.fromBytes(
            file.bytes!,
            filename: file.name,
          );
        } else if (file.path != null) {
          // If path is available (mobile)
          multipartFile = await MultipartFile.fromFile(
            file.path!,
            filename: file.name,
          );
        } else {
          throw Exception('File data not available for ${file.name}');
        }
        
        data['media[$i]'] = multipartFile;
      }

      await _remoteService.performPostRequestWithFormData(
        'create-complaint',
        data,
        (_) => null,
        useToken: true,
      );

      emit(
        state.copyWith(
          formState: StateValue.success,
          formMessage: "Complaint submitted successfully",
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          formState: StateValue.error,
          formMessage: e.toString(),
        ),
      );
    }
  }
Future<void> fetchComplaintsTypes(int agencyId) async {
  emit(state.copyWith(typesState: StateValue.loading, typesMessage: ""));

  try {
    final List<ComplaintType> complaintTypes =
        await _remoteService.performGetListRequest<ComplaintType>(
      "agencies/$agencyId/complaint-types",
      (json) => ComplaintType.fromJson(json),
      useToken: true,
      isResponseEncrypted: false,
    );

    emit(
      state.copyWith(
        typesState: StateValue.loaded,
        complaintTypes: complaintTypes, // Now this works
        typesMessage: "Types fetched successfully",
      ),
    );
  } on RemoteExceptions catch (e) {
    emit(
      state.copyWith(
        typesState: StateValue.error,
        typesMessage: e.errorCode.getLocalizedMessage(),
      ),
    );
  } catch (e) {
    emit(
      state.copyWith(
        typesState: StateValue.error,
        typesMessage: e.toString(),
      ),
    );
  }
}
}
