import 'package:demo_input_toss/TableToss.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TableToss(),
      );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Timer(Duration(seconds: 1), () {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => TableToss()));
//     });
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Container(
//           padding: EdgeInsets.all(5),
//           width: 435,
//           height: 427,
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             shape: BoxShape.circle,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 width: 420,
//                 height: 412,
//                 './assets/logo.jpg',
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
