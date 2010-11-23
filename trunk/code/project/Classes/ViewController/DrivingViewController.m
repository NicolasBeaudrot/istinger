//
//  DrivingViewController.m
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "DrivingViewController.h"


@implementation DrivingViewController

- (void)viewDidLoad {
	UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
    accel.delegate = self;
    accel.updateInterval = (1.0f/10.0f);
    
		
	timer = [NSTimer scheduledTimerWithTimeInterval:3.0
					 target:self
					 selector: @selector(updateInterface)
					 userInfo:nil
					 repeats: YES];
	prevMode = 0;
	prevDirection = 0;
	[[CommandRobotController sharedCommand] setDrivingView:self];
	
	[super viewDidLoad];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void) turnScreen:(int)mode {
	if (prevMode != mode) { //We only change the screen orientation when its necessary
		if (mode == 1) { //Horizontale mode
			btnUp.hidden = YES;
			btnDown.hidden = YES;
			btnRight.hidden = YES;
			btnLeft.hidden = YES;
			btnStop.hidden = YES;
			//drivingView.transform= CGAffineTransformMakeRotation(3.14/2);
		} else { //Vertical mode
			btnUp.hidden = NO;
			btnDown.hidden = NO;
			btnRight.hidden = NO;
			btnLeft.hidden = NO;
			btnStop.hidden = NO;
			//drivingView.transform= CGAffineTransformMakeRotation(0);
		}
		prevMode = mode;
	}
}

- (void) updateInterface {
	//TODO envoyer des demandes d'infos au serveur (vitesse, distance, ...)
	//[[CommandRobotController sharedCommand] getSpeed];
}

- (void) updateSpeed:(int)speed {
	speedLabel.text = [NSString stringWithFormat:@"%d", speed];
}

- (void) updateDistance:(int)distance {
	distanceLabel.text = [NSString stringWithFormat:@"%d", distance];
}

- (void) updatePower:(int)power {
	if (power == 0) {
		imgPower.image = [UIImage imageNamed:@"baterie1.png"];
	} else if (power == 1) {
		imgPower.image = [UIImage imageNamed:@"baterie2.png"];
	} else if (power == 2) {
		imgPower.image = [UIImage imageNamed:@"baterie3.png"];
	} else if (power == 3) {
		imgPower.image = [UIImage imageNamed:@"baterie4.png"];
	}
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
	// Get the current device angle
	float xx = -[acceleration x];
	float yy = [acceleration y];
	float zz = [acceleration z];
	float angle = atan2(yy, xx);
	
	if ( -1 < angle && angle < 1) {
		if (-1 < angle && angle < -0.2) {
			//Go left
			if (prevDirection != 1) {
				NSString *chaine = [[CommandRobotController sharedCommand] goLeft];
				NSLog(@"Command : %@", chaine);
			}
			prevDirection = 1;
		} else if (0.2 < angle && angle < 1) {
			//Go right
			if (prevDirection != 2) {
				NSString *chaine = [[CommandRobotController sharedCommand] goRight];
				NSLog(@"Command : %@", chaine);
			}
			prevDirection = 2;
		} else if (-1 < zz && zz < -0.2) {
			//Go straight
			if (prevDirection != 3) {
				NSString *chaine = [[CommandRobotController sharedCommand] goStraight];
				NSLog(@"Command : %@", chaine);
			}
			prevDirection = 3;
		} else if (0.2 < zz && zz < 1) {
			//Go back
			if (prevDirection != 4) {
				NSString *chaine = [[CommandRobotController sharedCommand] moveBack];
				NSLog(@"Command : %@", chaine);
			}
			prevDirection = 4;
		} else {
			//Stop
			if (prevDirection != 5) {
				NSString *chaine = [[CommandRobotController sharedCommand] stop];
				NSLog(@"Command : %@", chaine);
			}
			prevDirection = 5;
		}
		[self turnScreen:1];
	} else {
		[self turnScreen:0];
	}
	
}

@end
