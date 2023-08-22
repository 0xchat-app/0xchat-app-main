import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:ox_common/navigator/navigator.dart';
import 'package:ox_localizable/ox_localizable.dart';
import 'package:chatcore/chat-core.dart';
import 'package:ox_theme/ox_theme.dart';


typedef OXObserverCallback = void Function(dynamic);

/// ### Module abstract class
///
/// Methods that must be overridden:
/// * moduleName
///
/// Some utility methods:
/// * setup: As the module's initialization method, modules can override it according to their needs and perform their own initialization tasks
/// * interfaces: External interface methods, methods that are meant to be used by other modules, should be placed in this Map.
/// ```dart
/// class YLZApp extends FlutterModule {
///
///   String get moduleName => 'ZApp';
///
///   @override
///   Map<String, Function> get interfaces => {
///     'navigateToZApp': navigateToZApp
///   };
///
///   void navigateToZApp(String zAppId) {...}
/// }
/// ```
abstract class OXFlutterModule {
  @protected

  /// module name
  String get moduleName;

  @mustCallSuper
  Future<void> setup() async {
    OXModuleService.registerFlutterModule(moduleName, this);
    await ThemeManager.registerTheme(moduleName, assetPath);
    await Localized.registerLocale(moduleName, assetPath);
    DB.sharedInstance.schemes.addAll(dbSchemes);
  }

  @protected
  bool get useTheme => true;

  @protected
  bool get useLocalized => true;

  @protected

  ///Theme file path
  String get assetPath => '$moduleName/assets';

  @protected

  /// External interface methods
  Map<String, Function> get interfaces => {};

  @protected

  /// Interface methods
  Map<String, Function> get _allInterfaces =>
      {"navigateToPage": navigateToPage}..addAll(interfaces);

  @protected

  /// External interface methods
  List<Type> get dbSchemes => [];

  /// Module listener, <eventName : List<observerHandle>>
  Map<String, List<OXObserverCallback>> observerMap = {};

  dynamic? navigateToPage(
      BuildContext context, String pageName, Map<String, dynamic>? params);

  /// Add listener
  void _addObserverHandle(
      {required String eventName, required OXObserverCallback handle}) {
    List<OXObserverCallback> observerHandleList = observerMap[eventName] ?? [];
    if (!observerHandleList.contains(handle)) {
      observerHandleList.add(handle);
      observerMap[eventName] = observerHandleList;
    }
  }

  /// remove listener
  void _removeObserverHandle(
      {required String eventName, required OXObserverCallback handle}) {
    List<OXObserverCallback> observerHandleList = observerMap[eventName] ?? [];
    if (observerHandleList.contains(handle)) {
      observerHandleList.remove(handle);
      observerMap[eventName] = observerHandleList;
    }
  }

  /// notify listeners
  void dispatchObserverEvent({required String eventName, dynamic data}) {
    List<OXObserverCallback> observerHandleList = observerMap[eventName] ?? [];
    observerHandleList.forEach((fn) => fn(data));
  }
}

abstract class OXModuleObserver {
  @protected
  void observerHandle({required String eventName, dynamic data});
}

class OXModuleService {
  static const MethodChannel _channel =
  const MethodChannel('ox_module_service');
  static Map<String, OXFlutterModule> _modules = {};

  static registerFlutterModule(String moduleName, OXFlutterModule module) {
    if (_modules[moduleName] == null) {
      _modules[moduleName] = module;
    }
  }

  /// Invoke module navigation
  static Future? pushPage(BuildContext context, String moduleName,
      String pageName, Map<String, dynamic>? params) {
    final module = _modules[moduleName];
    if (module == null) return null;
    Future? result = module.navigateToPage(context, pageName, params);
    if (result == null) {
      OXNavigator.pushPage(
          context,
              (context) => Scaffold(
            body: Center(
              child: Text("$moduleName.$pageName NOT FOUND"),
            ),
          ));
    }
    return result;
  }

  /// Invoke module interface
  static T? invoke<T>(
      String moduleName, String methodName, List<dynamic> positionalArguments,
      [Map<Symbol, dynamic>? namedArguments]) {
    final module = _modules[moduleName];
    if (module == null) return null;
    final func = module._allInterfaces[methodName];
    if (func != null) {
      try {
        return Function.apply(func, positionalArguments, namedArguments) as T?;
      } catch (e) {
        throw FlutterError.fromParts(<DiagnosticsNode>[
          ErrorSummary('OXModuleService.invoke Error.'),
          ErrorDescription(
            'Method call failed. Please check if the parameter format is correct',
          ),
          ErrorDescription(e.toString()),
        ]);
      }
    } else {
      throw FlutterError.fromParts(<DiagnosticsNode>[
        ErrorSummary('OXModuleService.invoke Error.'),
        ErrorDescription('Corresponding method not found:$moduleName.$methodName'),
      ]);
    }
  }

  /// Add listener
  static void addObserverHandle(
      {required String moduleName,
        required String eventName,
        required OXObserverCallback handle}) {
    final module = _modules[moduleName];
    module?._addObserverHandle(eventName: eventName, handle: handle);
  }

  /// remove listener
  static void removeObserverHandle(
      {required String moduleName,
        required String eventName,
        required OXObserverCallback handle}) {
    final module = _modules[moduleName];
    module?._removeObserverHandle(eventName: eventName, handle: handle);
  }

  /// notify listeners
  static void dispatchObserverEvent(
      {required String moduleName, required String eventName, dynamic data}) {
    final module = _modules[moduleName];
    module?.dispatchObserverEvent(eventName: eventName, data: data);
  }
}
