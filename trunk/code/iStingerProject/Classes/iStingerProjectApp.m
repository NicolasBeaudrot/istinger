//
//  iStingerProjectAppDelegate.m
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright Nicolas Beaudrot 2010. All rights reserved.
//

#import "iStingerProjectApp.h"

@implementation iStingerProjectAppDelegate

@synthesize window, tabBarController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    

    [window addSubview:[tabBarController view]];
	[[ConnexionManager sharedConnexion] connect];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)dealloc {
	[[ConnexionManager sharedConnexion] disconnect];
    [tabBarController release];
	[window release];
    [super dealloc];
}


@end
