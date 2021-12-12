import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/bloc/cart_bloc.dart';
import 'package:kasir_app/src/bloc/products_bloc.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/models/order_model.dart';
import 'package:kasir_app/src/models/transaksi_model.dart';
import 'package:kasir_app/src/repository/transaksi_repository.dart';
import 'package:kasir_app/src/resources/mapper.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'transaksi_event.dart';
part 'transaksi_state.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final CartBloc cartBloc;
  final ProductsBloc productsBloc;
  final TransaksiRepository transaksiRepository;
  TransaksiBloc({
    required this.productsBloc,
    required this.cartBloc,
    required this.transaksiRepository,
  }) : super(TransaksiInitial()) {
    on<GetAllTransaksi>((event, emit) async {
      emit(TransaksiLoading());
      Result<List<TransaksiModel>> allTransaksi =
          await transaksiRepository.getAllTransaksi();
      if (allTransaksi is Success<List<TransaksiModel>>) {
        emit(TransaksiLoadSuccess(
          allTransaksi: allTransaksi.data,
        ));
      } else {
        Error error = allTransaksi as Error;
        emit(TransaksiError(
          message: error.message,
        ));
      }
    });

    on<AddTransaksi>((event, emit) async {
      // print('AddTransaksi: ${cartBloc.state}');
      if (cartBloc.state is CartFetched) {
        List<OrderModel> allOrder = (cartBloc.state as CartFetched).order;
        int price = 0;
        for (var order in allOrder) {
          price += order.quantity * order.produk.harga;
        }
        print('price : $price');
        if (state is TransaksiLoadSuccess) {
          List<TransaksiModel> oldTransaksi =
              (state as TransaksiLoadSuccess).allTransaksi;
          emit(TransaksiLoading());
          await Future.delayed(const Duration(seconds: 2));
          TransaksiModel transaksi = TransaksiModel(
            id: -1,
            pembeli: event.customer,
            orders: allOrder
                .map((order) => mapOrderModelToTransaksiOrderModel(order))
                .toList(),
            tanggal: DateTime.now().millisecondsSinceEpoch,
            keterangan: event.keterangan,
            price: price,
          );
          Result<TransaksiModel> transaksiResult =
              await transaksiRepository.addTransaksi(transaksi);
          if (transaksiResult is Success<TransaksiModel>) {
            cartBloc.add(ClearCart());
            productsBloc.add(GetAllProduct());
            emit(TransaksiLoadSuccess(
              allTransaksi: oldTransaksi..add(transaksiResult.data),
            ));
          } else {
            Error error = transaksiResult as Error;
            emit(TransaksiError(
              message: error.message,
            ));
          }
        } else {
          print('AddTransaksi : $state');
        }
      } else {
        print('AddTransaksi Cart error : ${cartBloc.state}');
      }
    });
  }

  @override
  Future<void> close() async {
    await transaksiRepository.close();
    return super.close();
  }
}
