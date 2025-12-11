import 'package:equatable/equatable.dart';
import '../../../core/models/enum/states_enum.dart';
import '../../../core/models/Service.dart';

class HomePageState extends Equatable {
  final StateValue state;
  final List<Service> governmentAgencies;
  final String message;

  const HomePageState({
    this.state = StateValue.init,
    this.governmentAgencies = const [],
    this.message = "",
  });

  HomePageState copyWith({
    StateValue? state,
    List<Service>? governmentAgencies,
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
