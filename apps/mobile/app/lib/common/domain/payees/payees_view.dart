import 'package:equatable/equatable.dart';

sealed class PayeesView extends Equatable {
  const PayeesView();
}

class AllPayees extends PayeesView {
  const AllPayees();

  @override
  List<Object?> get props => [];
}
