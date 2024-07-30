#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import <substrate.h>

%hook SpringBoard

- (void)applicationDidFinishLaunching:(id)arg1 {
    %orig;

    NSString *appDirectory = @"/var/containers/Bundle/Application/";
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *appDirectories = [fileManager contentsOfDirectoryAtPath:appDirectory error:&error];

    if (error) {
        NSLog(@"Error listing apps: %@", error);
        return;
    }

    for (NSString *appDir in appDirectories) {
        NSString *appPath = [appDirectory stringByAppendingPathComponent:appDir];
        NSArray *contents = [fileManager contentsOfDirectoryAtPath:appPath error:&error];
        
        if (error) {
            NSLog(@"Error accessing directory: %@", error);
            continue;
        }

        for (NSString *file in contents) {
            if ([file hasSuffix:@".app"]) {
                NSString *infoPlistPath = [appPath stringByAppendingPathComponent:[file stringByAppendingPathComponent:@"Info.plist"]];
                NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];

                if (infoPlist) {
                    NSLog(@"App: %@", file);
                    NSLog(@"Info.plist: %@", infoPlist);
                } else {
                    NSLog(@"Error reading Info.plist for %@", file);
                }
            }
        }
    }
}

%end

