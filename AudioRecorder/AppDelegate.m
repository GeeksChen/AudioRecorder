//
//  AppDelegate.m
//  AudioRecorder
//
//  Created by Geeks_Chen on 2020/12/24.
//  Copyright © 2020 zezf. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self configAudioSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[ViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
    
}

- (void)configAudioSession {
    
    AVAudioSession *session = [AVAudioSession sharedInstance];

    NSError *error;
    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error]) {
       NSLog(@"Category Error: %@", [error localizedDescription]);
    }

    if (![session setActive:YES error:&error]) {
       NSLog(@"Activation Error: %@", [error localizedDescription]);
    }
}

@end
