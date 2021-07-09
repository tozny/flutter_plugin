#import "FlutterPlugin.h"
#if __has_include(<plugin_tozny/plugin_tozny-Swift.h>)
#import <plugin_tozny/plugin_tozny-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "plugin_tozny-Swift.h"
#endif

@implementation FlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPlugin registerWithRegistrar:registrar];
}
@end
