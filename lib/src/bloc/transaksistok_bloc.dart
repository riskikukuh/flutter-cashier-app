import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:kasir_app/src/bloc/cartstok_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/detail_transaksi_stok_model.dart';
import 'package:kasir_app/src/models/produk_model.dart';
import 'package:kasir_app/src/models/transaksi_stok_model.dart';
import 'package:kasir_app/src/repository/transaksi_stok_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'transaksistok_event.dart';
part 'transaksistok_state.dart';

class TransaksistokBloc extends Bloc<TransaksistokEvent, TransaksistokState> {
  final CartstokBloc cartstokBloc;
  final ProductsBloc productsBloc;
  final TransaksiStokRepository transaksiStokRepository;
  TransaksistokBloc({
    required this.cartstokBloc,
    required this.productsBloc,
    required this.transaksiStokRepository,
  }) : super(TransaksistokInitial()) {
    on<GetAllTransaksiStok>((event, emit) async {
      emit(TransaksiStokLoading());
      Result<List<TransaksiStokModel>> resultAllTransaksiStok =
          await transaksiStokRepository.getAllTransaksi();
      if (resultAllTransaksiStok is Success<List<TransaksiStokModel>>) {
        emit(TransaksiStokLoadSuccess(
            allTransaksiStok: resultAllTransaksiStok.data));
      } else {
        Error error = state as Error;
        emit(TransaksiStokError(message: error.message));
      }
    });

    on<AddTransaksiStok>((event, emit) async {
      List<TransaksiStokModel> allTransaksiStok = [];
      if (state is TransaksiStokLoadSuccess) {
        allTransaksiStok
            .addAll((state as TransaksiStokLoadSuccess).allTransaksiStok);
      }
      if (cartstokBloc.state is CartStokLoadSuccess) {
        bool isCartEmpty =
            (cartstokBloc.state as CartStokLoadSuccess).cartStok.isEmpty;
        if (!isCartEmpty) {
          emit(TransaksiStokLoading());
          int totalPrice = 0;
          List<DetailTransaksiStokModel> detailTransaksiStok =
              (cartstokBloc.state as CartStokLoadSuccess).cartStok.map((cart) {
            totalPrice += cart.produk.hargaStok * cart.quantity;
            return DetailTransaksiStokModel(
                id: -1,
                idTransaksiStok: -1,
                produk: cart.produk,
                quantity: cart.quantity);
          }).toList();
          TransaksiStokModel transaksiStok = TransaksiStokModel(
            id: -1,
            tanggal: DateTime.now().millisecondsSinceEpoch,
            keterangan: event.keterangan,
            stok: detailTransaksiStok,
            price: totalPrice,
          );
          Result<TransaksiStokModel> resultAddTransaksiStok =
              await transaksiStokRepository.addTransaksi(transaksiStok);
          if (resultAddTransaksiStok is Success<TransaksiStokModel>) {
            cartstokBloc.add(ClearCartStok());
            productsBloc.add(GetAllProduct());
            emit(TransaksiStokNotifSuccess());
            emit(TransaksiStokLoadSuccess(
              allTransaksiStok: allTransaksiStok
                ..add(
                  resultAddTransaksiStok.data,
                ),
            ));
          } else {
            emit(TransaksiStokNotifError());
            Error error = state as Error;
            emit(TransaksiStokError(message: error.message));
          }
        }
      } else {
        emit(TransaksiStokNotifError(message: 'Keranjang stok kosong'));
        emit(TransaksiStokLoadSuccess(allTransaksiStok: allTransaksiStok));
      }
    });

    on<DeleteTransaksiStok>((event, emit) async {
      List<TransaksiStokModel> allTransaksiStok = [];
      if (state is TransaksiStokLoadSuccess) {
        allTransaksiStok
            .addAll((state as TransaksiStokLoadSuccess).allTransaksiStok);
      }
      Result<bool> resultDeleteTransaksi =
          await transaksiStokRepository.deleteTransaksi(event.transaksiStok);
      if (resultDeleteTransaksi is Success<bool>) {
        if (resultDeleteTransaksi.data) {
          emit(TransaksiStokLoadSuccess(
            allTransaksiStok: allTransaksiStok
                .where((transaksi) => transaksi.id != event.transaksiStok.id)
                .toList(),
          ));
        } else {
          emit(TransaksiStokNotifError(
              message: 'Fail to delete Transaksi Stok'));
          emit(TransaksiStokLoadSuccess(allTransaksiStok: allTransaksiStok));
        }
      } else {
        Error error = resultDeleteTransaksi as Error;
        emit(TransaksiStokError(message: error.message));
      }
    });
  }

  @override
  Future<void> close() async {
    await transaksiStokRepository.close();
    return super.close();
  }
}
