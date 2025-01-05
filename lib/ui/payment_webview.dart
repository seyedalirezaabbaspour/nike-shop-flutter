
// class PaymetGatewayScreen extends StatelessWidget{
//  final String bankGateWayUrl;

//   const PaymetGatewayScreen({super.key, required this.bankGateWayUrl});
//   @override
//   Widget build(BuildContext context) {
//     return WebView(
//       initialUrl: bankGateWayUrl,
//       javascriptMode: JavascriptMode.unrestricted,
//       onPageStarted: (url) {
//         final uri = Uri.parse(url);
//         if(uri.pathSegments.contains("checkout")&&uri.host=="extpertdevelopers.ir"){
//         final orderId = int.parse(uri.queryParameters["order_id"]!);
//         Navigator.of(context).pop();
//           Navigator.of(context).push( MaterialPageRoute(builder: (context) => PaymentReceiptScreen(orderId: orderId) ,));
//         }
//       },
//     );
//   }
// }