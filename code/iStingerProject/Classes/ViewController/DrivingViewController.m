//
//  DrivingViewController.m
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "DrivingViewController.h"


@implementation DrivingViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    [super dealloc];
}


- (IBAction) btnClicUp:(id)sender {
	NSLog(@"Button Up");
	NSString *chaine = [[CommandRobotController sharedCommand] goStraight];
	NSLog(@"Ici Driving : %@", chaine);

}


- (IBAction) btnClicDown:(id)sender {
	NSLog(@"Button Down");
	//com = [CommandRobotController alloc];
	NSString *chaine = [[CommandRobotController sharedCommand] moveBack];
	NSLog(@"Ici Driving : %@", chaine);
}

- (IBAction) btnClicLeft:(id)sender {
	NSLog(@"Button Left");
	//com = [CommandRobotController alloc];
	NSString *chaine = [[CommandRobotController sharedCommand] goLeft];
	NSLog(@"Ici Driving : %@", chaine);
	
}

- (IBAction) btnClicRight:(id)sender {
	NSLog(@"Button Right");
	//com = [CommandRobotController alloc];
	NSString *chaine = [[CommandRobotController sharedCommand] goRight];
	NSLog(@"Ici Driving : %@", chaine);
}

-(NSString *) string{
	return @"coucou toi";
}


@end
