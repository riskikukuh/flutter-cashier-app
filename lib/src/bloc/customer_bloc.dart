import 'package:bloc/bloc.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/repository/customer_repository.dart';
import 'package:kasir_app/src/resources/result.dart';
import 'package:meta/meta.dart';

part 'customer_event.dart';
part 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  CustomerBloc({
    required this.customerRepository,
  }) : super(CustomerInitial()) {
    on<GetAllCustomer>((event, emit) async {
      emit(CustomerLoading());
      await Future.delayed(const Duration(seconds: 1));
      Result<List<CustomerModel>> resultAllCustomer =
          await customerRepository.getAllCustomer();
      if (resultAllCustomer is Success<List<CustomerModel>>) {
        emit(CustomerLoadSuccess(allCustomer: resultAllCustomer.data));
      } else {
        Error error = resultAllCustomer as Error;
        emit(CustomerError(message: error.message));
      }
    });

    on<AddCustomer>((event, emit) async {
      if (state is CustomerLoadSuccess) {
        List<CustomerModel> oldData =
            (state as CustomerLoadSuccess).allCustomer;
        emit(CustomerLoading());
        CustomerModel cm = CustomerModel(
          id: -1,
          nama: event.nama,
          jk: event.jk,
          noTelp: event.noTelp,
          alamat: event.alamat,
        );
        await Future.delayed(const Duration(seconds: 1));
        Result<CustomerModel> resultCustomer =
            await customerRepository.addCustomer(cm);
        if (resultCustomer is Success<CustomerModel>) {
          emit(CustomerLoadSuccess(
              allCustomer: oldData..add(resultCustomer.data)));
        } else {
          Error error = resultCustomer as Error;
          emit(CustomerError(message: error.message));
        }
      } else {
        print('Event AddCustomer: State $state');
      }
    });

    on<EditCustomer>((event, emit) async {
      if (state is CustomerLoadSuccess) {
        List<CustomerModel> oldData =
            (state as CustomerLoadSuccess).allCustomer;
        emit(CustomerLoading());
        await Future.delayed(const Duration(seconds: 1));
        Result<bool> resultUpdate =
            await customerRepository.editCustomer(event.customer);
        if (resultUpdate is Success<bool>) {
          if (resultUpdate.data) {
            emit(CustomerNotifSuccess(message: 'Berhasil mengubah customer'));
            emit(CustomerLoadSuccess(
              allCustomer: oldData.map((customer) {
                return customer.id == event.customer.id
                    ? event.customer
                    : customer;
              }).toList(),
            ));
          } else {
            emit(CustomerNotifError(message: 'Gagal mengubah customer'));
            emit(CustomerLoadSuccess(allCustomer: oldData));
          }
        } else {
          Error error = resultUpdate as Error;
          emit(CustomerError(
            message: error.message,
          ));
        }
      } else {
        print('Event EditCustomer: State $state');
      }
    });

    on<DeleteCustomer>((event, emit) async {
      if (state is CustomerLoadSuccess) {
        List<CustomerModel> allCustomer =
            (state as CustomerLoadSuccess).allCustomer;
        emit(CustomerLoading());
        await Future.delayed(const Duration(seconds: 1));
        Result<bool> resultDelete =
            await customerRepository.deleteCustomer(event.customer);
        if (resultDelete is Success<bool>) {
          if (resultDelete.data) {
            emit(CustomerNotifSuccess(message: 'Berhasil menghapus customer'));
            emit(CustomerLoadSuccess(
              allCustomer: allCustomer
                  .where((customer) => customer.id != event.customer.id)
                  .toList(),
            ));
          } else {
            emit(CustomerNotifError(message: 'Gagal menghapus customer'));
            emit(CustomerLoadSuccess(allCustomer: allCustomer));
          }
        } else {
          Error error = resultDelete as Error;
          emit(CustomerError(message: error.message));
        }
      } else {
        print('Event DeleteCustomer: State $state');
      }
    });
  }

  @override
  Future<void> close() async {
    await customerRepository.close();
    return super.close();
  }
}
