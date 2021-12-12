part of 'transaksi_bloc.dart';

@immutable
abstract class TransaksiState {}

class TransaksiInitial extends TransaksiState {}

class TransaksiLoading extends TransaksiState {}

class TransaksiLoadSuccess extends TransaksiState {
  final List<TransaksiModel> allTransaksi;
  TransaksiLoadSuccess({
    required this.allTransaksi,
  });
}

class TransaksiError extends TransaksiState {
  final String message;
  TransaksiError({
    required this.message,
  });
}
