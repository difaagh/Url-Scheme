#import <Foundation/Foundation.h>
#import "USPRootListController.h"

@implementation USPRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
	}

	return _specifiers;
}

- (void)openPaypal {
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://paypal.com/paypalme/difaagh"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {return;}];
}

- (void)openGithub {
	UIApplication *application = [UIApplication sharedApplication];
	NSURL *URL = [NSURL URLWithString:@"https://github.com/difaagh/url-scheme"];
	[application openURL:URL options:@{} completionHandler:^(BOOL success) {return;}];
}

@end
