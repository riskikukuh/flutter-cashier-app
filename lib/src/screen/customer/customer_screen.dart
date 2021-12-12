import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/customer_bloc.dart';
import 'package:kasir_app/src/models/customer_model.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/customer/form_customer_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';

class CustomerScreen extends StatelessWidget {
  const CustomerScreen({Key? key}) : super(key: key);

  Widget _mapStateToWidget(CustomerState state) {
    if (state is CustomerLoadSuccess) {
      if (state.allCustomer.isEmpty) {
        return const Text(
          'Customer Kosong',
        );
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: state.allCustomer.length,
        itemBuilder: (context, i) {
          CustomerModel cm = state.allCustomer[i];
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              title: Text(
                cm.nama,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == 0) {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FormCustomerScreen(
                              customer: cm,
                            )));
                  } else if (value == 1) {
                    Util.showDialogAlert(context, 'Menghapus Customer',
                        'Anda yakin ingin menghapus data customer ini ?', () {
                      context
                          .read<CustomerBloc>()
                          .add(DeleteCustomer(customer: cm));
                      Navigator.of(context).pop();
                    });
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 0,
                    child: Text('Edit'),
                  ),
                  PopupMenuItem(
                    value: 1,
                    child: Text('Delete'),
                  ),
                ],
              ),
              subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    cm.jk == 'P' ? 'Pria' : 'Wanita',
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    cm.noTelp,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    cm.alamat,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              ),
              leading: Icon(
                Icons.person,
              ),
            ),
          );
        },
      );
    } else if (state is CustomerLoading) {
      return const CircularProgressIndicator();
    } else if (state is CustomerError) {
      return Text(state.message);
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Customer',
        ),
        actions: [
          const CartButton(),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/formCustomer');
            },
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerMessage) {
              Util.showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            return _mapStateToWidget(state);
          },
        ),
      ),
    );
  }
}
