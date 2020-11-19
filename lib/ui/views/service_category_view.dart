import 'package:flutter/material.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/widgets/main_service/featured_widget.dart';
import 'package:heroservices/ui/widgets/main_service/service_category_tile.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipPath(
          clipper: TriangleClipper(),
          child: Container(
            color: Color(0xff13869F),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/logo/logo-white-line.png', scale: 1.2,),
                Text('HERO',style: TextStyle(color: Colors.white, fontSize: 20),),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
        toolbarHeight: 135,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationSharedWidget(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("NEED SOMETHING?"),
                  SizedBox(height: 20,),
                  Text("Help is \non the way", style: TextStyle(fontSize: 40, color: Color(0xff13869F),),),
                  //Text("on the way", style: TextStyle(fontSize: 40, color: Color(0xff13869F),),),
                  SizedBox(height: 20,),
                  Text("OUR HEROES ARE HERE TO SAVE THE DAY"),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(height: 5, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0, bottom: 20.0),),
          ),
          StreamBuilder(
              stream: MainService().serviceCategories,
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
                        child: Center(child: Text('No service available.')),
                      );
                    }
                    return SliverToBoxAdapter(
                        child: Container(
                          height: 220,
                          color: Colors.grey[200],
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.hasData ? snapshot.data.length : 0,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 220,
                                width: 200,
                                child: ServiceCategoryTileWidget(serviceCategory: snapshot.data[index],),
                              );
                            },
                          ),
                        )
                    );
                }
              }
          ),
          SliverToBoxAdapter(
            child: Container(height: 5, width: double.infinity, color: Colors.grey, margin: const EdgeInsets.only(left: 10.0, right: 10.0, top: 20.0),),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 20, 30, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("FEATURED SERVICE", style: TextStyle(fontWeight: FontWeight.bold,)),
                ],
              ),
            ),
          ),
          FeaturedWidget(),
          SliverToBoxAdapter(child: SizedBox(height: 20,),),
        ],
      ),
    );
  }
}

class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height/1.4);
    path.quadraticBezierTo(
        size.width/2, size.height, size.width, (size.height/1.4));
    path.lineTo(size.width, 0);
    path.close(); // this closes the loop from current position to the starting point of widget
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}