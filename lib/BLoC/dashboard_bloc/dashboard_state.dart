part of 'dashboard_bloc.dart';

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final String pathEmail;
  final String nameUser;
  final String content;
    final String typeUser;
  final bool unMessenger;

  const DashboardLoaded( 
      {required this.pathEmail,
      required this.nameUser,
      required this.content,
      required this.unMessenger,
      required this.typeUser,
     });
}

class DashboardLogout extends DashboardState {}

class DashboardError extends DashboardState {}
