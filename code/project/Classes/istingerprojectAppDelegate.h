//
//  istingerprojectAppDelegate.h
//  istingerproject
//
//  Created by UTBM on 18/11/10.
//  Copyright Nicolas Beaudrot 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnexionManager.h"
#import "CommandRobotController.h"

@interface istingerprojectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

