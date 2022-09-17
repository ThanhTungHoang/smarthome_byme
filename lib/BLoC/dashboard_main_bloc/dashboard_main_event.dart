part of 'dashboard_main_bloc.dart';

abstract class DashboardMainEvent extends Equatable {
  const DashboardMainEvent();

  @override
  List<Object> get props => [];
}

class DashboardMainRequest extends DashboardMainEvent {}
