#import "USPRootListController.h"
#import <spawn.h>

@implementation USPRootListController

- (NSArray *)specifiers {
  if (!_specifiers) {
    _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
  }

  return _specifiers;
}

- (void)headerCell {
  @autoreleasepool {
    UIView *headerView =
        [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 140)];
    int width = [[UIScreen mainScreen] bounds].size.width;
    CGRect frame = CGRectMake(0, 20, width, 60);
    CGRect botFrame = CGRectMake(0, 55, width, 60);

    _label = [[UILabel alloc] initWithFrame:frame];
    [_label setNumberOfLines:1];
    _label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:35];
    [_label setText:@"Url Scheme"];
    [_label setBackgroundColor:[UIColor clearColor]];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.alpha = 1;

    _underLabel = [[UILabel alloc] initWithFrame:botFrame];
    [_underLabel setNumberOfLines:4];
    _underLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [_underLabel setBackgroundColor:[UIColor clearColor]];
    _underLabel.textColor = [UIColor grayColor];
    _underLabel.textAlignment = NSTextAlignmentCenter;
    _underLabel.alpha = 1;

    [headerView addSubview:_label];
    [headerView addSubview:_underLabel];

    [[self table] setTableHeaderView:headerView];
  }
}

- (void)openPaypal {
  UIApplication *application = [UIApplication sharedApplication];
  NSURL *URL = [NSURL URLWithString:@"https://paypal.com/paypalme/difaagh"];
  [application openURL:URL
                options:@{}
      completionHandler:^(BOOL success) {
        return;
      }];
}

- (void)openGithub {
  UIApplication *application = [UIApplication sharedApplication];
  NSURL *URL = [NSURL URLWithString:@"https://github.com/difaagh/url-scheme"];
  [application openURL:URL
                options:@{}
      completionHandler:^(BOOL success) {
        return;
      }];
}

/* read values from preferences */
- (id)readPreferenceValue:(PSSpecifier *)specifier {
  NSDictionary *dict =
      [NSDictionary dictionaryWithContentsOfFile:USP_VER_PLIST_WITH_PATH];
  id obj = [dict objectForKey:[[specifier properties] objectForKey:@"key"]];
  if (!obj) {
    obj = [[specifier properties] objectForKey:@"default"];
  }

  return obj;
}

/* set the value to preferences */
- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
  NSMutableDictionary *settings = [NSMutableDictionary
      dictionaryWithContentsOfFile:USP_VER_PLIST_WITH_PATH];
  if (!settings) {
    settings = [NSMutableDictionary dictionary];
  }
  [settings setObject:value forKey:specifier.properties[@"key"]];
  [settings writeToFile:USP_VER_PLIST_WITH_PATH atomically:YES];
  CFStringRef notificationName =
      (__bridge CFStringRef)specifier.properties[@"PostNotification"];
  if (notificationName) {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL,
        NULL, YES);
  }
}

/* restore settings */
- (void)defaultsettings:(PSSpecifier *)specifier {
  UIAlertController *alertController = [UIAlertController
      alertControllerWithTitle:@"Confirmation"
                       message:@"This will restore UrlScheme Settings to "
                               @"default\nAre you sure?"
                preferredStyle:UIAlertControllerStyleAlert];
  /* "yes" button */
  UIAlertAction *respringOk = [UIAlertAction
      actionWithTitle:@"Yes"
                style:UIAlertActionStyleDefault
              handler:^(UIAlertAction *action) {
                [[NSFileManager defaultManager]
                    removeItemAtURL:[NSURL
                                        fileURLWithPath:USP_VER_PLIST_WITH_PATH]
                              error:nil];
                [self reload];
                UIAlertController *alert = [UIAlertController
                    alertControllerWithTitle:@"Notice"
                                     message:
                                         @"Settings restored to "
                                         @"default\nPlease respring your device"
                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *DoneAction =
                    [UIAlertAction actionWithTitle:@"Respring"
                                             style:UIAlertActionStyleDefault
                                           handler:^(UIAlertAction *action) {
                                             [self respring];
                                           }];
                [alert addAction:DoneAction];
                [self presentViewController:alert animated:YES completion:nil];
              }];
  /* "no" button" */
  UIAlertAction *respringCancel =
      [UIAlertAction actionWithTitle:@"No"
                               style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction *action) {
                               return;
                             }];
  /* assign those actions to the buttons */
  [alertController addAction:respringOk];
  [alertController addAction:respringCancel];
  /* render the dialog */
  [self presentViewController:alertController animated:YES completion:nil];
  return;
}

- (void)loadView {
  [super loadView];
  [self headerCell];
}

- (void)respring {
  pid_t pid;
  const char *args[] = {"killall", "backboardd", NULL};
  posix_spawn(&pid, jbroot("/usr/bin/killall"), NULL, NULL, (char *const *)args,
              NULL);
}

@end
