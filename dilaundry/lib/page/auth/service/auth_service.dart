import 'package:d_info/d_info.dart';
import 'package:dilaundry/config/app_response.dart';
import 'package:dilaundry/config/config.dart';
import 'package:dilaundry/page/auth/datasource/auth_datasource.dart';
import 'package:dilaundry/page/auth/provider/login_provider.dart';
import 'package:dilaundry/page/auth/provider/register_provider.dart';
import 'package:dilaundry/page/dashboard/view/dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  static void login({
    required BuildContext context,
    required WidgetRef ref,
    required String email,
    required String password,
  }) {
    setLoginStatus(ref, 'Loading');

    AuthDatasource.login(
      email,
      password,
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
              newStatus = "You don't have access";
              DInfo.toastError(newStatus);
              break;
            case BadRequestFailure:
              newStatus = "Invalid Input";
              AppResponse.invalidInput(context, failure.message);
              break;
            case InvalidInputFailure:
              newStatus = "Invalid Input";
              AppResponse.invalidInput(context, failure.message);
              break;
            case UnauthorizedFailure:
              newStatus = "Login Failed";
              DInfo.toastError(newStatus);
              break;
            default:
              newStatus = 'Request Error';
              DInfo.toastError(newStatus);
              newStatus = failure.message;
              break;
          }

          setLoginStatus(ref, newStatus);
        },
        (result) {
          AppSession.setUser(result['data']);
          AppSession.setBearerToken(result['token']);
          DInfo.toastSuccess('Login Success');
          setLoginStatus(ref, 'Success');
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardPage()));
        },
      );
    });
  }

  static void register(
      {required BuildContext context,
      required WidgetRef ref,
      required String username,
      required String email,
      required String password}) {
    setRegisterStatus(ref, 'Loading');

    AuthDatasource.register(
      username,
      email,
      password,
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
}
