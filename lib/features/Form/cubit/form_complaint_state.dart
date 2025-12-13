import 'package:equatable/equatable.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import '../../../core/models/enum/states_enum.dart';

class FormComplaintState extends Equatable {
  final StateValue formState;
  final String formMessage; // Fixed variable name to follow Dart naming conventions
  final StateValue typesState;
  final String typesMessage;

  const FormComplaintState({
     this.formState = StateValue.init,
     this.formMessage ="",
     this.typesState=StateValue.init,
     this.typesMessage ="",
  });

  FormComplaintState copyWith({
    StateValue? formState,
    String? formMessage,
    StateValue? typesState,
    String? typesMessage,
  }) {
    return FormComplaintState(
      formState: formState ?? this.formState,
      formMessage: formMessage ?? this.formMessage,
      typesState: typesState ?? this.typesState,
      typesMessage: typesMessage ?? this.typesMessage,
    );
  }

  @override
  List<Object?> get props => [formState, formMessage, typesState, typesMessage];
}
