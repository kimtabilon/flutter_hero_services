import 'package:flutter/material.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/service_option_form_field_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceOptionFormWidget extends StatelessWidget {
  final ServiceOptionFormModel serviceOptionForm;
  final int totalForm;

  ServiceOptionFormWidget({this.serviceOptionForm, this.totalForm});

  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20,),
        Text(serviceOptionForm.name, style: TextStyle(fontSize: 20),),
        Text(serviceOptionForm.description),
        SizedBox(height: 20,),
        Flexible(
          child: StreamBuilder(
              stream: MainService(serviceOptionFormId: serviceOptionForm.serviceOptionFormId).serviceOptionFormFields,
              builder: (context, snapshot){
                if (snapshot.hasError) return Center(child: new Text('Error: ${snapshot.error}'));
                switch(snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return SpinkitSharedWidget(type: 'ThreeBounce',);
                  default:
                    if (snapshot.data.length == 0) {
                      return Text('Empty fields. This service is not ready to use.');
                    }
                    //return Text('has data');
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.hasData ? snapshot.data.length : 0,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(height: 10,),
                                Text(snapshot.data[index].hint),
                                ServiceOptionFormFieldWidget(serviceOptionFormField: snapshot.data[index],),
                              ],
                            ),
                            decoration: BoxDecoration(
                                border: new Border(
                                    bottom: new BorderSide(color: Colors.black26,)
                                )
                            ),
                          );
                        }
                    );
                }
              }
          ),
        ),
        SizedBox(height: 80,),
      ],
    );
  }
}
