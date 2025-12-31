import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeManager with ChangeNotifier {
  final darkTheme = ThemeData.dark(useMaterial3: false).copyWith(
    //    accentColor: const Color(0xff32334F),
    splashColor: Colors.white,
    primaryColor: const Color(0xfff23243B),
    secondaryHeaderColor: const Color(0xff32334F),
    //                  primaryColorLight: colorPalette.darkBlue,
    //                  primaryColorDark: colorPalette.darkBlue,
    unselectedWidgetColor: Colors.white,
    // selectedRowColor: const Color(0xff85FECD),
    scaffoldBackgroundColor: const Color(0xff000B38),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color(0xff3E75FD),
      textTheme: ButtonTextTheme.accent,
    ),
    //    buttonColor: const Color(0xff3E75FD),
    highlightColor: const Color(0xff001725),

    primaryColorDark: Color(0xff57DFBA),
    // Colors.white
    primaryColorLight: const Color(0xffc7dedd),
    indicatorColor: Colors.white,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(color: Colors.white),
      displayMedium: GoogleFonts.nunito(color: Colors.white),
      displaySmall: GoogleFonts.nunito(color: Colors.white),
      headlineLarge: GoogleFonts.nunito(color: Colors.white),
      headlineMedium: GoogleFonts.nunito(color: Colors.white),
      headlineSmall: GoogleFonts.nunito(color: Colors.white),
      titleLarge: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.nunito(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.nunito(color: Colors.white),
      bodyMedium: GoogleFonts.nunito(color: Colors.white),
      bodySmall: GoogleFonts.nunito(color: Colors.white, fontSize: 11),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all<Color>(const Color(0xff3E75FD)),
      // checkColor: MaterialStateProperty.all<Color>(const Color(0xff3E75FD)),
      shape: const CircleBorder(),
      side: BorderSide.none,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xff000B38),
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      ),
      textStyle: GoogleFonts.nunito(color: Colors.white, fontSize: 13),
      menuStyle: MenuStyle(
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Color(0xff23243B)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xff3E75FD),
        ),
        textStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.nunito(
            color: Colors.white,
            //                fontSize: 17.5,
          ),
        ),
        foregroundColor: WidgetStateProperty.all<Color?>(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        //            padding:
        //                MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(10)),
        backgroundColor: WidgetStateProperty.all<Color>(
          const Color(0xff3E75FD),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(32),
          ),
        ),
        //            backgroundColor:
        //                MaterialStateProperty.all<Color>(const Color(0xffC4C4C4)),
        textStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.nunito(
            color: Colors.black,
            //                fontSize: 17.5,
          ),
        ),
        // foregroundColor: MaterialStateProperty.all<Color?>(Colors.white),
        //            elevation: MaterialStateProperty.all<double>(0.0),
        //            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //              RoundedRectangleBorder(
        //                borderRadius: BorderRadius.circular(0.0),
        //                side: const BorderSide(color: Color(0xffC4C4C4)),
        //              ),
        //            ),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.white),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xffF8F9FA),),
        foregroundColor: WidgetStateProperty.all(Colors.white),
        iconColor: WidgetStateProperty.all(Colors.white),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: const Color(0xff32334F),
      clipBehavior: Clip.hardEdge,
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all<Color>(const Color(0xff57DFBA)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10),
      filled: true,
      fillColor: const Color(0xff000B38),

      labelStyle: TextStyle(color: const Color(0xff000B38)),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      disabledBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      isDense: true,
      //          errorBorder: OutlineInputBorder(
      //            borderSide: const BorderSide(color: Colors.redAccent, width: 3.0),
      //            borderRadius: BorderRadius.circular(0.0),
      //          ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dialogTheme: DialogThemeData(backgroundColor: const Color(0xff23243B)),
    tabBarTheme: TabBarThemeData(indicatorColor: Colors.white),
  );

  final lightTheme = ThemeData.light(useMaterial3: false).copyWith(
    splashColor: Color(0xffF8F9FA).withAlpha(100),
    primaryColor: Color(0xff1971c2),
    highlightColor: Color(0xff0080ff).withAlpha(100),
    primaryColorLight: const Color(0xffc7dedd),
    secondaryHeaderColor: Color(0xffADB5BD),
    colorScheme: ColorScheme.light(
      primary: const Color(0xff0080ff),
      secondary: const Color(0xffc3a100),
      secondaryContainer: const Color(0xffADB5BD),

    ),
    buttonTheme: const ButtonThemeData(buttonColor: Color(0xff0080ff)),
    unselectedWidgetColor: const Color(0xff6dbbfa),
    scaffoldBackgroundColor: Color(0xffF8F9FA),

    indicatorColor: Colors.black,
    textTheme: GoogleFonts.nunitoTextTheme().copyWith(
      displayLarge: GoogleFonts.nunito(color: Colors.black),
      displayMedium: GoogleFonts.nunito(color: Colors.black),
      displaySmall: GoogleFonts.nunito(color: Colors.black),
      headlineLarge: GoogleFonts.nunito(color: Colors.black),
      headlineMedium: GoogleFonts.nunito(color: Colors.black),
      headlineSmall: GoogleFonts.nunito(color: Colors.black),
      titleLarge: GoogleFonts.nunito(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 36,
      ),
      titleMedium: GoogleFonts.nunito(
        color: Color(0xff0080ff),
        fontWeight: FontWeight.bold,
      ),
      titleSmall: GoogleFonts.nunito(
        color: Color(0xff0080ff),
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyMedium: GoogleFonts.nunito(color: Colors.black, fontSize: 16),
      bodySmall: GoogleFonts.nunito(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w300,
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.all<Color>(
        Color(0xff0080ff).withAlpha(100),
      ),
      shape: const CircleBorder(),
      side: BorderSide.none,
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Color(0xfff1f3f2),
        filled: true,
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.5),
      ),
      textStyle: GoogleFonts.nunito(color: Colors.black, fontSize: 13),
      menuStyle: MenuStyle(
        surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
        backgroundColor: WidgetStatePropertyAll(Colors.white),
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: TextStyle(color: Color.fromARGB(255, 205, 141, 51)),
      unselectedLabelStyle: TextStyle(color: Colors.white),
      selectedIconTheme: IconThemeData(
        color: Color.fromARGB(255, 205, 141, 51),
        size: 20,
      ),
      unselectedIconTheme: IconThemeData(color: Colors.white, size: 20),
      selectedItemColor: Color.fromARGB(255, 205, 141, 51),
      unselectedItemColor: Colors.white,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Color(0xffF8F9FA),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Color(0xffF8F9FA)),
        textStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.nunito(
            color: Colors.black,
            //                fontSize: 17.5,
          ),
        ),
        foregroundColor: WidgetStateProperty.all<Color?>(Colors.white),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: WidgetStateProperty.all<TextStyle>(
          GoogleFonts.nunito(color: Color(0xff568685)),
        ),
      ),
    ),
    iconTheme: IconThemeData(color: Colors.black),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Color(0xffF8F9FA),),
        foregroundColor: WidgetStateProperty.all(Colors.black),
        iconColor: WidgetStateProperty.all(Colors.black),
      ),
    ),
    listTileTheme: ListTileThemeData(
      iconColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Color(0xff228BE6).withAlpha(25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all<Color>(Colors.black),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: EdgeInsets.all(10),
      hintStyle: GoogleFonts.nunito(
        color: Colors.grey,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.italic,
      ),
      filled: true,
      fillColor: const Color(0xfff1f3f2),
      border: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      disabledBorder: const OutlineInputBorder(
        // borderSide: BorderSide(color: Colors.grey, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide.none,
      ),
      isDense: true,

      //          errorBorder: OutlineInputBorder(
      //            borderSide: const BorderSide(color: Colors.redAccent, width: 3.0),
      //            borderRadius: BorderRadius.circular(0.0),
      //          ),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    dialogTheme: DialogThemeData(backgroundColor: Colors.white),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.white,
      rangePickerBackgroundColor: Colors.white,
    ),
  );

  late ThemeData _themeData;

  ThemeData getTheme() => _themeData;

  ThemeManager() {
    initiate();
  }

  void initiate() {
    //    StorageManager.readData('themeMode').then((value) {
    //      print('value read from storage: ' + value.toString());
    //      var themeMode = value ?? 'light';
    //     if (AuthStates.appUser != null) {
    //       if (AuthStates.appUser!.viewMode == ViewMode.Dark) {
    //         _themeData = darkTheme;
    //       } else {
    // //          print('setting dark theme');
    //         _themeData = lightTheme;
    //       }
    //     } else {
    //       _themeData = lightTheme;
    //     }
    _themeData = lightTheme;
    notifyListeners();
    //    });
  }

  // void setDarkMode() async {
  //   _themeData = darkTheme;
  //   GeneralUtils.firebaseFirestore
  //       .collection('users')
  //       .doc(AuthStates.appUser!.id)
  //       .update({'view_mode': 'dark'});
  //   AuthStates.appUser!.viewMode = ViewMode.Dark;
  //   notifyListeners();
  // }
  //
  // void setLightMode() async {
  //   _themeData = lightTheme;
  //   GeneralUtils.firebaseFirestore
  //       .collection('users')
  //       .doc(AuthStates.appUser!.id)
  //       .update({'view_mode': 'light'});
  //   AuthStates.appUser!.viewMode = ViewMode.Light;
  //   notifyListeners();
  // }
}
