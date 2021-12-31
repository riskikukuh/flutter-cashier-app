part of 'transaksistok_bloc.dart';

@immutable
abstract class TransaksistokState {}

class PaymentTransaksiStokSuccess extends TransaksistokState {
  final String message;
  PaymentTransaksiStokSuccess({
    required this.message,
  });
}

class PaymentTransaksiStokError extends TransaksistokState {
  final String message;
  PaymentTransaksiStokError({
    required this.message,
  });
}

class TransaksistokInitial extends TransaksistokState {}

class TransaksiStokLoading extends TransaksistokState {}

class TransaksiStokLoadSuccess extends TransaksistokState {
  final List<TransaksiStokModel> allTransaksiStok;
  TransaksiStokLoadSuccess({
    required this.allTransaksiStok,
  });
}

class TransaksiStokError extends TransaksistokState {
  final String message;
  TransaksiStokError({
    required this.message,
  });
}

class TransaksiStokMessage extends TransaksistokState {
  final String message;
  TransaksiStokMessage({
    required this.message,
  });
}

class TransaksiStokNotifSuccess extends TransaksiStokMessage {
  TransaksiStokNotifSuccess({String? message})
      : super(message: message ?? 'TransaksiStokNotifSuccess');
}

class TransaksiStokNotifError extends TransaksiStokMessage {
  TransaksiStokNotifError({String? message})
      : super(message: message ?? 'TransaksiStokNotifError');
}
