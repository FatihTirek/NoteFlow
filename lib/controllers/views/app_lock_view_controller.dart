// I changed my decision about how the app lock should be implemented.
// Instead of making it app wide, we can make it like below.
// Show app lock screen on icon button click and if password is true then we can show all hidden notes along with others.
// Icon button will be placed on home view and also on folder view?
// This needs to be rewritten.

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../utils.dart';
// import '../widgets/shared/app_theme_controller.dart';

// class AppLockViewController with Utils {
//   final Widget? viewToGo;

//   AppLockViewController(this.viewToGo);

//   final selectedPassword = ValueNotifier<String>('');
//   final confirmPassword = ValueNotifier<int?>(null);

//   void onTapDigit(WidgetRef ref, int digit) async {
//     if (selectedPassword.value.length < 4) {
//       selectedPassword.value = selectedPassword.value + digit.toString();

//       if (selectedPassword.value.length == 4) {
//         final password = int.parse(selectedPassword.value);
//         await Future.delayed(const Duration(milliseconds: 250));

//         if (viewToGo != null) {
//           if (password == ref.read(appThemeController).appTheme.password) {
//             goToView(viewToGo!, replace: true);
//           } else {
//             selectedPassword.value = '';
//             showToast('Wrong password', short: true);
//           }
//         } else {
//           if (confirmPassword.value == null) {
//             confirmPassword.value = password;
//             selectedPassword.value = '';
//           } else {
//             if (password == confirmPassword.value) {
//               ref.read(appThemeController.notifier).setPassword(password);
//               Navigator.pop(ref.context);
//             } else {
//               selectedPassword.value = '';
//               showToast('Passwords don\'t match', short: true);
//             }
//           }
//         }
//       }
//     }
//   }

//   void onTapBackSpace() {
//     if (selectedPassword.value.isNotEmpty) {
//       selectedPassword.value = selectedPassword.value
//           .substring(0, selectedPassword.value.length - 1);
//     }
//   }
// }
