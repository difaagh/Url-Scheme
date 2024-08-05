#import "USPAppListController.h"

@implementation USPAppListController {
  NSUserDefaults *prefs;

  NSMutableArray *lib_values;
  NSMutableArray *lib_titles;
}

- (NSArray *)getValues:(PSSpecifier *)specifier {
  return [lib_values copy];
}

- (NSArray *)getTitles:(PSSpecifier *)specifier {
  return [lib_titles copy];
}

- (instancetype)init {
  return self;
}
@end
