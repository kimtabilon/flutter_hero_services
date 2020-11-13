import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/smart_tiles/heroes_smart_tile.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceHeroesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;
    Map defaultFormValues = Get.find<FormController>().defaultFormValues;
    //print(serviceOption.serviceOptionId);
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: Text('HEROES'+' • '+serviceOption.name, style: TextStyle(fontSize: 20),)),
          ),
        ),
        StreamBuilder(
            stream: MainService(
              serviceOptionId: serviceOption.serviceOptionId,
              filterCity: serviceOption.filterCity,
              clientCity: defaultFormValues['Customer City'],
              filterProvince: serviceOption.filterProvince,
              clientProvince: defaultFormValues['Customer Province'],
            ).serviceHeroes,
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
                      child: Center(child: Text('No heroes found')),
                    );
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        return HeroesSmartTile(heroService: snapshot.data[index],);
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
              child: Text('DONE'),
            ),
            color: Color(0xff13869F),
          ),
        ),
      ],
    );

  }
}
