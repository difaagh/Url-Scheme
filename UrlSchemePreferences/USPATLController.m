#import "USPATLController.h"
#import <Foundation/Foundation.h>

#define USP_APP_BUNDLE_KEY @"appBundle"

@implementation USPATLController
- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"App" target:self];
    NSArray *urlTypesArray =
        [[[NSBundle bundleWithIdentifier:[self specifier].identifier]
            infoDictionary] objectForKey:@"CFBundleURLTypes"];

    if ([urlTypesArray isKindOfClass:[NSArray class]]) {
      for (NSDictionary *urlType in urlTypesArray) {
        if ([urlType isKindOfClass:[NSDictionary class]]) {
          for (NSString *key in urlType) {
            id value = [urlType objectForKey:key];
            if ([key isEqualToString:@"CFBundleURLName"]) {
              PSSpecifier *specifier = [PSSpecifier
                  preferenceSpecifierNamed:[NSString stringWithFormat:@"%@: %@",
                                                                      key,
                                                                      value]
                                    target:self
                                       set:nil
                                       get:nil
                                    detail:nil
                                      cell:PSStaticTextCell
                                      edit:nil];
              [_specifiers addObject:specifier];
            } else if ([key isEqualToString:@"CFBundleURLSchemes"] &&
                       [value isKindOfClass:[NSArray class]]) {
              NSArray *urlSchemes = (NSArray *)value;
              NSUInteger index = 0;
              for (NSString *scheme in urlSchemes) {
                PSSpecifier *specifier = [PSSpecifier
                    preferenceSpecifierNamed:
                        [NSString stringWithFormat:@"%lu: %@",
                                                   (unsigned long)index, scheme]
                                      target:self
                                         set:nil
                                         get:nil
                                      detail:nil
                                        cell:PSStaticTextCell
                                        edit:nil];
                [_specifiers addObject:specifier];
                index++;
              }
            }
          }
        }
      }
    }
  }
  return _specifiers;
}
@end
