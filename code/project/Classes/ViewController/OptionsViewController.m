//
//  OptionsViewController.m
//  iStingerProject
//
//  Created by UTBM on 14/10/10.
//  Copyright 2010 Nicolas Beaudrot. All rights reserved.
//

#import "OptionsViewController.h"

@implementation OptionsViewController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
	ipTextEdit.text = [[ConnexionManager sharedConnexion] host];
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0
					 target:self
					 selector: @selector(updateInterface)
					 userInfo:nil
					 repeats: YES];
	[self updateInterface];
}

- (void) updateInterface {
	if ([[ConnexionManager sharedConnexion] isConnected] == TRUE) {
		serverStatusLabel.text = @"Connected";
	} else {
		serverStatusLabel.text = @"Disconnected";
	}
}

-(IBAction) changeServer:(id)sender {
	NSString *ip = ipTextEdit.text;
	[[ConnexionManager sharedConnexion] setHost:ip];
	[[ConnexionManager sharedConnexion] disconnect];
	[[ConnexionManager sharedConnexion] connect];
}

-(IBAction) changeSpeed:(id)sender {
	int speed = (int) speedSlider.value;
	[[CommandRobotController sharedCommand] changeSpeed:speed];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];

}

- (void)dealloc {
	[timer invalidate];
    [super dealloc];
}


@end
