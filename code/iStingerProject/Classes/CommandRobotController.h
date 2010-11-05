//
//  CommandRobotController.h
//  iStingerProject
//
//  Created by Meddle-Flocon on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnexionManager.h"


@interface CommandRobotController : NSObject {

}

+ (CommandRobotController *) sharedCommand; // pour que cette classe soit un singleton
-(id) init;
-(NSString *) goStraight;
-(NSString *) goRight;
-(NSString *) goLeft;
-(NSString *) moveBack;
-(NSString *) turnBack;
-(NSString *) stop;
-(void) response:(NSString *) message;

@end
