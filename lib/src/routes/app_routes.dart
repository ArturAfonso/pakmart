

// ignore_for_file: constant_identifier_names

abstract final class AppRoutes {

  static const HOME = 'home';
  static const APP_INFO = 'app-info';
  static const CATEGORIES = 'categories';
  static const CATEGORY_DETAILS = 'category-details';
 //  static const LOGIN = 'login';
  static const DETAILS = 'details'; 
  static const INSTALLED = 'installed';
  static const INSTALLED_DETAILS = 'installed-details';
  static const PREFERENCES = 'preferences';


  static const homePath = '/';
  static const appInfoPath = '/app/:appId';
  static const categoriesPath = '/categories';
  static const categoryDetailsPath = ':categoryId';
//  static const loginPath = '/login';
  static const detailsPath = 'details/:id'; // Rota filha não precisa de '/' */
  static const installedPath = '/installed';
  static const installedDetailsPath = ':appId';
  static const preferencesPath = '/preferences';
  static const appIdParam = 'appId';
  static const categoryIdParam = 'categoryId';
}