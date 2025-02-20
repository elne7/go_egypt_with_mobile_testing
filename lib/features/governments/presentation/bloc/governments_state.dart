import '../../domain/entities/government.dart';

abstract class GovernmentsState {}

class GovernmentsInitial extends GovernmentsState {}

class GovernmentsLoading extends GovernmentsState {}

class GovernmentsLoaded extends GovernmentsState {
  final List<Government> governments;
  GovernmentsLoaded(this.governments);
}

class GovernmentsError extends GovernmentsState {
  final String message;
  GovernmentsError(this.message);
}