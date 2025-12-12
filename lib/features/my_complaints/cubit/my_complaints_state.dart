import 'package:equatable/equatable.dart';
import 'package:internet_application_project/core/models/complaints_model.dart';
import '../../../core/models/enum/states_enum.dart';

class MyComplaintsState extends Equatable {
  final StateValue state;
  final List<Complaint> complaints;
  final String message;

  const MyComplaintsState({
    this.state = StateValue.init,
    this.complaints = const [],
    this.message = "",
  });

  MyComplaintsState copyWith({
    StateValue? state,
    List<Complaint>? complaints,
    String? message,
  }) {
    return MyComplaintsState(
      state: state ?? this.state,
      complaints: complaints ?? this.complaints,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, complaints, message];
}
