import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroservices/controllers/form_controller.dart';

class MultiSelectChipFieldWidget extends StatefulWidget {
  @override
  _MultiSelectChipFieldWidgetState createState() => _MultiSelectChipFieldWidgetState();

  final List values;
  final String label;

  MultiSelectChipFieldWidget(this.values, this.label);
}

class _MultiSelectChipFieldWidgetState extends State<MultiSelectChipFieldWidget> {

  _buildChoiceList() {
    List<Widget> choices = List();
    List<String> selectedChoices = List();

    widget.values.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: GetBuilder<FormController>(
          builder: (controller){
            return ChoiceChip(
              label: Text(item),
              selected: controller.formValues[widget.label].contains(item),
              onSelected: (selected) {
                selectedChoices.contains(item)
                    ? selectedChoices.remove(item)
                    : selectedChoices.add(item);

                print(selectedChoices);

                Get.put<FormController>(FormController())
                    .addFieldValue(
                    widget.label,
                    selectedChoices.join(", ")
                );

                //print(selectedChoices.contains(item));

                //print(Get.find<FormController>().formValues[widget.label].contains(item));
              },
            );
          },
        ),
      ));
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
