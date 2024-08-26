#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#include <roothide.h>
#import <rootless.h>

#define USP_VER_PLIST @"com.difaagh.urlscheme"
#define USP_VER_PLIST_WITH_PATH                                                \
  jbroot(@"/var/mobile/Library/Preferences/com.difaagh.urlscheme.plist")

@interface USPRootListController : PSListController {
  UILabel *_label;
  UILabel *_underLabel;
}
@end
