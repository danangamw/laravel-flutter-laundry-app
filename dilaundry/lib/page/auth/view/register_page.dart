import 'package:d_button/d_button.dart';
import 'package:d_info/d_info.dart';
import 'package:d_input/d_input.dart';
import 'package:d_view/d_view.dart';
import 'package:dilaundry/config/app_response.dart';
import 'package:dilaundry/config/config.dart';
import 'package:dilaundry/page/auth/datasource/auth_datasource.dart';
import 'package:dilaundry/page/auth/provider/register_provider.dart';
import 'package:dilaundry/page/auth/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final edtUsername = TextEditingController();
  final edtEmail = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  execute() {
    bool validInput = formKey.currentState!.validate();
    if (!validInput) return;

    setRegisterStatus(ref, 'Loading');

    AuthDatasource.register(
      edtUsername.text,
      edtEmail.text,
      edtPassword.text,
    ).then((value) {
      String newStatus = '';

      value.fold(
        (failure) {
          switch (failure.runtimeType) {
            case ServerFailure:
              newStatus = "Server Error";
              DInfo.toastError(newStatus);
              break;
            case NotFoundFailure:
              newStatus = "Err Not Found";
              DInfo.toastError(newStatus);
              break;
            case ForbiddenFailure:
              newStatus = "You don'\t have access";
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = "Invalid Input";
              AppResponse.invalidInput(context, failure.message);
              break;
            case UnauthorizedFailure:
              newStatus = "Unauthorized";
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.message;
              break;
          }

          setRegisterStatus(ref, newStatus);
        },
        (result) {
          DInfo.toastSuccess('Register Success');
          setRegisterStatus(ref, 'Success');
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppAssets.bgAuth,
              fit: BoxFit.cover,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black54,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          children: [
                            Text(
                              AppConstants.appName,
                              style: GoogleFonts.poppins(
                                fontSize: 40.0,
                                color: Colors.green[900],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              height: 5,
                              width: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.person,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: DInput(
                                  controller: edtUsername,
                                  fillColor: Colors.white70,
                                  hint: 'Username',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) =>
                                      input == '' ? "Don't empty" : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.email,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: DInput(
                                  controller: edtEmail,
                                  fillColor: Colors.white70,
                                  hint: 'Email',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) =>
                                      input == '' ? "Don't empty" : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: Material(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(10),
                                  child: const Icon(
                                    Icons.key,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: DInputPassword(
                                  controller: edtPassword,
                                  fillColor: Colors.white70,
                                  hint: 'Password',
                                  radius: BorderRadius.circular(10),
                                  validator: (input) =>
                                      input == '' ? "Don't empty" : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DView.height(),
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              AspectRatio(
                                aspectRatio: 1,
                                child: DButtonFlat(
                                  onClick: () {
                                    Navigator.pop(context);
                                  },
                                  padding: const EdgeInsets.all(0),
                                  radius: 10,
                                  mainColor: Colors.white70,
                                  child: const Text(
                                    'LOG',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DView.width(10),
                              Expanded(
                                child: Consumer(builder: (context, wiRef, _) {
                                  String status =
                                      wiRef.watch(registerStatusProvider);
                                  if (status == 'Loading') {
                                    return DView.loadingCircle();
                                  }

                                  return ElevatedButton(
                                    onPressed: () {
                                      bool validInput =
                                          formKey.currentState!.validate();
                                      if (!validInput) return;

                                      AuthService.register(
                                        context: context,
                                        ref: ref,
                                        username: edtUsername.text,
                                        email: edtEmail.text,
                                        password: edtPassword.text,
                                      );
                                    },
                                    style: const ButtonStyle(
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 16,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    child: const Text(
                                      'Register',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
