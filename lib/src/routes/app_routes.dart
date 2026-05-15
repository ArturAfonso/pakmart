

// ignore_for_file: constant_identifier_names

abstract final class AppRoutes {

  static const HOME = 'home';
 //  static const LOGIN = 'login';
  static const DETAILS = 'details'; 
  static const SETTINGS = 'settings';


  static const homePath = '/';
//  static const loginPath = '/login';
  static const detailsPath = 'details/:id'; // Rota filha não precisa de '/' */
  static const settingsPath = '/settings';
}