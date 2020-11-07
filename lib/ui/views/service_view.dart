import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/service_tile_widget.dart';
import 'package:heroservices/ui/widgets/shared/divider_shared_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ServiceCategoryModel serviceCategory = Get.find<MainServiceController>().selectedServiceCategory;
    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        SliverToBoxAdapter(child: SizedBox(height: 15),),
        SliverToBoxAdapter(
          child: Center(child: Text(serviceCategory.name, style: TextStyle(fontSize: 20),)),
        ),
        SliverToBoxAdapter(child: DividerSharedWidget(),),
        StreamBuilder(
            stream: MainService(serviceCategoryId: serviceCategory.serviceCategoryId).services,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return SliverToBoxAdapter(
                  child: Container(child: Center(child: Text('Error: ${snapshot.error}'))),
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
                      child: Center(child: Text('No service found')),
                    );
                  }
                  return SliverList(
                      delegate: SliverChildBuilderDelegate((context, index){
                        return ServiceTileWidget(service: snapshot.data[index],);
                      },
                        childCount: snapshot.hasData ? snapshot.data.length : 0,
                      )
                  );
              }
            }
        ),
        SliverToBoxAdapter(
          child: SizedBox(height: 40,),
        )
      ],
    );
  }
}
