//
//  ReverseSecure.m
//  TRA Smart Services
//
//  Created by RomaVizenko on 07.10.15.
//  Copyright © 2015 Thinkmobiles. All rights reserved.
//

#import "ReverseSecure.h"

#include <sys/sysctl.h>

@implementation ReverseSecure

#pragma mark - Public

+ (BOOL)isJailBroken
{
    if ([self crackulousSignTest]) {
        return YES;
    }
    
    NSURL* url = [NSURL URLWithString:@"cydia://package/com.example.package"];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        return YES;
    }
    
    #ifdef TARGET_IPHONE_SIMULATOR
#ifdef DEBUG
    return NO;
#endif
    #else
    
    if ([self checkShell]) {
        return YES;
    }
    
    NSArray *paths = @[
                       @"/bin/bash",
                       @"/usr/sbin/sshd",
                       @"/etc/apt",
                       @"/private/var/lib/apt",
                       @"/bin/apt",
                       @"/usr/bin/sshd",
                       @"/etc/fstab"
                       ];
    for (NSString *path in paths) {
        if ([self fileExistsAtPath:path]) {
            return YES;
        }
    }
    
    return NO;
#endif
}

#pragma mark - Private

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    FILE *pFile;
    pFile = fopen([path cStringUsingEncoding:[NSString defaultCStringEncoding]], "r");
    if (pFile == NULL) {
        return NO;
    } else {
        fclose(pFile);
    }
    return YES;
}

+ (BOOL)checkShell
{
    if (system(0)) {
        return YES;
    }
    return NO;
}

+ (BOOL)crackulousSignTest
{
    NSBundle *bundle = [NSBundle mainBundle];
    NSDictionary *info = [bundle infoDictionary];
    if ([info valueForKey:@"SignerIdentity"]) {
        return YES;
    }
    return NO;
}

@end
