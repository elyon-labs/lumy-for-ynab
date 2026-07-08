import 'package:time_machine/time_machine.dart';

Comparator<int> intAsc = (a, b) => a.compareTo(b);
Comparator<int> intDesc = (a, b) => b.compareTo(a);
Comparator<LocalDate> dateAsc = (a, b) => a.compareTo(b);
Comparator<LocalDate> dateDesc = (a, b) => b.compareTo(a);
