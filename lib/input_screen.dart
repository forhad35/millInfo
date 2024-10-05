import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mill_info/homeScreen.dart';
import 'package:mill_info/shared_value.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  var formKey = GlobalKey<FormState>();
  var inputDetails= TextEditingController();
  var inputPrice= TextEditingController();
  var inputDate= TextEditingController();
  var formKeyBalance = GlobalKey<FormState>();
  var inputDetailsBalance= TextEditingController();
  var inputID= TextEditingController();
  var inputBalance= TextEditingController();

  bool isAddBalance= false;
@override
  void initState() {
    // TODO: implement initState
  var date = DateTime.now();
  var shortedDate = DateFormat.yMMMEd().format(date);
  inputDate.text = shortedDate.toString();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("OUR MIL"),
        leading:IconButton(onPressed: ()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context)=>const HomeScreen()),ModalRoute.withName('/'),), icon: const Icon(Icons.arrow_back)),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.symmetric(horizontal: 5,vertical: 5),
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 5,vertical: 5),

        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              padding:EdgeInsets.only(right:MediaQuery.sizeOf(context).width*0.035,),
               width: MediaQuery.sizeOf(context).width,
              child: TextButton.icon(onPressed: (){
                if(isAddBalance){
                  setState(() {
                    isAddBalance= false;
                  });
                }else{
                  setState(() {
                    isAddBalance= true;
                  });
                }

              },
                icon: const Icon(Icons.edit,size: 15,),
                label: isAddBalance?const Text("Add Expenses"):const Text("Add balance"),
              ),
            ),
SizedBox(height: 10,),
           isAddBalance? Form(
             key: formKeyBalance,
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     SizedBox(
                       width: MediaQuery.sizeOf(context).width*0.40,
                       child: TextFormField(
                         controller: inputDate,
                         validator: (value){
                           if (value!.isEmpty){
                             return "input some value";
                           }
                           return null;
                         },

                         decoration: const InputDecoration(
                             hintText: "Enter Date",
                             border: OutlineInputBorder(
                             )
                         ),
                       ),
                     ),
                     const SizedBox(height: 10,),
                     SizedBox(
                       width: MediaQuery.sizeOf(context).width*0.40,
                       child: TextFormField(
                         controller: inputBalance,
                         validator: (value){
                           if (value!.isEmpty){
                             return "input some value";
                           }
                         },
                         keyboardType: TextInputType.number,
                         decoration: const InputDecoration(
                             hintText: "Enter Balance",
                             border: OutlineInputBorder(
                             )
                         ),
                       ),
                     ),
                   ],
                 ),
                 const SizedBox(height: 10,),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: [
                     SizedBox(
                       width: MediaQuery.sizeOf(context).width*0.40,
                       child: TextFormField(
                         controller: inputDetailsBalance,
                         validator: (value){
                           if (value!.isEmpty){
                             return " input some value";
                           }
                           return null;
                         },

                         decoration: const InputDecoration(
                             hintText: "Enter name",
                             border: OutlineInputBorder(
                             )
                         ),
                       ),
                     ),
                     const SizedBox(height: 10,),
                     //------------------------------------------------------ id text filed-----------------------------------------

                     SizedBox(
                       width: MediaQuery.sizeOf(context).width*0.40,
                       child: TextFormField(
                         controller: inputID,
                         validator: (value){
                           if (value!.isEmpty){
                             return " input some value";
                           }
                         },
                         keyboardType: TextInputType.number,
                         decoration: const InputDecoration(
                             hintText: "Enter ID",
                             border: OutlineInputBorder(
                             )
                         ),
                       ),
                     ),
                   ],
                 ),

               ],
             ),
           ):
           Form(
              key: formKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //------------------------------------------------------ date text filed-----------------------------------------

                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.40,
                        child: TextFormField(
                          controller: inputDate,
                          validator: (value){
                            if (value!.isEmpty){
                              return " input some value";
                            }
                            return null;
                          },

                          decoration: const InputDecoration(
                            hintText: "Enter Date",
                            border: OutlineInputBorder(
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10,),
                      //------------------------------------------------------ price text filed-----------------------------------------

                      SizedBox(
                        width: MediaQuery.sizeOf(context).width*0.30,
                        child: TextFormField(
                          controller: inputPrice,
                          validator: (value){
                            if (value!.isEmpty){
                              return " input some value";
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                              hintText: "Enter Price",
                              border: OutlineInputBorder(
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
//------------------------------------------------------ details text filed-----------------------------------------
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width*0.85,
                    child: TextFormField(
                      controller: inputDetails,
                      validator: (value){
                        if (value!.isEmpty){
                          return " input some value";
                        }
                      },
                      minLines: 2,
                      maxLines: 10,
                      decoration: const InputDecoration(
                          hintText: "Enter Details",
                          border: OutlineInputBorder(
                          )
                      ),
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 10,),

             OutlinedButton(onPressed: ()async{
               if(isAddBalance){
                 if(formKeyBalance.currentState!.validate()){
                   await FirebaseFirestore.instance.collection('millNames').doc(millId.$).collection('balance').add({
                     'time': inputDate.text,
                     'details':inputDetailsBalance.text,
                     'balance':inputBalance.text,
                     'id':inputID.text,
                     'dateTime':FieldValue.serverTimestamp()
                   }).then((value) =>Fluttertoast.showToast(msg: 'Successfully Added'));
                   inputDetailsBalance.clear();
                   inputBalance.clear();
                   inputID.clear();

                 }
               }else{
                 if(formKey.currentState!.validate()){
                   await FirebaseFirestore.instance.collection('millNames').doc(millId.$).collection('millData').add({
                     'time': inputDate.text,
                     'details':inputDetails.text,
                     'price':inputPrice.text,
                     'dateTime':FieldValue.serverTimestamp()
                   }).then((value) =>Fluttertoast.showToast(msg: 'Successfully Added'));
                   inputDetails.clear();
                   inputPrice.clear();
                 }
               }
             
           },
             style: ButtonStyle(
               shape: MaterialStateProperty.all(
                 RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(5.0),
                   side: const BorderSide(width: 3, color: Colors.black),
                 ),
               ),

             ),
             child: isAddBalance? Text("Add balance"): Text("Add Expenses"),
           ),

          ],
        ),
      ),
    );
  }
}
