import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hidmona/Controllers/common_controller.dart';
import 'package:hidmona/Models/currency_conversion_details.dart';
import 'package:hidmona/Models/mode_of_receive.dart';
import 'package:hidmona/Models/sending_purpose.dart';
import 'package:hidmona/Repositories/api_response.dart';
import 'package:hidmona/Utilities/colors.dart';
import 'package:hidmona/Utilities/images.dart';
import 'package:hidmona/Views/Widgets/country_item.dart';
import 'package:hidmona/Views/Widgets/custom_dropdown_form_field.dart';
import 'package:hidmona/Views/Widgets/custom_text_form_field.dart';
import 'package:hidmona/Views/Widgets/default_button.dart';
import 'package:hidmona/Views/Widgets/sendmoneycalculationitem.dart';

class PaymentMethodScreen extends StatefulWidget {
  static const String routeName = "/PaymentMethodScreen";

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final _formKey = GlobalKey<FormState>();
  //final TextEditingController _amountTextEditingController = TextEditingController();
  Rx<double> inputAmount = 0.0.obs;
  ModeOfPayment? selectedModeOfReceive;
  CommonController commonController = Get.find<CommonController>();
  final controller = Get.put(CommonController());


  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          title: const Text("Send Money"),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppGradient.getColorGradient("default"),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      color: AppColor.dropdownBoxColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("I'm sending from", style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 5,),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 7),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: AppColor.defaultColorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: AppGradient.getColorGradient("default-horizontal")
                                    ),
                                    child: CountryItem(
                                        country: commonController.countryFrom.value, titleType: "iso3Code",),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("I'm sending to", style: TextStyle(
                                      color: AppColor.textColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),),
                                  const SizedBox(height: 5,),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: AppColor.defaultColorLight,
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: AppGradient.getColorGradient("default-horizontal")
                                    ),
                                    child: CountryItem(
                                        country: commonController.countryTo.value,  titleType: "iso3Code",),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        Container(
                          padding: const EdgeInsets.only(top: 15),
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Center(
                                child: Text(
                                  'Mode of Receive',
                                  style: TextStyle(
                                    color: AppColor.textColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 7,),
                              CustomDropDownFromField(
                                  validator: (value) {
                                    if (value == null) {
                                      return "Select Mode";
                                    }
                                    return null;
                                  },

                                  items: controller.modeOfReceives.map((ModeOfPayment modeOfReceive) {
                                    return DropdownMenuItem(
                                        value: modeOfReceive,
                                        child: Text(modeOfReceive.name!, style: const TextStyle(color: Colors.black, fontSize: 16.0),)
                                    );
                                  }).toList(),
                                  selectedValue: selectedModeOfReceive,
                                  labelAndHintText: "Select Mode",
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Icon(Icons.keyboard_arrow_down_rounded,color:Get.theme.primaryColor,size: 25,),
                                  ),
                                  filledColor: AppColor.dropdownBoxColor.withOpacity(0.5),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedModeOfReceive = value as ModeOfPayment;
                                    });
                                  }
                              ),
                            ],
                          ),
                        ),
                        
                        
                      ],
                    ),
                  ),


                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColor.dropdownBoxColor.withOpacity(0.3),
                    ),
                    child: Column(
                        children: [
                          CustomTextFormField(
                            controller: TextEditingController(),
                              validator: (value) {
                                double? input = double.tryParse(value??"");
                                if(input==null){
                                  return "Please enter correct format";
                                }
                                else if(input > 50000)
                                  {
                                    return "You can not send money more than 50000 ${commonController
                                        .countryFrom.value.currencyCode}";
                                  }
                                return null;
                              },
                              labelText: "Enter amount in ${commonController
                                  .countryFrom.value.currencyCode}",
                              hindText: "",
                              keyboardType: TextInputType.number,
                              onChanged: (value) {

                                WidgetsBinding.instance!.addPostFrameCallback((_) {
                                  inputAmount.value = double.tryParse(value as String)??0;
                                });

                              }
                          ),
                          const SizedBox(height: 20,),
                          Obx((){
                            if(inputAmount.value!=0){
                              return FutureBuilder(
                                future: commonController.getConversionDetails(inputAmount.value, commonController.countryFrom.value.isoCode!, commonController.countryTo.value.isoCode!),
                                builder: (context, AsyncSnapshot<APIResponse<CurrencyConversionDetails>> snapshot){

                                  if(snapshot.data!=null){
                                    APIResponse<CurrencyConversionDetails>? apiResponse = snapshot.data;

                                    if(apiResponse!.data != null){

                                      CurrencyConversionDetails currencyConversionDetails = apiResponse.data!;

                                      controller.currencyConversionDetails.value = currencyConversionDetails;

                                      return Column(
                                        children: [
                                          SendMoneyCalculationItem(
                                            iconPath: AppSvg.getPath("rate"),
                                            title: "Our Rate",
                                            value: "1  ${commonController.countryFrom.value.currencyCode} = ${currencyConversionDetails.ourRate!.toStringAsFixed(2)} ${commonController
                                                .countryTo.value.currencyCode}",
                                          ),
                                          const SizedBox(height: 10,),
                                          SendMoneyCalculationItem(
                                            iconPath: AppSvg.getPath("transfer"),
                                            title: "Transfer Fee",
                                            value: "${currencyConversionDetails.fees!.toStringAsFixed(2)} ${commonController.countryFrom.value.currencyCode}",
                                          ),
                                          const SizedBox(height: 10,),
                                          SendMoneyCalculationItem(
                                            iconPath: AppSvg.getPath("amount_to_send"),
                                            title: "Amount to send",
                                            value: "${currencyConversionDetails.amountToSend!.toStringAsFixed(2)} ${commonController
                                                .countryFrom.value.currencyCode}",
                                          ),
                                          const SizedBox(height: 10,),
                                          SendMoneyCalculationItem(
                                            iconPath: AppSvg.getPath("Amount_to_receive"),
                                            title: "Amount to receive",
                                            value: '${currencyConversionDetails.amountToReceive!.toStringAsFixed(2)} ${commonController
                                                .countryTo.value.currencyCode}',
                                          ),
                                          const SizedBox(height: 10,),
                                          SendMoneyCalculationItem(
                                            iconPath: AppSvg.getPath("Amount_to_receive"),
                                            title: "Total to pay",
                                            value: "${currencyConversionDetails.amountToPay!.toStringAsFixed(2)} ${commonController
                                                .countryFrom.value.currencyCode}",
                                          ),
                                        ],
                                      );
                                    }else{
                                      return Center(child: Text(apiResponse.errorMessage?? "An Error Occurred"));
                                    }

                                  }else{
                                    return SpinKitCircle(color: Get.theme.primaryColor,);
                                  }

                                },
                              );
                            }else{
                              return const Center(child: Text("Please enter correct format"));
                            }
                          }),
                          const SizedBox(height: 10,),
                        ],
                      ),
                  ),
                  //const SizedBox(height: 10.0,),

                  const SizedBox(height: 20,),
                  //const SizedBox(height: 80.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DefaultButton(
                      buttonText: "Send Money Now", onTap: () {

                    },),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
