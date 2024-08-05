#import <AltList/ATLApplicationListSubcontroller.h>
#import <Foundation/Foundation.h>
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface USPAppListController : ATLApplicationListSubcontroller
- (NSArray *)getValues:(PSSpecifier *)specifier;
- (NSArray *)getTitles:(PSSpecifier *)specifier;
@end
