import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class passController extends GetxController{
  var currPass=0.obs;
  var id="".obs;
  var updateStatus=0.obs;
  var deleteStatus=0.obs;
  var timeList=[].obs;

  @override
  void onInit() async{
    super.onInit();
    await fetchData();
    await fetchTimeData();

  }


  Future<void> fetchData() async {
    print("password");
    final response = await http.get(Uri.parse('http://10.100.162.108:5000/api/embedded/password/getPass'));
    print(response.body);

    Map<dynamic,dynamic> data=jsonDecode(response.body);
    id.value=data["data"][0]["_id"];
    currPass.value=data["data"][0]["password"];
    // return temp;
  }

  Future<void> fetchTimeData() async {
    // print("password");
    final response = await http.get(Uri.parse('http://10.100.162.108:5000/api/embedded/password/getTime'));
    print(response.body);

    Map<dynamic,dynamic> data=jsonDecode(response.body);
    timeList.value=data["data"];
  }

  Future<void> deleteTimeData() async {
    final response = await http.delete(Uri.parse('http://10.100.162.108:5000/api/embedded/password/deleteTime'));

    if(response.statusCode==200){
      await fetchTimeData();
      deleteStatus.value=1;
    }
  }

  Future<void> updateData(String pass) async {
    // print(pass);
    final response = await http.patch(Uri.parse('http://10.100.162.108:5000/api/embedded/password/updatePass?id=${id.value}'),
      headers: {
        'Content-Type':
        'application/json', // Add any additional headers if required
      },
      body: jsonEncode(<String, dynamic>{
        'password':pass}),);
    // print(response.body);

    if(response.statusCode==200){
      fetchData();
      print("updateStatus.value");
      updateStatus.value=1;
    }

  }


}