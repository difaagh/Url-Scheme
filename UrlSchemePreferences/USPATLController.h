#import "USPAppListController.h"
#import "USPRootListController.h"
#import <AltList/ATLApplicationListSubcontrollerController.h>

#define USP_APP_KEY_0 @"CFBundleExecutable"
#define USP_APP_KEY_1 @"urlSchemes"
#define USP_APP_KEY_2 @"CFBundleURLSchemes"
#define USP_APP_KEY_DEFAULT @"default"
#define USP_APP_KEY_CUSTOM @"custom"

@interface USPATLController : USPRootListController
@end
