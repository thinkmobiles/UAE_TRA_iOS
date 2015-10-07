//
//  ReverseSecure.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 07.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ReverseSecure.h"

@implementation ReverseSecure

#pragma mark -Detect JailBroken iPhone

+ (BOOL)isJailBroken
{
#ifdef TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    
    NSArray *paths = @[@"/bin/bash",
                       @"/usr/sbin/sshd",
                       @"/etc/apt",
                       @"/private/var/lib/apt/",
                       @"/Applications/Cydia.app"
                       ];
    for (NSString *path in paths) {
        if ([self fileExistsAtPath:path]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    FILE *pFile;
    pFile = fopen([path cStringUsingEncoding:[NSString defaultCStringEncoding]], "r");
    if (pFile == NULL) {
        return NO;
    }
    else
        fclose(pFile);
    return YES;
}

+ (BOOL)doCydia
{
    if ([[NSFileManager defaultManager]
         fileExistsAtPath: @"/Applications/Cydia.app"])
    {
        return YES;
    }
    return NO;
}

+ (BOOL)doShell {
    if (system(0)) {
        return YES;
    }
    return NO;
}

@end
