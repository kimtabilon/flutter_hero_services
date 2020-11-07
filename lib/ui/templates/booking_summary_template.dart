import 'package:flutter/material.dart';

class BookingSummaryTemplate extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Map<String, String> formValues = {'Frequetly':'Daily', 'Package Type':'Box'};

    List values = formValues.values.toList(growable: false);
    List keys = formValues.keys.toList(growable: false);
    print(keys);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('BOOKING SUMMARY', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Delivery Hero', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),),
                              Text('20.20.09 | 8:00 am'),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('1000.00 PHP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                              Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ],
                      ),
                      Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: formValues.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            trailing: Text(values[i], style: TextStyle(fontWeight: FontWeight.bold),),
                            title: Text(keys[i], style: TextStyle(fontSize: 13),),
                          );
                        },
                      ),

                      Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),

                      Center(child: Text('CUSTOMER INFORMATION', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
                      Text('Name'),
                      Text('Kim Tabilon', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Address'),
                      Text('Binoongan, EV, Siquijor', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 10,),
                      Center(child: Text('HERO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),)),
                      Text('Name'),
                      Text('Kim Tabilon', style: TextStyle(fontWeight: FontWeight.bold),),
                      Text('Address'),
                      Text('Binoongan, EV, Siquijor', style: TextStyle(fontWeight: FontWeight.bold),),
                      Container(height: 0.4, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 0.0, right: 0.0, top: 20.0, bottom: 20.0),),
                      Center(
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(22.0) ),
                          onPressed: () {
                          },
                          child: Text('BOOK NOW', style: TextStyle(color: Colors.white),),
                          color: Color(0xff13869F),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
