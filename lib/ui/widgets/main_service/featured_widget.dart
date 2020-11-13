import 'package:flutter/material.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/smart_buttons/service_option_smart_button.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class FeaturedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: MainService().featured,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return SliverToBoxAdapter(
              child: Center(child: Text('Error: ${snapshot.error}')),
            );
          }
          switch(snapshot.connectionState) {
            case ConnectionState.waiting:
              return SliverToBoxAdapter(
                child: SpinkitSharedWidget(type: 'ThreeBounce',),
              );
            default:
              if (snapshot.data.length == 0) {
                return SliverToBoxAdapter(
                  child: Center(child: Text('No featured service.')),
                );
              }
              return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index){
                    ServiceOptionModel serviceOption = snapshot.data[index];
                    return ExpansionTile(
                      title: Text(serviceOption.name, style: TextStyle(color: Colors.black, fontSize: 18),),
                      subtitle: Text(serviceOption.description, style: TextStyle(color: Color(0xff333333)),),
                      leading: Icon(IconData(serviceOption.icon, fontFamily: 'MaterialIcons'), size: 50, color: Colors.black54,),
                      children: [
                        Container(
                          color: Colors.grey[100],
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 80, top: 10, bottom: 5, right: 20),
                                child: Wrap(
                                  children: [
                                    Text('Service Type • '+serviceOption.serviceType.toUpperCase()+' BASIS'),

                                    serviceOption.serviceType=='timeline'
                                    ?Text('Switch Timeline • You can switch hours or days.')
                                    :SizedBox.shrink(),

                                    Text('Booking Type • '+(serviceOption.multipleBooking?'Multiple Booking':'Single Booking')),

                                    serviceOption.serviceType=='quotation'
                                    ?Text('Pricing • '+(serviceOption.openPrice?'Open Price. Hero will set price.':'You can set price for quotation.'))
                                    :SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              Center(child: ServiceOptionSmartButton(serviceOption: serviceOption,)),
                              SizedBox(height: 10,),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                      ],
                    );
                  },
                    childCount: snapshot.hasData ? snapshot.data.length : 0,
                  )
              );
          }
        }
    );
  }
}
