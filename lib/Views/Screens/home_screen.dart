import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:hidmona/Controllers/common_controller.dart';
import 'package:hidmona/Utilities/colors.dart';
import 'package:hidmona/Utilities/images.dart';
import 'package:hidmona/Utilities/size_config.dart';
import 'package:hidmona/Utilities/utility.dart';
import 'package:hidmona/Views/Screens/send_money_screen.dart';
import 'package:hidmona/Views/Widgets/country_item.dart';
import 'package:hidmona/Views/Widgets/dashboard_item.dart';
import 'package:hidmona/Views/Widgets/default_button.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = "/HomeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  CommonController controller = Get.find<CommonController>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                const SizedBox(height: 15,),
                Center(child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Image.asset(AppImage.getPath("logo"),width: SizeConfig.screenWidth*.4,),
                ),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    DashboardExploreItem(title: "Profile",subtitle: "See your profile here",iconName: "user",
                      onTap: (){
                        //Navigator.of(context).pushNamed(ProfileScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 10,),
                    DashboardExploreItem(title: "History",subtitle: "See your previous transactions",iconName: "history",
                      onTap: (){
                        //Navigator.of(context).pushNamed(TransactionHistoryScreen.routeName);
                      },
                    ),
                    const SizedBox(height: 10,),
                    DashboardExploreItem(title: "My Recipients",subtitle: "See your profile here",iconName: "users",
                      onTap: (){
                        //Navigator.of(context).pushNamed(MyBeneficiariesScreen.routeName);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Divider(thickness: 1,color: AppColor.defaultColor.withOpacity(.5),),
                const SizedBox(height: 15,),
                Center(
                  child: Text(
                    'Send Money',
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  decoration: BoxDecoration(
                    color: AppColor.dropdownBoxColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Obx((){
                    if(controller.serverCountries.isEmpty){
                      return SpinKitCircle(color: Get.theme.primaryColor,);
                    }else{
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'I\'m sending From',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7,),
                          InkWell(
                            onTap: (){
                              _openFromCountryPickerDialog();
                            },
                            child: Container(
                              height: 45,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.2),
                                borderRadius  : BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(padding: const EdgeInsets.only(left: 10),child: CountryItem(country: controller.countryFrom.value)),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 20) ,
                                      decoration: BoxDecoration(
                                        //color: AppColor.defaultColorLight,
                                        gradient: AppGradient.getColorGradient('default')
                                      ),
                                      child: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 30,)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Text(
                            'I\'m sending To',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 7,),
                          InkWell(
                            onTap: (){
                              _openCountryPickerDialog();
                            },
                            child: Container(
                              height: 45,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(.2),
                                borderRadius  : BorderRadius.circular(10),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: Container(padding: const EdgeInsets.only(left: 10),child: CountryItem(country: controller.countryTo.value)),
                                  ),
                                  Container(
                                      padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 20) ,
                                      decoration: BoxDecoration(
                                        //color: AppColor.defaultColorLight,
                                        gradient: AppGradient.getColorGradient('default')
                                      ),
                                      child: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 30,)
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30.0),
                          DefaultButton(
                            buttonText: "Continue", onTap: ()async{

                              Utility.showLoadingDialog();

                              bool isSuccessModeOfReceives = await controller.getModeOfReceives(controller.countryTo.value.isoCode!);
                              if(!isSuccessModeOfReceives){
                                Get.back();
                                return;
                              }

                              bool isSuccessModeOfPayments = await controller.getModeOfPayments(controller.countryTo.value.isoCode!);
                              if(!isSuccessModeOfPayments){
                                Get.back();
                                return;
                              }

                              controller.serverCountryFrom.value = controller.getServerCountryFromCountryCode(controller.countryFrom.value.isoCode!);
                              controller.serverCountryTo.value = controller.getServerCountryFromCountryCode(controller.countryTo.value.isoCode!);

                              bool value = await controller.updateCurrencies();

                              Get.back();

                              if(value){
                                Get.to(()=> SendMoneyScreen());
                              }
                            },
                          ),
                        ],
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

///for countryfrom
  void _openFromCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: AppColor.defaultColor),
      child: CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchCursorColor: AppColor.defaultColor,
        searchInputDecoration: const InputDecoration(hintText: 'Search By Country...'),
        isSearchable: true,
        title: const Text('Select country',textAlign: TextAlign.center,),
        onValuePicked: (Country country){
          controller.countryFrom.value = country;
        },
        itemBuilder: (Country country)=>CountryItem(country: country),
        itemFilter: (c) => controller.serverCountries.map((element) => element.countryCode).contains(c.isoCode),
        //itemFilter: (c) => ['AGO', 'AUS', 'AUT', 'BHR', 'BEL'].contains(c.iso3Code),
        //itemFilter: (c)=>commonSingleTon.getCountries().map((e) => e.countryCode).contains(c.iso3Code),
        // priorityList: [
        //   CountryPickerUtils.getCountryByIsoCode('TR'),
        //   CountryPickerUtils.getCountryByIsoCode('US'),
        // ],
      ),
    ),
  );

///for countryTo
  void _openCountryPickerDialog() => showDialog(
    context: context,
    builder: (context) => Theme(
      data: Theme.of(context).copyWith(primaryColor: AppColor.defaultColor),
      child: CountryPickerDialog(
        titlePadding: const EdgeInsets.all(8.0),
        searchCursorColor: AppColor.defaultColor,
        searchInputDecoration: const InputDecoration(hintText: 'Search By Country...'),
        isSearchable: true,
        title: const Text('Select country',textAlign: TextAlign.center,),
        onValuePicked: (Country country){
            controller.countryTo.value = country;
        },
        itemBuilder: (Country country)=>CountryItem(country: country),
        itemFilter: (c) => controller.serverCountries.map((element) => element.countryCode).contains(c.isoCode),
        //itemFilter: (c) => ['AGO', 'AUS', 'AUT', 'BHR', 'BEL'].contains(c.iso3Code),
        //itemFilter: (c)=>commonSingleTon.getCountries().map((e) => e.countryCode).contains(c.iso3Code),
        // priorityList: [
        //   CountryPickerUtils.getCountryByIsoCode('TR'),
        //   CountryPickerUtils.getCountryByIsoCode('US'),
        // ],
      ),
    ),
  );
}
































// import 'package:country_currency_pickers/country.dart';
// import 'package:country_currency_pickers/country_picker_dialog.dart';
// import 'package:country_currency_pickers/currency_picker_dropdown.dart';
// import 'package:country_currency_pickers/utils/utils.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:hidmona/Controllers/common_controller.dart';
// import 'package:hidmona/Utilities/colors.dart';
// import 'package:hidmona/Utilities/images.dart';
// import 'package:hidmona/Views/Screens/send_money_screen.dart';
// import 'package:hidmona/Views/Widgets/country_item.dart';
// import 'package:hidmona/Views/Widgets/country_item_for_recipient_details.dart';
// import 'package:hidmona/Views/Widgets/default_button.dart';
//
// class SelectRecipientScreen extends StatefulWidget {
//   static const String routeName = "/SelectRecipientScreen";
//   Country _selectformCountry;
//   SelectRecipientScreen(this._selectformCountry, {Key? key}) : super(key: key);
//
//   @override
//   _SelectRecipientScreenState createState() => _SelectRecipientScreenState();
// }
//
// class _SelectRecipientScreenState extends State<SelectRecipientScreen> {
//   Country _selectedCountry = CountryPickerUtils.getCountryByCurrencyCode('SE');
//   CommonController controller = Get.find<CommonController>();
//    Country ? _setformCountry;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Image.asset(AppImage.getPath("getStart_top"), height: 314,),
//               ),
//               const SizedBox(height: 20.0),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 15),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Hidmona',
//                       style: TextStyle(
//                         color: AppColor.defaultColorLight,
//                         fontFamily: 'AkayaTelivigala',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 50,
//                       ),
//                     ),
//                     Text(
//                       'Money Transfer',
//                       style: TextStyle(
//                         color: AppColor.defaultColorLight,
//                         fontFamily: 'AkayaTelivigala',
//                         fontWeight: FontWeight.bold,
//                         fontSize: 25,
//                       ),
//                     ),
//                     const SizedBox(height: 60.0),
//                     Expanded(
//                       child: Container(
//                         alignment: Alignment.bottomCenter,
//                         child: Obx((){
//                           if(controller.serverCountries.isEmpty){
//                             return SpinKitCircle(color: Get.theme.primaryColor,);
//                           }else{
//                             return Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               children: <Widget>[
//                                 Text(
//                                   'I\'m sending to',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     color: AppColor.textColor,
//                                     fontSize: 15.0,
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: 'Roboto',
//                                   ),
//                                 ),
//                                 const SizedBox(height: 7,),
//                                 InkWell(
//                                   onTap: (){
//                                     _openCountryPickerDialog();
//                                   },
//                                   child: Container(
//                                     height: 50,
//                                     clipBehavior: Clip.antiAlias,
//                                     decoration: BoxDecoration(
//                                       color: Colors.grey.withOpacity(.2),
//                                       borderRadius  : BorderRadius.circular(10),
//                                     ),
//                                     child: Row(
//                                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                                       children: [
//                                         Expanded(
//                                           child: Container(padding: const EdgeInsets.only(left: 10),child: CountryItemForRecipientDetails(country: _selectedCountry)),
//                                         ),
//                                         Container(
//                                             padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 20) ,
//                                             decoration: BoxDecoration(
//                                                 gradient: AppGradient.getColorGradient('default')
//                                             ),
//                                             child: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 30,)
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 30.0),
//                                 DefaultButton(buttonText: "Get Start", onTap: (){
//                                   Get.to(()=> PaymentProcessScreen(widget._selectformCountry, _selectedCountry));
//                                 },),
//                               ],
//                             );
//                           }
//                         }),
//                       ),
//                     ),
//                     const SizedBox(height: 40.0),
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   void _openCountryPickerDialog() => showDialog(
//     context: context,
//     builder: (context) => Theme(
//       data: Theme.of(context).copyWith(primaryColor: AppColor.defaultColor),
//       child: CountryPickerDialog(
//         titlePadding: const EdgeInsets.all(8.0),
//         searchCursorColor: AppColor.defaultColor,
//         searchInputDecoration: const InputDecoration(hintText: 'Search By Country...'),
//         isSearchable: true,
//         title: const Text('Select country',textAlign: TextAlign.center,),
//         onValuePicked: (Country country){
//           setState(() {
//             _selectedCountry = country;
//           });
//         },
//         itemBuilder: (Country country)=>CountryItemForRecipientDetails(country: country),
//         //itemFilter: (c) => (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode),
//         //itemFilter: (c) => ['AGO', 'AUS', 'AUT', 'BHR', 'BEL'].contains(c.iso3Code),
//         //itemFilter: (c)=>commonSingleTon.getCountries().map((e) => e.countryCode).contains(c.iso3Code),
//         // priorityList: [
//         //   CountryPickerUtils.getCountryByIsoCode('TR'),
//         //   CountryPickerUtils.getCountryByIsoCode('US'),
//         // ],
//       ),
//     ),
//   );
// }
// //PaymentProcessScreen(widget._selectformCountry, _selectedCountry));