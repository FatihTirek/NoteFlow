// Refer to app_lock_view_controller.dart
// This view will stay same, nothing has to be changed.

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:local_auth/local_auth.dart';

// import '../controllers/main_controller.dart';
// import '../controllers/views/app_lock_view_controller.dart';

// class AppLockView extends ConsumerStatefulWidget {
//   final Widget? viewToGo;

//   AppLockView({this.viewToGo});

//   @override
//   _AppLockViewState createState() => _AppLockViewState();
// }

// class _AppLockViewState extends ConsumerState<AppLockView> {
//   late AppLockViewController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = AppLockViewController(widget.viewToGo);
//     WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (widget.viewToGo != null) {
//         try {
//           final didAuthenticate = await LocalAuthentication().authenticate(
//               localizedReason: 'Please authenticate to continue',
//               options: AuthenticationOptions(biometricOnly: true, useErrorDialogs: false));

//           if (didAuthenticate)
//             controller.goToView(widget.viewToGo!, replace: true);
//         } catch (e) {}
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(32),
//         child: LayoutBuilder(
//           builder: (p0, p1) {
//             if (MediaQuery.of(context).orientation == Orientation.portrait) {
//               return Column(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         buildPassword(context),
//                         const SizedBox(height: 16),
//                         buildGrid(ref),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 48),
//                   buildSubText(context),
//                 ],
//               );
//             }

//             return Row(
//               children: [
//                 Expanded(child: buildPassword(context)),
//                 const SizedBox(width: 24),
//                 Expanded(
//                   child: Transform.scale(
//                     child: buildGrid(ref),
//                     scale: 0.92,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget buildPassword(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//     final orientation = MediaQuery.of(context).orientation;

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         ValueListenableBuilder(
//           valueListenable: controller.confirmPassword,
//           builder: (_, value, __) => Text(
//             value != null ? 'Confirm Password' : 'Enter Password',
//             style: textTheme.headlineLarge,
//           ),
//         ),
//         const SizedBox(height: 16),
//         ValueListenableBuilder(
//           valueListenable: controller.selectedPassword,
//           builder: (_, value, __) {
//             final length = value.length;

//             return Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 buildBox(context, colorize: length >= 1),
//                 const SizedBox(width: 12),
//                 buildBox(context, colorize: length >= 2),
//                 const SizedBox(width: 12),
//                 buildBox(context, colorize: length >= 3),
//                 const SizedBox(width: 12),
//                 buildBox(context, colorize: length == 4),
//               ],
//             );
//           },
//         ),
//         Visibility(
//           visible: orientation == Orientation.landscape,
//           child: Padding(
//             child: buildSubText(context),
//             padding: const EdgeInsets.only(top: 24),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget buildGrid(WidgetRef ref) {
//     final textTheme = Theme.of(ref.context).textTheme;
//     final landscape =
//         MediaQuery.of(ref.context).orientation == Orientation.landscape;

//     return SizedBox(
//       width: 340,
//       child: GridView(
//         shrinkWrap: true,
//         padding: EdgeInsets.zero,
//         physics: NeverScrollableScrollPhysics(),
//         children: [
//           buildItem(ref, 1),
//           buildItem(ref, 2),
//           buildItem(ref, 3),
//           buildItem(ref, 4),
//           buildItem(ref, 5),
//           buildItem(ref, 6),
//           buildItem(ref, 7),
//           buildItem(ref, 8),
//           buildItem(ref, 9),
//           canAuthenticateWithFingerprint
//               ? Icon(
//                   Icons.fingerprint_outlined,
//                   color: textTheme.headlineLarge!.color,
//                   size: 36,
//                 )
//               : const SizedBox(),
//           buildItem(ref, 0),
//           buildItem(ref, null),
//         ],
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           childAspectRatio: landscape ? 1.25 : 1,
//         ),
//       ),
//     );
//   }

//   Widget buildItem(WidgetRef ref, int? digit) {
//     final textTheme = Theme.of(ref.context).textTheme;

//     if (digit == null) {
//       return IconButton(
//         splashRadius: 45,
//         onPressed: controller.onTapBackSpace,
//         icon: Icon(
//           Icons.backspace_outlined,
//           color: textTheme.headlineLarge!.color,
//           size: 27,
//         ),
//       );
//     }

//     return IconButton(
//       splashRadius: 45,
//       onPressed: () => controller.onTapDigit(ref, digit),
//       icon: Text(
//         digit.toString(),
//         style: textTheme.titleLarge!.copyWith(
//           fontSize: textTheme.titleLarge!.fontSize! + 12,
//         ),
//       ),
//     );
//   }

//   Widget buildBox(BuildContext context, {bool colorize = false}) {
//     final colorScheme = Theme.of(context).colorScheme;
//     final primaryColor = Theme.of(context).primaryColor;

//     return Container(
//       width: 28,
//       height: 28,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: colorize ? primaryColor : colorScheme.surface,
//         border: Border.all(width: 1.5, color: colorScheme.onSurface),
//       ),
//     );
//   }

//   Widget buildSubText(BuildContext context) {
//     final bodyMedium = Theme.of(context).textTheme.bodyMedium;

//     return Text(
//       'If you forget your password you \nwon\'t be able to recover it!',
//       textAlign: TextAlign.center,
//       style: bodyMedium!.copyWith(color: bodyMedium.color!.withOpacity(.64)),
//     );
//   }
// }