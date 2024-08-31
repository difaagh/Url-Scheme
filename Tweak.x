#import "Tweak.h"

BOOL isTweakEnabled;
static void loadPlist() {
	NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:USP_VER_PLIST_WITH_PATH];
	isTweakEnabled = [plist objectForKey:@"enable"] ? [[plist objectForKey:@"enable"] boolValue] : YES;
}
%ctor{
  loadPlist();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPlist, CFSTR("com.difaagh.urlscheme.settingschanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
