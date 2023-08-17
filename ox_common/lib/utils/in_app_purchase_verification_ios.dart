
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final sandboxUrl = Uri.parse('https://sandbox.itunes.apple.com/verifyReceipt');
final officialUrl = Uri.parse('https://buy.itunes.apple.com/verifyReceipt');

saveVerificationData(String verificationData) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('verificationData', verificationData);
}

removeVerificationData() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('verificationData');
}



Future<String?> getLocalVerificationData() async{
    final prefs = await SharedPreferences.getInstance();
    final String? verificationData =  await prefs.getString('verificationData');
    return verificationData;
}

//Verify a wave when the app starts, and remind if there are unfinished tasks
Future<bool> handleLocalValidation() async{
    String? verificationData = await getLocalVerificationData();
    if(Platform.isIOS){
        if(verificationData != null){
            return handleValidation(verificationData: verificationData);
        }
    }
    return false;
}

Future<bool> handleValidation({required String verificationData,  bool isSandbox = true}) async {
    print('AppStorePurchaseHandler.handleValidation');
    print('token: $verificationData');
    // https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
    const headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
    };
    final response = await http.post(
        isSandbox ? sandboxUrl : officialUrl,
        body: jsonEncode({
            'receipt-data': verificationData,
            // 'password': appStoreSharedSecret,  //KEY required for subscription-based in-app purchase verification
        }),
        headers: headers,
    );
    final dynamic json = jsonDecode(response.body);
    final status = json['status'] as int;
    if (status == 0) {
        print('Successfully verified purchase');
        print('Successfully: json: $json');
        // removeVerificationData(verificationData);
        return true;
    } else {//The audit and development use a sandbox environment, and when the sandbox environment fails, use a formal environment to try again
        if(isSandbox){
            handleValidation(verificationData: verificationData, isSandbox: false);
        }
        print('Error: Status: $status');
        print('Error: json: $json');
        // CommonToast.instance.show(context!, Localized.text("ox_usercenter.Cancel purchase"));
        return false;
    }
}

//Subscription-based verification that the purchase was successful
Future<bool> handleSubscribeValidation({required String verificationData,  bool isSandbox = true}) async {
    print('AppStorePurchaseHandler.handleValidation');
    print('token: $verificationData');
    // https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
    const headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
    };
    final response = await http.post(
        isSandbox ? sandboxUrl : officialUrl,
        body: jsonEncode({
            'receipt-data': verificationData,
            'password': '',  //KEY required for subscription-based in-app purchase verification
        }),
        headers: headers,
    );
    final dynamic json = jsonDecode(response.body);
    final status = json['status'] as int;
    if (status == 0) {
        print('Successfully verified purchase');
        print('Successfully: json: $json');
        // removeVerificationData(verificationData);
        return true;
    } else {
        if(isSandbox){
            handleValidation(verificationData: verificationData, isSandbox: false);
        }
        print('Error: Status: $status');
        print('Error: json: $json');
        // CommonToast.instance.show(context!, Localized.text("ox_usercenter.Cancel purchase"));
        return false;
    }
}

