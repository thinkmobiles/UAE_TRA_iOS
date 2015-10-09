//
//  main.m
//  TRA Smart Services
//
//  Created by Admin on 13.07.15.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

/*
#ifdef DEBUG
    #include <sys/ptrace.h>
#endif
*/

int main(int argc, char * argv[]) {
    @autoreleasepool {

/*
#ifdef DEBUG
    ptrace(PT_DENY_ATTACH, 0, 0, 0);
#endif
*/
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
