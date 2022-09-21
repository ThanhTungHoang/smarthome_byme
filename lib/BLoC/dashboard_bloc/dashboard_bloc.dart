import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smarthome_byme/resources/dashboard_repository.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashBoardRepository dashBoardRepository;
  DashboardBloc({required this.dashBoardRepository})
      : super(DashboardInitial()) {
    on<DashboardRequest>(
      ((event, emit) async {
        emit(DashboardLoading());
        final String pathEmailRequest =
            await dashBoardRepository.getPathEmailRequest();
        DateTime now = DateTime.now();
        final int timeHour;
        late String responseNameUser;
        final String response;
        final checkUnMessenger = await dashBoardRepository.checkUnMessenger();
        if (now.hour == 0) {
          timeHour = 24;
        } else {
          timeHour = now.hour;
        }
        try {
          response = await dashBoardRepository.getUserName();
          responseNameUser = response.toString();
        } catch (e) {
          responseNameUser = "Hi User";
        }

        if (timeHour >= 1 && timeHour <= 12) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: responseNameUser,
              content: "Good morning!",
              unMessenger: checkUnMessenger));
        }
        if (timeHour >= 13 && timeHour <= 18) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: responseNameUser,
              content: "Good afternoon!",
              unMessenger: checkUnMessenger));
        }
        if (timeHour >= 19 && timeHour <= 24) {
          emit(DashboardLoaded(
              pathEmail: pathEmailRequest,
              nameUser: responseNameUser,
              content: "Good everning!",
              unMessenger: checkUnMessenger));
        }
      }),
    );
  }
}
