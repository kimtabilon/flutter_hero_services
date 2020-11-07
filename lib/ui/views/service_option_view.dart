import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/service_option_tile_widget.dart';
import 'package:heroservices/ui/widgets/shared/divider_shared_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceOptionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServiceModel service = Get.find<MainServiceController>().selectedService;

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(
          child: Center(child: Text(service.name, style: TextStyle(fontSize: 20),)),
        ),
        SliverToBoxAdapter(child: DividerSharedWidget(),),
        StreamBuilder(
            stream: MainService(serviceId: service.serviceId).serviceOptions,
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
                      child: Center(child: Text('No option found')),
                    );
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        return ServiceOptionTileWidget(serviceOption: snapshot.data[index],);
                      },
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      )
                  );
              }
            }
        ),
        SliverToBoxAdapter(child: SizedBox(height: 30,),),
        SliverToBoxAdapter(
          child: OutlineButton(
            onPressed: () {
              Get.back();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('CLOSE'),
            ),
            color: Color(0xff13869F),
          ),
        ),
      ],
    );
  }
}
