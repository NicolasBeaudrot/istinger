//
//  DrivingViewController.m
//  iStingerProject
//

#import "DrivingViewController.h"
#import <CoreGraphics/CoreGraphics.h>


@implementation DrivingViewController
@synthesize cptSpeed;
@synthesize currentBattery;

static DrivingViewController *sharedDrivingView = nil; //pour stocker l’unique instanciation de l'objet


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
	
	
	//cptSpeed.transform = CGAffineTransformMakeRotation(70);
	//cptSpeed.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
	NSLog(@"Valeur de ma batterie : %f", currentBattery);
	
	cptSpeed.layer.anchorPoint = CGPointMake(0,1);
	cptSpeed.transform = CGAffineTransformRotate(cptSpeed.transform, degreesToRadians(-125));

//	CGAffineTransformMakeTranslation()
	/*cptSpeed.layer.anchorPoint = CGPointMake(0,1);
	cptSpeed.transform = CGAffineTransformRotate(cptSpeed.transform, degreesToRadians(-55));*/ 
	
	//cptSpeed.transform = CGAffineTransformRotate(cptSpeed.transform, 0);
	
	NSLog(@"current speeeeeeeeeeeeeeeeeeeeeeed: %d ", currentSpeed);
	
	[super viewDidLoad];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
	[cptSpeed release];

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

-(void) setBattery:(float)power{
	currentBattery = power;
}

-(float) getBattery{
	return currentBattery;
}

-(void) setSpeed:(int)speed{
	currentSpeed = speed;
	NSLog(@"--- setSpeed = %d", currentSpeed);
}

-(int) getSpeed {
	NSLog(@"*** getSpeed = %d", currentSpeed);
	return currentSpeed;
}

- (void) updateInterface {
	
	int vel;
	int rang, degre=0;
	float bat;
	bat = [self getBattery]; //on récupère currentBattery
	vel = [self getSpeed];	 //on récupère currentSpeed
	
	//la batterie est de 9,6V, on prends un rang de 2,4V et on affiche les images de la batterie
	if (bat	>= 0.0 && bat  <= 2.4) {
		imgPower.image = [UIImage imageNamed:@"baterie4.png"];
	} else if (bat > 2.4 && bat <= 4.8) {
		imgPower.image = [UIImage imageNamed:@"baterie3.png"];
	} else if (bat > 4.8 && bat <= 7.2) {
		imgPower.image = [UIImage imageNamed:@"baterie2.png"];
	} else if (bat > 7.2 && bat <= 9.6) {
		imgPower.image = [UIImage imageNamed:@"baterie1.png"];
	}	
	
	//on affecte un degré au compteur en fonction de la vitesse récupérée
	
	if (vel == vel2) { //si la vitesse est la même, on ne change pas le compteur
		NSLog(@"Vel sont égaux");
		NSLog(@"Vitesses : %d %d", vel, vel2);
	}
	else { // sinon on recalcule l'emplacement de l'aiguille
		NSLog(@"Vel sont PAS égaux"); 
		rang = vel / (16/3); 
		degre = rang * (25/3);
		NSLog(@"DEGREE %d",degre);
		cptSpeed.layer.anchorPoint = CGPointMake(0,1); 
		if (degre > 250){ //si on dépasse la vitesse maxi,on place l'aiguille sur le dernier chiffre du compteur
			cptSpeed.transform = CGAffineTransformRotate(cptSpeed.transform, degreesToRadians(250));
		}
		else {
			cptSpeed.transform = CGAffineTransformRotate(cptSpeed.transform, degreesToRadians(degre));
		}	
	}
		
	vel2 = vel;
	
}


/*Pour visualiser la vitesse sur le compteur*/
- (void) updateSpeed:(int)speed {
	
	float vel_metre_second, rounding;
	
	[self setSpeed:speed];
	
	/* on calcule la vitesse en mètres par secondes (v=d/t) avec le nombre de ticks retourné par le robot, le nombre de ticks par tour, 
	la circonférence d'une roue en cm, le paramètre L=50 du pid, le temps d'un loop en secondes.*/
	
	vel_metre_second = ((float) speed / 12.0) * 0.1995 / (50.0 * 0.0016); 
	rounding = ((float) ((int) (vel_metre_second*100))) / 100; // on arrondie
	
	speedLabel.text = [NSString stringWithFormat:@"%.2f m/s", rounding]; //on affiche

}

- (void) updateDistance:(int)distance {
	distanceLabel.text = [NSString stringWithFormat:@"%d", distance];
}


- (float) updatePower:(float)power {
	[self setBattery:power];
	return power;
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

/*Pour instancier la classe comme un singleton*/
+ (DrivingViewController *) sharedDriving {
    if (sharedDrivingView == nil) {
        sharedDrivingView = [[super allocWithZone:NULL] init];
    }
    return sharedDrivingView;
}


@end
