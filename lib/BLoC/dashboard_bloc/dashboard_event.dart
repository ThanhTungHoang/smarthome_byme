part of 'dashboard_bloc.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}
class DashboardCkeckLogout extends DashboardEvent {}
class DashboardRequest extends DashboardEvent {}
