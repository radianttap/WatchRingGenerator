//
//  ViewController.m
//  Watch Ring Generator
//
//  Created by Aleksandar Vacić on 23.2.15..
//  Copyright (c) 2015. Radiant Tap. All rights reserved.
//

#import "ViewController.h"
//#import "M13ProgressViewSegmentedRing.h"
#import "M13ProgressViewRing.h"
@import QuartzCore;
@import CoreGraphics;

@interface ViewController () < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UIButton *mm38button;
@property (weak, nonatomic) IBOutlet UIButton *mm42button;
@property (weak, nonatomic) IBOutlet UIImageView *watchFace;
@property (weak, nonatomic) IBOutlet UIView *watchScreen;

@property (weak, nonatomic) IBOutlet M13ProgressViewRing *innerRing;
@property (weak, nonatomic) IBOutlet M13ProgressViewRing *outerRing;

@property (weak, nonatomic) IBOutlet UIButton *outerBackgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *outerForegroundButton;
@property (weak, nonatomic) IBOutlet UITextField *outerRingSize;
@property (weak, nonatomic) IBOutlet UITextField *outerRingWidth;
@property (weak, nonatomic) IBOutlet UITextField *outerRingSegments;

@property (weak, nonatomic) IBOutlet UIButton *innerBackgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *innerForegroundButton;
@property (weak, nonatomic) IBOutlet UITextField *innerRingSize;
@property (weak, nonatomic) IBOutlet UITextField *innerRingWidth;
@property (weak, nonatomic) IBOutlet UITextField *innerRingSegments;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchScreenWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchScreenHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *outerRingWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *innerRingWidthConstraint;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.outerRing.showPercentage = NO;
	self.innerRing.showPercentage = NO;

	[self setupColors];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self setupSizes];
	[self setGroupProgress:.3 sessionProgress:.7];
}

- (void)setGroupProgress:(CGFloat)groupProgress sessionProgress:(CGFloat)sessionProgress {
	
	[self.outerRing setProgress:groupProgress animated:YES];
	[self.innerRing setProgress:sessionProgress animated:YES];
}

- (void)setupSizes {
	
	self.outerRingWidthConstraint.constant = [self.outerRingSize.text doubleValue];
	self.innerRingWidthConstraint.constant = [self.innerRingSize.text doubleValue];
	[self.watchScreen layoutIfNeeded];

	dispatch_async(dispatch_get_main_queue(), ^{
		self.outerRing.backgroundRingWidth = [self.outerRingWidth.text doubleValue];
		self.outerRing.progressRingWidth = [self.outerRingWidth.text doubleValue];
		
		self.innerRing.backgroundRingWidth = [self.innerRingWidth.text doubleValue];
		self.innerRing.progressRingWidth = [self.innerRingWidth.text doubleValue];
		
		[self.outerRing setNeedsDisplay];
		[self.innerRing setNeedsDisplay];
	});
}

- (void)setupColors {
	
	self.outerRing.primaryColor = self.outerForegroundButton.backgroundColor;
	self.outerRing.secondaryColor = self.outerBackgroundButton.backgroundColor;
	self.innerRing.primaryColor = self.innerForegroundButton.backgroundColor;
	self.innerRing.secondaryColor = self.innerBackgroundButton.backgroundColor;
	
	[self.watchScreen setNeedsDisplay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	[self setupSizes];
	return YES;
}

- (IBAction)switchTo38mm:(id)sender {

	self.watchScreenWidthConstraint.constant = 272;
	self.watchScreenWidthConstraint.constant = 340;
	[self.view layoutIfNeeded];

	self.watchFace.image = [UIImage imageNamed:@"38mm.png"];
}

- (IBAction)switchTo42mm:(id)sender {
	
	self.watchScreenWidthConstraint.constant = 312;
	self.watchScreenWidthConstraint.constant = 390;
	[self.view layoutIfNeeded];

	self.watchFace.image = [UIImage imageNamed:@"42mm.png"];
}



@end
