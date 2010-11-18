//
//  istingerprojectAppDelegate.m
//  istingerproject
//
//  Created by UTBM on 18/11/10.
//  Copyright Nicolas Beaudrot 2010. All rights reserved.
//

#import "istingerprojectAppDelegate.h"

@implementation istingerprojectAppDelegate

@synthesize window;
@synthesize tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	[[ConnexionManager sharedConnexion] connect];
    [window addSubview:[tabBarController view]];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler {
	
	if (fabsf(aceler.x) < 1.5 || fabsf(aceler.y) < 1.5 || fabsf(aceler.z) < 1.5) {
		NSLog(@"Secousse");
	}
}

- (void)dealloc {
	[[ConnexionManager sharedConnexion] disconnect];
	[tabBarController release];
    [window release];
    [super dealloc];
}

@end
