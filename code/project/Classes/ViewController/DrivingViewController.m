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
	NSString *chaine = [[CommandRobotController sharedCommand] goStraight];
	NSLog(@"Command : %@", chaine);
}


- (IBAction) btnClicDown:(id)sender {
	NSString *chaine = [[CommandRobotController sharedCommand] moveBack];
	NSLog(@"Command : %@", chaine);
}

- (IBAction) btnClicLeft:(id)sender {
	NSString *chaine = [[CommandRobotController sharedCommand] goLeft];
	NSLog(@"Command : %@", chaine);
	
}

- (IBAction) btnClicRight:(id)sender {
	NSString *chaine = [[CommandRobotController sharedCommand] goRight];
	NSLog(@"Command : %@", chaine);
}

- (IBAction) btnClicStop:(id)sender {
	NSString *chaine = [[CommandRobotController sharedCommand] stop];
	NSLog(@"Command : %@", chaine);
}

@end
