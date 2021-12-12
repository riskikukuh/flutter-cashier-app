part of 'transaksi_bloc.dart';

@immutable
abstract class TransaksiEvent {}

class GetAllTransaksi extends TransaksiEvent {}

class AddTransaksi extends TransaksiEvent {
  final CustomerModel customer;
  // final List<OrderModel> orders;
  final String keterangan;
  AddTransaksi({
    required this.customer,
    // required this.orders,
    required this.keterangan,
  });
}
