import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/resources/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashBoardRepository dashBoardRepository;
  DashboardBloc({required this.dashBoardRepository})
      : super(DashboardInitial()) {
    on<DashboardCkeckLogout>(
      (event, emit) {
        if (FirebaseAuth.instance.currentUser == null) {
          emit(DashboardLogout());
        }
      },
    );
    on<DashboardRequest>(
      ((event, emit) async {
        // final checkUnMessenger = await dashBoardRepository.checkUnMessenger();
        final checkUnMessenger = true;
        final String responseUserInfor =
            await dashBoardRepository.getInforUser();
        String pathEmailRequest = responseUserInfor.split('-')[0];
        String emailUser = responseUserInfor.split('-')[1];
        String nameUser = responseUserInfor.split('-')[2];
        log(pathEmailRequest);
        log(emailUser);
        log(nameUser);
        DateTime now = DateTime.now();
        final int timeHour;

        if (now.hour == 0) {
          timeHour = 24;
        } else {
          timeHour = now.hour;
        }

        if (timeHour >= 1 && timeHour <= 12) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: nameUser,
              content: "Good morning!",
              unMessenger: checkUnMessenger));
        }
        if (timeHour >= 13 && timeHour <= 18) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: nameUser,
              content: "Good afternoon!",
              unMessenger: checkUnMessenger));
        }
        if (timeHour >= 19 && timeHour <= 24) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: nameUser,
              content: "Good everning!",
              unMessenger: checkUnMessenger));
        }
      }),
    );
  }
}
