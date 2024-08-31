#import "USPATLController.h"

@implementation USPATLController
- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"App" target:self];
    NSArray *urlTypesArray =
        [[[NSBundle bundleWithIdentifier:[self specifier].identifier]
            infoDictionary] objectForKey:@"CFBundleURLTypes"];

    for (NSDictionary *urlTypeDict in urlTypesArray) {
      NSArray *urlschemes = [urlTypeDict objectForKey:@"CFBundleURLSchemes"];
      for (NSString *urlScheme in urlschemes) {
        PSSpecifier *urlSchemeText = [PSSpecifier
            preferenceSpecifierNamed:urlScheme
                              target:self
                                 set:@selector(setPreferenceValue:specifier:)
                                 get:@selector(readPreferenceValue:)
                              detail:nil
                                cell:PSEditTextCell
                                edit:nil];
        [_specifiers addObject:urlSchemeText];
      }
    }
  }
  return _specifiers;
}
- (NSDictionary *)loadSettings {
  return [NSDictionary dictionaryWithContentsOfFile:USP_VER_PLIST_WITH_PATH];
}

- (NSDictionary *)appSettingsForIdentifier:(NSString *)identifier {
  NSDictionary *settings = [self loadSettings];
  NSString *appExecName =
      [NSBundle bundleWithIdentifier:identifier].infoDictionary[USP_APP_KEY_0];
  return settings[appExecName];
}

- (NSArray *)urlSchemesArrayFromAppSettings:(NSDictionary *)appSettings {
  return [appSettings objectForKey:USP_APP_KEY_1];
}

- (NSArray *)urlSchemesFromURLTypeDict:(NSDictionary *)urlTypeDict {
  return [urlTypeDict objectForKey:USP_APP_KEY_2];
}

- (NSDictionary *)urlSchemeDictMatchingName:(NSString *)specifierName
                                  fromArray:(NSArray *)urlSchemesArray {
  for (NSDictionary *urlTypeDict in urlSchemesArray) {
    NSArray *urlSchemes = [self urlSchemesFromURLTypeDict:urlTypeDict];
    for (NSDictionary *urlDict in urlSchemes) {
      NSString *def = [urlDict objectForKey:USP_APP_KEY_DEFAULT];
      if ([specifierName isEqualToString:def]) {
        return urlDict;
      }
    }
  }
  return nil;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
  NSDictionary *appSettings =
      [self appSettingsForIdentifier:[self specifier].identifier];
  if (appSettings) {
    NSArray *urlSchemesArray =
        [self urlSchemesArrayFromAppSettings:appSettings];
    NSDictionary *urlSchemeDict =
        [self urlSchemeDictMatchingName:specifier.name
                              fromArray:urlSchemesArray];
    NSString *customScheme = [urlSchemeDict objectForKey:USP_APP_KEY_CUSTOM];
    return customScheme ?: nil;
  }
  return nil;
}
- (BOOL)isCloned {
  NSMutableDictionary *settings = [NSMutableDictionary dictionary];
  [settings
      addEntriesFromDictionary:
          [NSDictionary dictionaryWithContentsOfFile:USP_VER_PLIST_WITH_PATH]];
  for (NSDictionary *key in settings) {
    if ([settings[key] isKindOfClass:[NSDictionary class]] &&
        [settings[key][USP_APP_KEY_0]
            isEqualToString:[self specifier].identifier]) {
      return YES;
    }
  }
  return NO;
}
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *settings = [[self loadSettings] mutableCopy];
  if (!settings) {
    settings = [NSMutableDictionary dictionary];
  }

  if (![self isCloned]) {
    NSString *identifier = [self specifier].identifier;
    NSDictionary *appInfo =
        [NSBundle bundleWithIdentifier:identifier].infoDictionary;
    NSArray *urlTypesArray = [appInfo objectForKey:USP_APP_KEY_1];
    NSMutableArray *bundleUrlSchemesArray = [[NSMutableArray alloc] init];

    for (NSDictionary *urlTypeDict in urlTypesArray) {
      NSArray *urlSchemes = [self urlSchemesFromURLTypeDict:urlTypeDict];
      if (!urlSchemes) {
        continue;
      }

      NSMutableArray *urlDictArray = [[NSMutableArray alloc] init];
      for (NSString *url in urlSchemes) {
        if (url) {
          NSMutableDictionary *dictUrl = [NSMutableDictionary dictionary];
          [dictUrl setObject:url forKey:USP_APP_KEY_DEFAULT];
          [dictUrl setObject:@"" forKey:USP_APP_KEY_CUSTOM];
          [urlDictArray addObject:dictUrl];
        }
      }

      if ([urlDictArray count] > 0) {
        [bundleUrlSchemesArray addObject:@{USP_APP_KEY_2 : urlDictArray}];
      }
    }

    if ([bundleUrlSchemesArray count] > 0) {
      NSString *appExecName = [NSBundle bundleWithIdentifier:identifier]
                                  .infoDictionary[USP_APP_KEY_0];
      settings[appExecName] = [NSMutableDictionary dictionary];
      [settings[appExecName] setObject:bundleUrlSchemesArray
                                forKey:USP_APP_KEY_1];
    }
  } else {
    // TODO: Write value to custom
  }

  [settings writeToFile:USP_VER_PLIST_WITH_PATH atomically:YES];

  CFStringRef notificationName =
      (__bridge CFStringRef)specifier.properties[@"PostNotification"];
  if (notificationName) {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL,
        NULL, YES);
  }
}
@end
