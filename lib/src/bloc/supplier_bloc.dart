import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/repository/supplier_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'supplier_event.dart';
part 'supplier_state.dart';

class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final SupplierRepository supplierRepository;
  SupplierBloc({
    required this.supplierRepository,
  }) : super(SupplierInitial()) {
    on<GetAllSupplier>((event, emit) async {
      emit(SupplierLoading());
      await Future.delayed(const Duration(seconds: 1));
      Result<List<SupplierModel>> allSupplier =
          await supplierRepository.getAllSupplier();
      if (allSupplier is Success<List<SupplierModel>>) {
        emit(SupplierLoadSuccess(allSupplier: allSupplier.data));
      } else {
        Error error = allSupplier as Error;
        emit(SupplierError(
          message: error.message,
        ));
      }
    });

    on<AddSupplier>((event, emit) async {
      if (state is SupplierLoadSuccess) {
        List<SupplierModel> oldSupplier =
            (state as SupplierLoadSuccess).allSupplier;
        SupplierModel supplier = SupplierModel(
          id: -1,
          nama: event.nama,
          noTelp: event.noTelp,
          alamat: event.alamat,
        );
        await Future.delayed(const Duration(seconds: 1));
        Result<SupplierModel> resultInsert =
            await supplierRepository.addSupplier(supplier);
        if (resultInsert is Success<SupplierModel>) {
          emit(SupplierNotifSuccess(message: 'Berhasil menambahkan supplier'));
          emit(SupplierLoadSuccess(
              allSupplier: oldSupplier..add(resultInsert.data)));
        } else {
          Error error = resultInsert as Error;
          emit(SupplierNotifError(message: error.message));
          emit(SupplierError(message: error.message));
        }
      } else {
        print('AddSupplier state : $state');
      }
    });

    on<EditSupplier>((event, emit) async {
      if (state is SupplierLoadSuccess) {
        List<SupplierModel> oldSupplier =
            (state as SupplierLoadSuccess).allSupplier;
        await Future.delayed(const Duration(seconds: 1));
        Result<bool> resultEdit =
            await supplierRepository.editSupplier(event.supplier);
        if (resultEdit is Success<bool>) {
          if (resultEdit.data) {
            emit(SupplierNotifSuccess(message: 'Berhasil mengubah supplier'));
            emit(SupplierLoadSuccess(
              allSupplier: oldSupplier
                  .map((supplier) => supplier.id == event.supplier.id
                      ? event.supplier
                      : supplier)
                  .toList(),
            ));
          } else {
            emit(SupplierNotifError(message: 'Gagal mengubah supplier'));
            emit(SupplierLoadSuccess(allSupplier: oldSupplier));
          }
        } else {
          Error error = resultEdit as Error;
          emit(SupplierError(
            message: error.message,
          ));
        }
      } else {
        print('EditSupplier : $state');
      }
    });

    on<DeleteSupplier>((event, emit) async {
      if (state is SupplierLoadSuccess) {
        List<SupplierModel> oldSupplier =
            (state as SupplierLoadSuccess).allSupplier;
        await Future.delayed(const Duration(seconds: 1));
        Result<bool> resultDelete =
            await supplierRepository.deleteSupplier(event.supplier);
        if (resultDelete is Success<bool>) {
          if (resultDelete.data) {
            emit(SupplierNotifSuccess(message: 'Berhasil menghapus supplier'));
            emit(SupplierLoadSuccess(
              allSupplier: oldSupplier
                  .where((supplier) => supplier.id != event.supplier.id)
                  .toList(),
            ));
          } else {
            emit(SupplierNotifError(message: 'Gagal menghapus supplier'));
            emit(SupplierLoadSuccess(
              allSupplier: oldSupplier,
            ));
          }
        } else {
          Error error = resultDelete as Error;
          emit(SupplierError(message: error.message));
        }
      } else {
        print('DeleteSupplier : $state');
      }
    });
  }

  @override
  Future<void> close() async {
    await supplierRepository.close();
    return super.close();
  }
}
