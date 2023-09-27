
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hidmona/Controllers/common_controller.dart';
import 'package:hidmona/Models/country_wise_bank.dart';
import 'package:hidmona/Models/recipient_bank.dart';
import 'package:hidmona/Models/sending_purpose.dart';
import 'package:hidmona/Models/transaction.dart';
import 'package:hidmona/Repositories/api_response.dart';
import 'package:hidmona/Repositories/common_repository.dart';
import 'package:hidmona/Repositories/payment_repository.dart';
import 'package:hidmona/Utilities/colors.dart';
import 'package:hidmona/Utilities/utility.dart';
import 'package:hidmona/Views/Screens/SendMoney/sending_confirmation_screen.dart';
import 'package:hidmona/Views/Widgets/custom_dropdown_form_field.dart';
import 'package:hidmona/Views/Widgets/custom_text_form_field.dart';
import 'package:hidmona/Views/Widgets/default_button.dart';

class TransactionBankInfoScreen extends StatefulWidget {
  static const String routeName = "/TransactionBankInfoScreen";

  const TransactionBankInfoScreen({Key? key}) : super(key: key);

  @override
  _TransactionBankInfoScreenState createState() => _TransactionBankInfoScreenState();
}

class _TransactionBankInfoScreenState extends State<TransactionBankInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController bankAddressTextEditingController = TextEditingController();
  // final TextEditingController branchNameTextEditingController = TextEditingController();

  CommonController commonController = Get.find<CommonController>();

  RecipientBank? recipientBank;
  RxList<RecipientBankBranch> recipientBankBranches = <RecipientBankBranch>[].obs;
  RecipientBankBranch? recipientBankBranch;
  bool isAccountNumberValidate = false;
  String accountNumber = "";

  @override
  void initState() {
    super.initState();

    commonController.selectedSendingPurpose = null;
    commonController.selectedCountryWiseBank = null;
    commonController.bankAccountTitleTextEditingController.text = commonController.selectedRecipient!.fullName! ?? "";
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          title: const Text("Recipient Details"),
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

                  const SizedBox(height: 10,),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sending Purpose',
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 7,),
                        CustomDropDownFromField(
                            validator: (value) {
                              if (value == null) {
                                return "Select Sending Purpose";
                              }
                              return null;
                            },

                            items: commonController.sendingPurposes.map((SendingPurpose sendingPurpose) {
                              return DropdownMenuItem(
                                  value: sendingPurpose,
                                  child: Text(sendingPurpose.name!, style: const TextStyle(color: Colors.black, fontSize: 16.0),)
                              );
                            }).toList(),
                            selectedValue: commonController.selectedSendingPurpose,
                            labelAndHintText: "Select Sending Purpose",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Icon(Icons.keyboard_arrow_down_rounded,color:Get.theme.primaryColor,size: 25,),
                            ),
                            filledColor: AppColor.dropdownBoxColor.withOpacity(0.5),
                            onChanged: (value) {

                              commonController.selectedSendingPurpose = value as SendingPurpose;

                            }
                        ),
                      ],
                    ),
                  ),
                  if(commonController.selectedModeOfReceive?.name!.toLowerCase() == "bank")const SizedBox(height: 15,),

                  if(commonController.selectedModeOfReceive?.name!.toLowerCase() == "bank")Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recipient Bank Info',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        child: Column(
                          children: [
                            CustomDropDownFromField(
                                validator: (value) {
                                  if (value == null) {
                                    return "Select Recipient Bank";
                                  }
                                  return null;
                                },

                                items: commonController.recipientBanks.map((RecipientBank bank) {
                                  return DropdownMenuItem(
                                      value: bank,
                                      child: Text(bank.bankName!, style: const TextStyle(color: Colors.black, fontSize: 16.0),)
                                  );
                                }).toList(),
                                selectedValue: recipientBank,
                                labelAndHintText: "Select Recipient Bank",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Icon(Icons.keyboard_arrow_down_rounded,color:Get.theme.primaryColor,size: 25,),
                                ),
                                filledColor: AppColor.dropdownBoxColor.withOpacity(0.5),
                                onChanged: (value) async{
                                  //if(recipientBank==null || recipientBank!.id != (value as RecipientBank).id){
                                  recipientBank = value as RecipientBank;
                                  commonController.bankNameTextEditingController.text = recipientBank!.bankName!;
                                  commonController.bankId = recipientBank!.id;
                                  Utility.showLoadingDialog();
                                  APIResponse<List<RecipientBankBranch>> apiResponse = await CommonRepository.getRecipientBankBranches(recipientBank!.id!);

                                  Get.back();
                                  if(apiResponse.data != null){
                                    recipientBankBranches.value = apiResponse.data!;
                                  }else{
                                    Utility.showSnackBar(apiResponse.message??"Branches retrieve failed!");
                                  }

                                  //}
                                }
                            ),
                            const SizedBox(height: 15,),
                            Obx((){
                              return CustomDropDownFromField(
                                  validator: (value) {
                                    // if (value == null) {
                                    //   return "Select Recipient Bank Branch";
                                    // }
                                    return null;
                                  },

                                  items: recipientBankBranches.map((RecipientBankBranch branch) {
                                    return DropdownMenuItem(
                                        value: branch,
                                        child: Text(branch.branchName!, style: const TextStyle(color: Colors.black, fontSize: 16.0),)
                                    );
                                  }).toList(),
                                  selectedValue: recipientBankBranch,
                                  labelAndHintText: "Select Recipient Bank Branch",
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(bottom: 4.0),
                                    child: Icon(Icons.keyboard_arrow_down_rounded,color:Get.theme.primaryColor,size: 25,),
                                  ),
                                  filledColor: AppColor.dropdownBoxColor.withOpacity(0.5),
                                  onChanged: (value) {

                                    recipientBankBranch = value as RecipientBankBranch;
                                    commonController.recipientBankBranch = recipientBankBranch!.branchName!;
                                    commonController.bankSwiftCodeTextEditingController.text = recipientBank!.swiftCode!;


                                    // branchNameTextEditingController.text = recipientBankBranch!.branchName!;

                                  }
                              );
                            }),
                          ],
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.dropdownBoxColor.withOpacity(0.3),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CustomTextFormField(
                            //     controller: bankNameTextEditingController,
                            //     validator: (value) {
                            //       if(value!.isEmpty){
                            //         return "Field can't be empty";
                            //       }
                            //       return null;
                            //     },
                            //     labelText: "Bank Name",
                            //     hindText: "",
                            //     keyboardType: TextInputType.text,
                            //     onChanged: (value) {
                            //
                            //     }
                            // ),
                            // const SizedBox(height: 10,),
                            CustomTextFormField(
                                controller: commonController.bankAccountTitleTextEditingController,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Field can't be empty";
                                  }else if(recipientBank!=null && recipientBank!.bankName == "DASHEN BANK"){
                                    if(value.length == 13){
                                      if(accountNumber!=value){
                                        accountNumber = value;
                                        checkAccountNumber(accountNumber);
                                      }

                                      if(!isAccountNumberValidate){
                                        return "Invalid account number";
                                      }

                                    }else{
                                      return "Account no. should be 13 digits";
                                    }
                                  }
                                  return null;
                                },
                                labelText: "Account Holder Name",
                                hindText: "",
                                keyboardType: TextInputType.text,
                                onChanged: (value) {

                                }
                            ),
                            const SizedBox(height: 10,),
                            CustomTextFormField(
                                controller: commonController.bankAccountNoTextEditingController,
                                //commonController.bankAccountTitleTextEditingController,
                                enabled:true,
                                validator: (value) {
                                  if(value!.isEmpty){
                                    return "Field can't be empty";
                                  }else if(recipientBank!=null && recipientBank!.bankName == "DASHEN BANK"){
                                    if(value.length == 13){
                                      if(accountNumber!=value){
                                        accountNumber = value;
                                        checkAccountNumber(accountNumber);
                                      }

                                      if(!isAccountNumberValidate){
                                        return "Invalid account number";
                                      }

                                    }else{
                                      return "Account no. should be 13 digits";
                                    }
                                  }
                                  return null;
                                },
                                labelText: "Bank Account No.",
                                hindText: "",
                                keyboardType: TextInputType.text,
                                onChanged: (value) {

                                }
                            ),
                            const SizedBox(height: 10,),
                            // CustomTextFormField(
                            //     controller: bankSwiftCodeTextEditingController,
                            //     validator: (value) {
                            //       // if(value!.isEmpty){
                            //       //   return "Field can't be empty";
                            //       // }
                            //       return null;
                            //     },
                            //     labelText: "Swift Code (Optional)",
                            //     hindText: "",
                            //     keyboardType: TextInputType.text,
                            //     onChanged: (value) {
                            //
                            //     }
                            // ),
                            // const SizedBox(height: 10,),
                            // CustomTextFormField(
                            //     controller: bankAddressTextEditingController,
                            //     validator: (value) {
                            //       if(value!.isEmpty){
                            //         return "Field can't be empty";
                            //       }
                            //       return null;
                            //     },
                            //     labelText: "Bank Address",
                            //     hindText: "",
                            //     keyboardType: TextInputType.text,
                            //     onChanged: (value) {
                            //
                            //     }
                            // ),
                            // const SizedBox(height: 10,),
                            // CustomTextFormField(
                            //     controller: branchNameTextEditingController,
                            //     validator: (value) {
                            //       if(value!.isEmpty){
                            //         return "Field can't be empty";
                            //       }
                            //       return null;
                            //     },
                            //     labelText: "Branch Name",
                            //     hindText: "",
                            //     keyboardType: TextInputType.text,
                            //     onChanged: (value) {
                            //
                            //     }
                            // ),
                            // const SizedBox(height: 5,),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if(commonController.selectedModeOfPayment?.id ==  3)const SizedBox(height: 15,),
                  if(commonController.selectedModeOfPayment?.id == 3)Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Payment Bank Info',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomDropDownFromField(
                                validator: (value) {
                                  if (value == null) {
                                    return "Select Payment Bank";
                                  }
                                  return null;
                                },

                                items: commonController.countryWiseBanks.map((CountryWiseBank countryWiseBank) {
                                  return DropdownMenuItem(
                                      value: countryWiseBank,
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.baseline,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Text(countryWiseBank.bankName!, style: const TextStyle(color: Colors.black, fontSize: 16.0),),
                                          Text(" (Acc no: ${countryWiseBank.bankAccountNumber!})", style: const TextStyle(color: Colors.black, fontSize: 12.0),),
                                        ],
                                      )
                                  );
                                }).toList(),
                                selectedValue: commonController.selectedCountryWiseBank,
                                labelAndHintText: "Select Payment Bank",
                                suffixIcon: Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Icon(Icons.keyboard_arrow_down_rounded,color:Get.theme.primaryColor,size: 25,),
                                ),
                                filledColor: AppColor.dropdownBoxColor.withOpacity(0.5),
                                onChanged: (value) {
                                  setState((){
                                    commonController.selectedCountryWiseBank = value as CountryWiseBank;
                                  });
                                }
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  if(commonController.selectedCountryWiseBank != null) const SizedBox(height: 20,),
                  if(commonController.selectedCountryWiseBank != null) Container(
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                        color: AppColor.defaultColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: Text("Payment Bank Information",style: TextStyle(fontSize: 17,fontWeight: FontWeight.w700),)),
                        Divider(color: AppColor.defaultColor,thickness: 2,),
                        SendDetailsItem(title: "Bank Name",value: "${commonController.selectedCountryWiseBank!.bankName}",),
                        Divider(color: AppColor.defaultColor,thickness: .5,),
                        SendDetailsItem(title: "Bank Account No",value: "${commonController.selectedCountryWiseBank!.bankAccountNumber}",),
                        Divider(color: AppColor.defaultColor,thickness: .5,),
                        SendDetailsItem(title: "Bank Account Title",value: "${commonController.selectedCountryWiseBank!.bankAccountTitle}",),
                        Divider(color: AppColor.defaultColor,thickness: .5,),
                        SendDetailsItem(title: "Branch Name",value: "${commonController.selectedCountryWiseBank!.branchName}",),
                        Divider(color: AppColor.defaultColor,thickness: .5,),
                        // SendDetailsItem(title: "Bank Address",value: "${commonController.selectedCountryWiseBank!.status}",),
                        // Divider(color: AppColor.defaultColor,thickness: .5,),
                        SendDetailsItem(title: "Country",value: "${commonController.selectedCountryWiseBank!.country!.name}",),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: DefaultButton(
                      buttonText: "Continue", onTap: () {
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState!.validate()){
                          if(commonController.selectedModeOfReceive!.id == 3) {
                            commonController.transactionRequestBodyForBank = TransactionRequestBodyforBank(

                              bankId: commonController.bankId,
                              bankAccountNo: commonController.bankAccountNoTextEditingController.text,
                              bankAccountTitle: commonController.bankAccountTitleTextEditingController.text,
                              bankSwiftCode: commonController.bankSwiftCodeTextEditingController.text,
                              payoutCurrency: commonController.serverCountryFrom.value.selectedCurrency!.code,
                              receivingCurrency: commonController.serverCountryTo.value.selectedCurrency!.code,
                              payoutAmount: commonController.currencyConversionDetails.value.data?.amountToSend,
                              receiverMethodId: commonController.selectedModeOfReceive!.id,
                              senderMethodId: commonController.selectedModeOfPayment!.id,
                              recipientId: commonController.selectedRecipient!.id,
                              senderCountryId: commonController.serverCountryFrom.value.id,
                              receiverCityId: commonController.recipientCity!.id,
                              receiverCountryId: commonController.selectedRecipient!.countryId!,
                              purposeId: commonController.selectedSendingPurpose!.id!,
                              bankName: commonController.bankNameTextEditingController.text,
                              branchName: commonController.recipientBankBranch,

                            );
                          } else{
                            commonController.transactionRequestBody = TransactionRequestBody(

                              bankId: commonController.bankId,
                              bankAccountNo: commonController.bankAccountNoTextEditingController.text,
                              bankAccountTitle: commonController.bankAccountTitleTextEditingController.text,
                              bankSwiftCode: commonController.bankSwiftCodeTextEditingController.text,
                              payoutCurrency: commonController.serverCountryFrom.value.selectedCurrency!.code,
                              receivingCurrency: commonController.serverCountryTo.value.selectedCurrency!.code,
                              payoutAmount: commonController.currencyConversionDetails.value.data?.amountToSend,
                              receiverMethodId: commonController.selectedModeOfReceive!.id,
                              senderMethodId: commonController.selectedModeOfPayment!.id,
                              recipientId: commonController.selectedRecipient!.id,
                              senderCountryId: commonController.serverCountryFrom.value.id,
                              receiverCityId: commonController.recipientCity!.id,
                              receiverCountryId: commonController.selectedRecipient!.countryId!,
                              purposeId: commonController.selectedSendingPurpose!.id!,
                              bankName: commonController.bankNameTextEditingController.text,
                              branchName: commonController.recipientBankBranch,

                            );
                          }




                           Get.to(const SendingMoneyConfirmationScreen());

                        }
                    },),
                  ),
                  const SizedBox(height: 15,)
                ],
              ),
            );
          }),
        ),
      ),
    );
  }


  checkAccountNumber(String accountNumber){
    print(accountNumber);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Utility.showLoadingDialog();
    });
    PaymentRepository.dashunBankAccountCheck(accountNumber).then((value){
      Get.back();
      if(value.data!=null){
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            isAccountNumberValidate=true;
            commonController.bankAccountTitleTextEditingController.text = value.data?.name??commonController.selectedRecipient!.fullName!;
          });
        });
      }else{
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          setState(() {
            isAccountNumberValidate=false;
            commonController.bankAccountTitleTextEditingController.text = commonController.selectedRecipient!.fullName!;
          });
        });
      }
    });
  }
}
