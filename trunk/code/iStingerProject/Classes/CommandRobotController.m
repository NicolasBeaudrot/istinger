//
//  CommandRobotController.m
//  iStingerProject
//
//  Created by Meddle-Flocon on 27/10/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CommandRobotController.h"


@implementation CommandRobotController

static CommandRobotController *sharedCommandRobot = nil; //pour stocker l’unique instanciation de l'objet CommandRobot.



-(id) init{
	[super init];
	return self;
}


/*Faire avancer le robot*/

- (NSString*) goStraight {	
	[[ConnexionManager sharedConnexion] send:@"mogo 1:45 2:45<CR>"];
	return [NSString stringWithFormat:@"mogo 1:45 2:45<CR>"];
	
}


-(NSString *) goRight{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:65 2:25<CR>"];
	return [NSString stringWithFormat:@"mogo 1:65 2:25<CR>"];
}

-(NSString *) goLeft{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:25 2:65<CR>"];
	return [NSString stringWithFormat:@"mogo 1:25 2:65<CR>"];
}

-(NSString *) moveBack{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:-45 2:-45<CR>"];
	return [NSString stringWithFormat:@"mogo 1:-45 2:-45<CR>"];
}

-(NSString *) turnBack{
	[[ConnexionManager sharedConnexion] send:@"mogo 1:55 2:-55<CR>"];
	return [NSString stringWithFormat:@"mogo 1:55 2:-55<CR>"];
}

-(NSString *) stop{
	[[ConnexionManager sharedConnexion] send:@"stop<CR>"];
	return [NSString stringWithFormat:@"stop<CR>"];
}

/*Fonction appelée lorsque le robot envoie un message*/
-(void) response:(NSString *) message {
	NSLog(message);
}

/*Pour instancier la classe comme un singleton*/
+ (CommandRobotController *) sharedCommand {
    if (sharedCommandRobot == nil) {
        sharedCommandRobot = [[super allocWithZone:NULL] init];
    }
    return sharedCommandRobot;
}



@end
