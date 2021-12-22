import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/supplier_bloc.dart';
import 'package:kasir_app/src/models/supplier_model.dart';
import 'package:kasir_app/src/resources/util.dart';
import 'package:kasir_app/src/screen/supplier/form_supplier_screen.dart';
import 'package:kasir_app/src/widget/cart_button.dart';

class SupplierScreen extends StatelessWidget {
  const SupplierScreen({Key? key}) : super(key: key);

  _onSelectedActionMenu(BuildContext context, dynamic item, SupplierModel sm) {
    if (item == 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => FormSupplierScreen(
                supplier: sm,
              )));
    } else if (item == 1) {
      Util.showDialogAlert(context, 'Menghapus Supplier',
          'Anda yakin ingin menghapus supplier ini ?', () {
        context.read<SupplierBloc>().add(DeleteSupplier(supplier: sm));
        Navigator.of(context).pop();
      });
    }
  }

  Widget _mapSupplierStateToWidget(SupplierState state) {
    if (state is SupplierLoadSuccess) {
      if (state.allSupplier.isEmpty) {
        return const Text(
          'Supplier kosong',
        );
      }
      return ListView.builder(
        itemCount: state.allSupplier.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, i) {
          SupplierModel sm = state.allSupplier[i];
          return Card(
            child: ListTile(
              title: Text(
                sm.nama,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: PopupMenuButton(
                onSelected: (item) {
                  _onSelectedActionMenu(context, item, sm);
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
                    sm.noTelp,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    sm.alamat,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
              leading: const Icon(
                Icons.business,
              ),
            ),
          );
        },
      );
    } else if (state is SupplierLoading) {
      return const CircularProgressIndicator();
    } else {
      return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Supplier',
        ),
        actions: [
          const CartButton(),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/formSupplier');
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        child: BlocConsumer<SupplierBloc, SupplierState>(
          listener: (context, state) {
            if (state is SupplierMessage) {
              Util.showSnackbar(context, state.message);
            }
          },
          builder: (context, state) {
            return _mapSupplierStateToWidget(state);
          },
        ),
      ),
    );
  }
}
