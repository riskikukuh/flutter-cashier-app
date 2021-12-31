part of 'transaksistok_bloc.dart';

@immutable
abstract class TransaksistokEvent {}

class GetAllTransaksiStok extends TransaksistokEvent {}

class AddTransaksiStok extends TransaksistokEvent {
  final String keterangan;
  AddTransaksiStok({
    required this.keterangan,
  });
}

class DeleteTransaksiStok extends TransaksistokEvent {
  final TransaksiStokModel transaksiStok;
  DeleteTransaksiStok({
    required this.transaksiStok,
  });
}
