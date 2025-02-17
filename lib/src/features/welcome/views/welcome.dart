// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';

// import '../../../../screens/authentication/sign_in/sign_in_page.dart';
// import '../../../../widgets/app_button.dart';
// import '../../../../widgets/app_text.dart';
// import '../../../../widgets/svg_icon.dart';
// import '../../../core/constants/app_icons.dart';
// import '../../../core/constants/app_images.dart';
// import '../../../core/constants/strings.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(20.spMin),
//         child: Column(
//           children: [
//             const Spacer(),
//             Image.asset(
//               AppImages.logo,
//               height: 92.spMin,
//             ),
//             SizedBox(height: 30.spMin),
//             SvgIcon(
//               SvgIcons.barber,
//               size: 300.spMin,
//             ),
//             const Spacer(),
//             const AppText(
//               Strings.title,
//               fontSize: 20,
//             ),
//             SizedBox(height: 10.spMin),
//             const AppText(
//               Strings.lorem,
//               textAlign: TextAlign.center,
//               color: Colors.black54,
//               fontSize: 14,
//               fontWeight: FontWeight.w400,
//             ),
//             const SizedBox(height: 10),
//             AppButton(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => const SignInScreen(),
//                   ),
//                 );
//               },
//               text: "Get Started",
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
