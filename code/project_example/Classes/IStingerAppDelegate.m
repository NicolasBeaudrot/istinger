//
//  IStingerAppDelegate.m
//  IStinger
//
//  Created by UTBM on 30/09/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "IStingerAppDelegate.h"
#import "RootViewController.h"


@implementation IStingerAppDelegate

@synthesize window;
@synthesize navigationController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Override point for customization after app launch    
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[navigationController release];
	[window release];
	[super dealloc];
}


@end

