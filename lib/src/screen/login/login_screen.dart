import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_app/src/bloc/user_bloc.dart';
import 'package:kasir_app/src/resources/util.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({
    Key? key,
  }) : super(key: key);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String username = '';
  String password = '';

  navigateToHome(BuildContext context){
    Navigator.of(context).pushReplacementNamed('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(32, 24, 32, 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      onSaved: (text) {
                        if (text != null && text.isNotEmpty) {
                          username = text;
                        }
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Username tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      onSaved: (text) {
                        if (text != null && text.isNotEmpty) {
                          password = text;
                        }
                      },
                      validator: (text) {
                        if (text == null || text.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        return null;
                      },
                      obscureText: true,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocConsumer<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoading) {
                          return const CircularProgressIndicator();
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  FormState? state = _formKey.currentState;
                                  state?.save();
                                  if (state != null &&
                                      state.validate() &&
                                      username.isNotEmpty &&
                                      password.isNotEmpty) {
                                    context.read<UserBloc>().add(Login(
                                        username: username, password: password));
                                  } else {
                                    Util.showSnackbar(context,
                                        'Form login harus diisi dengan lengkap');
                                  }
                                },
                                child: const Text('Login'),
                              ),
                            ),
                          ],
                        );
                      },
                      listener: (context, state) {
                        if (state is SuccessLogin) {
                          Util.showSnackbar(context, 'Login berhasil');
                          navigateToHome(context);
                        } else if (state is CredentialFailure) {
                          Util.showSnackbar(context, state.message);
                        } else  if (state is UserError) {
                          Util.showSnackbar(context, state.message);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
