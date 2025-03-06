import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:get/get.dart';
import 'package:puthagam/data/handler/api_handler.dart';
import 'package:puthagam/data/handler/api_url.dart';
import 'package:puthagam/model/explore/get_explore_list_model.dart';
import 'package:puthagam/podcaster/modules/podcasts/controllers/podcasts_controller.dart';
import 'package:puthagam/screen/dashboard/home/home_controller.dart';
import 'package:http/http.dart' as http;
import 'package:puthagam/screen/dashboard/podcast/podcast_controller.dart';
import 'package:puthagam/utils/app_routes.dart';
import 'package:puthagam/utils/app_snackbar.dart';
import 'package:puthagam/utils/local_storage/local_storage.dart';
import 'package:puthagam/utils/network_info.dart';



 // HomeController con = Get.put(HomeController());

 getSearchListApi1() async {
 HomeController con = Get.put(HomeController());
//PodcastController con = Get.put(PodcastController());
  try {
    bool connection =
        await NetworkInfo(connectivity: Connectivity()).isConnected();
    if (connection) {
      await LocalStorage.getData();
      if (LocalStorage.token.toString() != "null" &&
          LocalStorage.token.toString().isNotEmpty &&
          LocalStorage.userId.toString() != "null" &&
          LocalStorage.userId.toString().isNotEmpty) {
        con.isConnected.value = true;
        con.searchLoader.value = true;
        
        con.searchBookList.clear();
        print("pproadcast${LocalStorage.token.toString()}");

        http.Response response = await ApiHandler.post(
            url: "${ApiUrls.baseUrl}Book/${LocalStorage.userId}",
            body: {
              "categoryId": "",
              "start": 0,
              "length": 50,
              "searchString": con.searchController.value.text.trim(),
              "subcategoryIds": "",
              "authorId": "",
              "sortBy": "",
              "isFinished": false,
             "isPodcast":false
              
            });
         //print("searchString${con.searchController.value.text.trim()}");
        var decoded = jsonDecode(response.body);

        if (response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 202 ||
            response.statusCode == 203 ||
            response.statusCode == 204) {
          var decoded = getExploreListModelFromJson(response.body);
         // print("searchcheck${decoded.data?.first.title}");
          Future.delayed(Duration(seconds: 0), () { 
             // print("delayesss${decoded.data?.first.title}");
            for (var element in decoded.data!) {
             //   print("faterdeenmnm${decoded.data?.first.title}");
            con.searchBookList.add(element);
           // print("onlyforcheck${con.searchBookList.length}");
             
          }
        //  Future.delayed(Duration(seconds: 10));
        });
          

          con.totalBooks.value = decoded.status!.totalRecords.toString();
          
           con.searchLoader.value = false;
           print("searcrchvaluefor${con.searchLoader.value}");
          con.searchLoader.value = false;
        } else if (response.statusCode == 401) {
          LocalStorage.clearData();
          con.searchLoader.value = false;
          Get.offAllNamed(AppRoutes.loginScreen);
          toast(decoded['status']['message'], false);
        } else {
          con.searchLoader.value = false;
          toast(decoded['status']['message'], false);
        }
      }
    } else {
      con.isConnected.value = false;
      con.searchLoader.value = false;
      toast("No Internet Connection!", false);
    }
  } catch (e) {
    con.searchLoader.value = false;
    // toast(e.toString(), false);
  }

 }
 