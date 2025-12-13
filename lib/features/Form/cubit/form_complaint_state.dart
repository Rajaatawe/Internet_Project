import 'package:equatable/equatable.dart';
import 'package:internet_application_project/core/models/complaints_types.dart';
import '../../../core/models/enum/states_enum.dart';

class FormComplaintState extends Equatable {
  final StateValue formState;
  final String formMessage;

  final StateValue typesState;
  final String typesMessage;

  final List<ComplaintType> complaintTypes;

  const FormComplaintState({
    this.formState = StateValue.init,
    this.formMessage = '',
    this.typesState = StateValue.init,
    this.typesMessage = '',
    this.complaintTypes = const [],
  });

  FormComplaintState copyWith({
    StateValue? formState,
    String? formMessage,
    StateValue? typesState,
    String? typesMessage,
    List<ComplaintType>? complaintTypes,
  }) {
    return FormComplaintState(
      formState: formState ?? this.formState,
      formMessage: formMessage ?? this.formMessage,
      typesState: typesState ?? this.typesState,
      typesMessage: typesMessage ?? this.typesMessage,
      complaintTypes: complaintTypes ?? this.complaintTypes,
    );
  }

  @override
  List<Object?> get props => [
        formState,
        formMessage,
        typesState,
        typesMessage,
        complaintTypes,
      ];
}
