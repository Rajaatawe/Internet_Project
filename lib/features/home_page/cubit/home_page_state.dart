import 'package:equatable/equatable.dart';
import 'package:internet_application_project/core/models/GovernmentAgency.dart';
import '../../../core/models/enum/states_enum.dart';
import '../../../core/models/Service.dart';

class HomePageState extends Equatable {
  final StateValue state;
  final List<GovernmentAgencyclass> governmentAgencies;
  final String message;

  const HomePageState({
    this.state = StateValue.init,
    this.governmentAgencies = const [],
    this.message = "",
  });

  HomePageState copyWith({
    StateValue? state,
    List<GovernmentAgencyclass>? governmentAgencies,
    String? message,
  }) {
    return HomePageState(
      state: state ?? this.state,
      governmentAgencies: governmentAgencies ?? this.governmentAgencies,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [state, governmentAgencies, message];
}
