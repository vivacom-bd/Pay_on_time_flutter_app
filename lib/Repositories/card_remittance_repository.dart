import 'dart:convert';
import 'package:hidmona/Controllers/common_controller.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/active_card.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/card_details_screen.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/card_status.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/create_card_holder.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/create_personal_account.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/get_personal_account.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/get_title.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/personal_account_card.dart';
import 'package:hidmona/Models/Card%20Remittance%20System/supported_country.dart';
import 'package:hidmona/Repositories/api_response.dart';
import 'package:hidmona/Repositories/api_constants.dart';
import 'package:hidmona/Utilities/utility.dart';
import 'package:http/http.dart' as http;

class CardRemittanceRepository{

  ///CreatePersonalAccount
  static Future<APIResponse<PersonalAccount>> createPersonalAccount(int userId, String familyName, String givenName, String countryCode, String dob, String phoneNumber, String email) async{

    ///internet check
    if(!await Utility.isInternetConnected()){
      return APIResponse<PersonalAccount>(error: true, message: "Internet is not connected!");
    }

    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/create-personal-account');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "user_id" : userId,
          "family_name": familyName,
          "given_name": givenName,
          "country_code_alpha3": countryCode,
          "DOB": dob,
          "mobile_phone": phoneNumber,
          "email": email,

        })
    ).then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<PersonalAccount>(data: PersonalAccount.fromJson(jsonData));
      }
      return APIResponse<PersonalAccount>(error: true, message: jsonData["detail"]??"An error occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<PersonalAccount>(error: true, message: "An Error Occurred!");
    });
  }

  ///GetPersonalAccountDetails
  static Future<APIResponse<GetPersonalAccount>> getPersonalAccount(int start, int limit, int userId) async{

    ///internet check
    if(!await Utility.isInternetConnected()){
      return APIResponse<GetPersonalAccount>(error: true, message: "Internet is not connected!");
    }

    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/get-personal-account');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "start" : start,
          "limit": limit,
          "user_id": userId,
        })
    ).then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<GetPersonalAccount>(data: GetPersonalAccount.fromJson(jsonData));
      }
      return APIResponse<GetPersonalAccount>(error: true, message: jsonData["detail"]??"An error occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<GetPersonalAccount>(error: true, message: "An Error Occurred!");
    });
  }

  ///getTitle
  static Future<APIResponse<GetTitle>> getTitle(int start, int limit) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<GetTitle>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/get-title');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "start" : start,
          "limit" : limit,
        })
    )
        .then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<GetTitle>(data: GetTitle.fromJson(jsonData));
      }
      return APIResponse<GetTitle>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<GetTitle>(error: true, message: "An Error Occurred!");
    });
  }

  ///getTitle
  static Future<APIResponse<CreateCardHolder>> createCardHolder(
      int userId,
      int accountPK,
      int titlePK,
      String suffixName,
      String fName,
      String mName,
      String lName,
      String embossedName,
      String dob,
      String email,
      String userName,
      String clientRef,
      String countryCode,
      String phoneNumber,
      String aCountryAlpha3,
      String aCity,
      String aState,
      String aPostal,
      String aLine1,
      String aLine2,
      String sCountryAlpha3,
      String sCity,
      String sState,
      String sPostal,
      String sLine1,
      String sLine2,
      bool isPrimary,
      ) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<CreateCardHolder>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/create-card-holder');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "user_id" : userId,
          "account_pk" : accountPK,
          "title_pk": titlePK,
          "suffix_name": suffixName,
          "f_name": fName,
          "m_name": mName,
          "l_name": lName,
          "embossed_name": embossedName,
          "DOB": dob,
          "email": email,
          "username": userName,
          "client_ref": clientRef,
          "countrycode": countryCode,
          "phone_number": phoneNumber,
          "a_country_alpha3": aCountryAlpha3,
          "a_city": aCity,
          "a_state": aState,
          "a_postal": aPostal,
          "a_line1": aLine1,
          "a_line2": aLine2,
          "s_country_alpha3": sCountryAlpha3,
          "s_city": sCity,
          "s_state": sState,
          "s_postal": sPostal,
          "s_line1": sLine1,
          "s_line2": sLine2,
          "is_primary": isPrimary
        })
    )
        .then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<CreateCardHolder>(data: CreateCardHolder.fromJson(jsonData));
      }
      return APIResponse<CreateCardHolder>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<CreateCardHolder>(error: true, message: "An Error Occurred!");
    });
  }

  ///CardDetails
  static Future<APIResponse<CardDetails>> orderCard(int senderId, int cardHolderId) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<CardDetails>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/order-card');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "sender_id" : senderId,
          "card_holder_pk" : cardHolderId,
        })
    ).then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<CardDetails>(data: CardDetails.fromJson(jsonData));
      }
      return APIResponse<CardDetails>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<CardDetails>(error: true, message: "An Error Occurred!");
    });
  }

  ///getModeOfReceive
  static Future<APIResponse<PersonalAccountCard>> getPersonalCard(int start, int limit, int userId) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<PersonalAccountCard>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/get-personal-account-cards');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "start" : start,
          "limit" : limit,
          "user_id" : userId
        })
    )
        .then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<PersonalAccountCard>(data: PersonalAccountCard.fromJson(jsonData));
      }
      return APIResponse<PersonalAccountCard>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<PersonalAccountCard>(error: true, message: "An Error Occurred!");
    });
  }

  ///statusCheck
  static Future<APIResponse<CardStatus>> cardStatusCheck(int senderId, int cardHolderId) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<CardStatus>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/card-status');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "sender_id" : senderId,
          "card_holder_pk" : cardHolderId,
        })
    )
        .then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<CardStatus>(data: CardStatus.fromJson(jsonData));
      }
      return APIResponse<CardStatus>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<CardStatus>(error: true, message: "An Error Occurred!");
    });
  }

  ///statusCheck
  static Future<APIResponse<CardActivate>> activeCard(int senderId, int cardHolderId) async{
    if(!await Utility.isInternetConnected()){
      return APIResponse<CardActivate>(error: true, message: "Internet is not connected!");
    }
    Uri url = Uri.parse(baseAPIUrl()+'card_remittance/activate-card');
    return http.post(
        url,
        headers: headersWithAuth,
        body: json.encode({
          "sender_id" : senderId,
          "card_holder_pk" : cardHolderId,
        })
    )
        .then((data){
      print(data.body);
      final responseData = utf8.decode(data.bodyBytes);
      final jsonData = json.decode(responseData);
      if(data.statusCode == 200){
        return APIResponse<CardActivate>(data: CardActivate.fromJson(jsonData));
      }
      return APIResponse<CardActivate>(error: true, message: jsonData["detail"]??"An Error Occurred");
    }).catchError((onError){
      print(onError);
      return APIResponse<CardActivate>(error: true, message: "An Error Occurred!");
    });
  }


}