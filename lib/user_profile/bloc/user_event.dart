import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class FetchUserDetails extends UserEvent {
  final int userId;

  const FetchUserDetails(this.userId);

  @override
  List<Object> get props => [userId];
}
