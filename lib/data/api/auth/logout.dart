// logoutApi() async {
//   LoginController con = Get.put(LoginController());
//
//   try {
//     bool connection =
//     await NetworkInfo(connectivity: Connectivity()).isConnected();
//     if (connection) {
//
//       con.isLoading.value = true;
//       var token = awaitw getToken();
//       await Amplify.Auth.signIn(
//         username: con.emailController.value.text.trim(),
//         password: con.passwordController.value.text,
//       );
//       final user = await Amplify.Auth.getCurrentUser();
//       var body = {
//         "emailOrPhone": con.emailController.value.text,
//         "authKey": user.userId,
//         "deviceToken": token,
//         if(doSignup==true) "name":con.emailController.value.text.split("@")[0],
//         "deviceType": "android"
//       };
//
//       http.Response response = await ApiHandler.post(
//           url: ApiUrls.baseUrl + (doSignup==true? ApiUrls.signupUrl:ApiUrls.loginUrl), body: body);
//
//       if (response.statusCode == 200 ||
//           response.statusCode == 201 ||
//           response.statusCode == 202 ||
//           response.statusCode == 203 ||
//           response.statusCode == 204) {
//         var decoded = jsonDecode(response.body);
//         LocalStorage.storedToken(decoded['data'], true,
//             pass: con.passwordController.value.text);
//         con.isLoading.value = false;
//
//         var box = GetStorage();
//         await box.write(Prefs.socialLogin, false);
//         LocalStorage.socialLogin = false;
//         await getUserProfileApi();
//         HomeController hCon = Get.put(HomeController());
//         hCon.callAllApis();
//         Get.offAllNamed(AppRoutes.bottomBarScreen);
//       } else {
//         log("body ${response.body}");
//         var decoded = jsonDecode(response.body);
//         con.isLoading.value = false;
//         toast(decoded['status']['message'], false);
//       }
//     } else {
//       con.isLoading.value = false;
//       toast("No Internet Connection!", false);
//     }
//   } on UserNotConfirmedException {
//     con.isLoading.value = false;
//     toast("OTP send to your email please verify", true);
//     await Amplify.Auth.resendSignUpCode(
//       username: con.emailController.value.text.trim(),
//     );
//     askForVerifyOTP(con.emailController.value.text);
//   } on NotAuthorizedException {
//     con.isLoading.value = false;
//     toast("Incorrect username or password", false);
//   } on UserNotFoundException {
//     con.isLoading.value = false;
//     toast("User not found try register", false);
//   } catch (e) {
//     con.isLoading.value = false;
//     log("e ${e.toString()}");
//     // toast(e.toString(), false);
//     await isUserLoggedIn();
//   }
// }
