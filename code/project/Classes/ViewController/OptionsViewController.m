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
	portTextEdit.text = [[ConnexionManager sharedConnexion] getPort];
	ipTextEdit.returnKeyType = UIReturnKeyDone;
	ipTextEdit.delegate = self;
	portTextEdit.returnKeyType = UIReturnKeyDone;
	portTextEdit.delegate = self;
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0
					 target:self
					 selector: @selector(updateInterface)
					 userInfo:nil
					 repeats: YES];
	[self updateInterface];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void) updateInterface {
	if ([[ConnexionManager sharedConnexion] isConnected] == TRUE) {
		serverStatusLabel.text = @"Connected";
		connectButton.hidden = YES;
	} else {
		serverStatusLabel.text = @"Disconnected";
		connectButton.hidden = NO;
	}
}

-(IBAction) changeServer:(id)sender {
	NSString *ip = ipTextEdit.text;
	[[ConnexionManager sharedConnexion] setHost:ip];
	[[ConnexionManager sharedConnexion] disconnect];
	[[ConnexionManager sharedConnexion] connect];
}

-(IBAction) changePort:(id)sender {
	NSString *port = portTextEdit.text;
	[[ConnexionManager sharedConnexion] setPort:port];
	[[ConnexionManager sharedConnexion] disconnect];
	[[ConnexionManager sharedConnexion] connect];	
}

-(IBAction) connectAction:(id)sender {
	[[ConnexionManager sharedConnexion] connect];
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
