part of 'dashboard_main_bloc.dart';

abstract class DashboardMainState extends Equatable {
  const DashboardMainState();

  @override
  List<Object> get props => [];
}

class DashboardMainInitial extends DashboardMainState {}

class DashboardMainLoading extends DashboardMainState {}

class DashboardMainLoaded extends DashboardMainState {
  final String nameUser;
  final String content;
  final bool unMessenger;

  const DashboardMainLoaded(this.nameUser, this.content, this.unMessenger);
}

class DashboardMainError extends DashboardMainState {}
