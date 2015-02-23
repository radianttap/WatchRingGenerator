//
//  ViewController.m
//  Watch Ring Generator
//
//  Created by Aleksandar Vacić on 23.2.15..
//  Copyright (c) 2015. Radiant Tap. All rights reserved.
//

#import "ViewController.h"
#import "M13ProgressViewSegmentedRing.h"
@import QuartzCore;
@import CoreGraphics;

@interface ViewController () < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UIButton *mm38button;
@property (weak, nonatomic) IBOutlet UIButton *mm42button;
@property (weak, nonatomic) IBOutlet UIImageView *watchFace;
@property (weak, nonatomic) IBOutlet UIView *watchScreen;

@property (weak, nonatomic) IBOutlet M13ProgressViewSegmentedRing *innerRing;
@property (weak, nonatomic) IBOutlet M13ProgressViewSegmentedRing *outerRing;

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

	self.outerRing.numberOfSegments = 9;
	self.outerRing.progressRingWidth = 3.0;
	self.outerRing.showPercentage = NO;

	self.innerRing.numberOfSegments = 27;
	self.innerRing.progressRingWidth = 3.0;
	self.innerRing.showPercentage = NO;
	
	self.outerRing.segmentSeparationAngle = self.innerRing.segmentSeparationAngle;
	[self setupColors];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	[self setGroupProgress:3.0/9.0 sessionProgress:8.0/27.0];
}

- (void)setGroupProgress:(CGFloat)groupProgress sessionProgress:(CGFloat)sessionProgress {
	
	[self.outerRing setProgress:groupProgress animated:YES];
	[self.innerRing setProgress:sessionProgress animated:YES];
	
//	[self.view layoutIfNeeded];
}

- (void)setupColors {
	
	self.outerRing.primaryColor = self.outerForegroundButton.backgroundColor;
	self.outerRing.secondaryColor = self.outerBackgroundButton.backgroundColor;
	self.innerRing.primaryColor = self.innerForegroundButton.backgroundColor;
	self.innerRing.secondaryColor = self.innerBackgroundButton.backgroundColor;
	
	[self.watchScreen setNeedsDisplay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if ([textField isEqual:self.outerRingSize]) {
		self.outerRingWidthConstraint.constant = [textField.text doubleValue];
		
	} else if ([textField isEqual:self.outerRingWidth]) {
		self.outerRing.progressRingWidth = [textField.text doubleValue];

	} else if ([textField isEqual:self.outerRingSegments]) {
		self.outerRing.numberOfSegments = [textField.text integerValue];
		
	} else if ([textField isEqual:self.innerRingSize]) {
		self.innerRingWidthConstraint.constant = [textField.text doubleValue];

	} else if ([textField isEqual:self.innerRingWidth]) {
		self.innerRing.progressRingWidth = [textField.text doubleValue];
		
	} else if ([textField isEqual:self.innerRingSegments]) {
		self.innerRing.numberOfSegments = [textField.text integerValue];
		
	}
	
	self.outerRing.segmentSeparationAngle = self.innerRing.segmentSeparationAngle;
	[self.outerRing setNeedsDisplay];
	[self.innerRing setNeedsDisplay];
	[self.watchScreen layoutIfNeeded];
	
	return YES;
}

@end
