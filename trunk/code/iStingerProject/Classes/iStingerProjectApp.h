//
//  iStingerProjectAppDelegate.h
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright Nicolas Beaudrot 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface iStingerProjectAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UITabBarController *tabBarController;	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;

@end

