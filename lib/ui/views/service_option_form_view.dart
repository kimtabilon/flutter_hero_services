import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';
import 'package:heroservices/controllers/main_service_controller.dart';
import 'package:heroservices/controllers/navigation_controller.dart';
import 'package:heroservices/models/main_service_model.dart';
import 'package:heroservices/services/main_service.dart';
import 'package:heroservices/ui/views/service_category_view.dart';
import 'package:heroservices/ui/widgets/main_service/checkout_summary.dart';
import 'package:heroservices/ui/widgets/main_service/default_form_customer_widget.dart';
import 'package:heroservices/ui/widgets/main_service/default_form_schedule_widget.dart';
import 'package:heroservices/ui/widgets/main_service/service_option_form_widget.dart';
import 'package:heroservices/ui/widgets/shared/bottom_navigation_shared_widget.dart';
import 'package:heroservices/ui/widgets/shared/three_bounce_spinkit_shared_widget.dart';

class ServiceOptionFormView extends StatefulWidget {
  @override
  _ServiceOptionFormViewState createState() => _ServiceOptionFormViewState();
}

class _ServiceOptionFormViewState extends State<ServiceOptionFormView> {
  final PageController pageController = PageController();
  final PageController defaultPageController = PageController();
  bool defaultForm = false;

  @override
  Widget build(BuildContext context) {
    ServiceOptionModel serviceOption = Get.find<MainServiceController>().selectedServiceOption;

    return Scaffold(
      appBar: AppBar(
        title: Text(serviceOption.name),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Get.offAll(ServiceCategoryView());
          }
        ),

      ),
      //resizeToAvoidBottomPadding: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: GetBuilder<FormController>(
        builder: (ctrl) => FloatingActionButton.extended(
          label: Text(ctrl.currentForm+1 <= ctrl.totalForm+2 ? 'Next Step ${ctrl.currentForm+1} of ${ctrl.totalForm+2} ':'Done', style: TextStyle(fontSize: 20, color: Colors.white),),
          icon: Icon(Icons.arrow_forward_ios),
          backgroundColor: Color(0xff13869F),
          onPressed: () {
            String errorMsg = '';

            ctrl.requiredValues.forEach((key, value) {
              if(ctrl.formValues[key] == '') {
                errorMsg += errorMsg=='' ? key : ', '+key;
              }
              if(ctrl.defaultFormValues[key] == '') {
                errorMsg += errorMsg=='' ? key : ', '+key;
              }
            });

            if(errorMsg!='') {
              Get.find<NavigationController>().alert('Required Fields', errorMsg);
            } else {
              //set_default_form
              if(ctrl.currentForm >= ctrl.totalForm-1) {
                if(defaultForm) {
                  defaultPageController.nextPage(duration: Duration(milliseconds: 100), curve: Curves.easeIn);

                }
                setState(()=>defaultForm=true);
              } else {
                pageController.nextPage(duration: Duration(milliseconds: 100),
                    curve: Curves.easeIn);
              }
              //go to next page
              ctrl.setCurrentForm();

              //default form, schedule
              if(ctrl.currentForm == ctrl.totalForm) {
                ctrl.addDefaultFieldValue('Schedule', '');
                ctrl.addDefaultFieldValue('Hero', '');
                ctrl.addDefaultFieldValue('Price', '');
                /*ctrl.addDefaultFieldValue('heroId', '');
                ctrl.addDefaultFieldValue('Hero Name', '');
                ctrl.addDefaultFieldValue('Hero Address', '');
                ctrl.addDefaultFieldValue('Hero Rate', '');*/
                ctrl.addDefaultFieldValue('Total', '0');
                ctrl.addDefaultFieldValue('Timeline', '');
              }

              //default form, customer information
              if(ctrl.currentForm == ctrl.totalForm+1) {
                ctrl.addDefaultFieldValue('Customer Name', '');
                ctrl.addDefaultFieldValue('Customer Address', '');
              }

              //done, show checkout
              if(ctrl.currentForm >= ctrl.totalForm+2) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                            width: double.maxFinite,
                            child: CheckoutSummary()
                        ),
                      );
                    }
                );

              }
            }

          },

        ),
      ),
      bottomNavigationBar: BottomNavigationSharedWidget(),
      body: !defaultForm ? StreamBuilder(
          stream: MainService(serviceOptionId: serviceOption.serviceOptionId).serviceOptionForms,
          builder: (context, snapshot){
            if (snapshot.hasError) return Center(child: new Text('Error: ${snapshot.error}'));
            switch(snapshot.connectionState) {
              case ConnectionState.waiting:
                return SpinkitSharedWidget(type: 'ThreeBounce',);
              default:
                if (snapshot.data.length == 0) {
                  return Container(child: Center(child: Text('This service is not ready to use.')));
                }

                return PageView.builder( // Changes begin here
                    controller: pageController,
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.hasData ? snapshot.data.length : 0,
                    physics:new NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ServiceOptionFormWidget(
                            serviceOptionForm: snapshot.data[index],
                            totalForm: snapshot.data.length,
                      );
                    }
                );
            }
          }
      ) : PageView(
        controller: defaultPageController,
        physics:new NeverScrollableScrollPhysics(),
        children: [
          DefaultFormScheduleWidget(),
          DefaultFormCustomerWidget(),
        ],
      ),
    );
  }
}
