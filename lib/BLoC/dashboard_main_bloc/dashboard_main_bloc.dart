import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/resources/dashboard_repository.dart';

part 'dashboard_main_event.dart';
part 'dashboard_main_state.dart';

class DashboardMainBloc extends Bloc<DashboardMainEvent, DashboardMainState> {
  final DashBoardRepository dashBoardRepository;
  DashboardMainBloc({required this.dashBoardRepository})
      : super(DashboardMainInitial()) {
    // on<DashboardMainRequest>((event, emit) async {
    //   emit(DashboardMainLoading());
    //   DateTime now = DateTime.now();
    //   final int timeHour;
    //   late String responseNameUser;
    //   final String response;
    //   final checkUnMessenger = await dashBoardRepository.checkUnMessenger();
    //   if (now.hour == 0) {
    //     timeHour = 24;
    //   } else {
    //     timeHour = now.hour;
    //   }
    //   try {
    //     response = await dashBoardRepository.getUserName();
    //     responseNameUser = response.toString();
    //   } catch (e) {
    //     responseNameUser = "Hi User";
    //   }

    //   if (timeHour >= 1 && timeHour <= 12) {
    //     emit(DashboardMainLoaded(
    //         responseNameUser, "Good morning!", checkUnMessenger));
    //   }
    //   if (timeHour >= 13 && timeHour <= 18) {
    //     emit(DashboardMainLoaded(
    //         responseNameUser, "Good afternoon!", checkUnMessenger));
    //   }
    //   if (timeHour >= 19 && timeHour <= 24) {
    //     emit(DashboardMainLoaded(
    //         responseNameUser, "Good everning!", checkUnMessenger));
    //   }
    // });
  }
}
