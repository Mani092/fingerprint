import 'dart:convert';
import 'dart:ffi';

import 'package:fingerprint/controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home:  Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final passController ps=Get.put(passController());

  late dynamic password;
  late String id="";

  String? passwordText;

  @override
  void initState() {
    // TODO: implement initState
    ps.fetchData();
    super.initState();
  }

  late dynamic temp="";
  @override
  Widget build(BuildContext context) {



    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Embedded Project',style: TextStyle(fontWeight: FontWeight.w500,letterSpacing: 1),),),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
             Obx(() => Text('Current Password: ${ps.currPass.value.toString()}',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Colors.redAccent),),),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.start,
                onChanged: (val){
                  passwordText=val;
                },
                decoration: InputDecoration(
                  labelText: 'Change Password',

                  border:  OutlineInputBorder(
                    borderRadius:  BorderRadius.circular(15),
                    borderSide:  BorderSide(),
                  ),
                ),
              ),
              SizedBox(height: 15,),
              ElevatedButton(onPressed: () async{
                await ps.updateData(passwordText!);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password Successfully Updated')));

              },
                  child: Center(
                    child: Text('update'),
                  ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('History',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w800),),

                  Row(children: [IconButton(icon: Icon(Icons.delete,size: 19,),onPressed: () async{await ps.deleteTimeData();},),IconButton(icon: Icon(Icons.refresh,size: 19,),onPressed: () async{await ps.fetchTimeData();},)],)
                ],
              ),
             Expanded(
                child: Obx((){
                 return ListView.builder(
                    itemCount: ps.timeList.length,
                    itemBuilder: (context,i){
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(child: Text('${i+1}     |   ${ps.timeList[i]['createdAt']}'),),
                      );
                    },);
                })
             )
            ],
          ),
        ),
      ),
    );
  }
}
