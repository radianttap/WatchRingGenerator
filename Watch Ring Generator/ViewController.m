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
#import "UIColor-Expanded.h"
@import QuartzCore;
@import CoreGraphics;

@interface ViewController () < UITextFieldDelegate >

@property (weak, nonatomic) IBOutlet UIButton *mm38button;
@property (weak, nonatomic) IBOutlet UIButton *mm42button;
@property (weak, nonatomic) IBOutlet UIImageView *watchFace;
@property (weak, nonatomic) IBOutlet UIImageView *watchApp;
@property (weak, nonatomic) IBOutlet UIView *watchScreen;

@property (weak, nonatomic) IBOutlet M13ProgressViewRing *innerRing;
@property (weak, nonatomic) IBOutlet M13ProgressViewRing *outerRing;

@property (weak, nonatomic) IBOutlet UIButton *outerBackgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *outerForegroundButton;
@property (weak, nonatomic) IBOutlet UITextField *outerRingSize;
@property (weak, nonatomic) IBOutlet UITextField *outerRingWidth;
@property (weak, nonatomic) IBOutlet UITextField *outerRingProgress;
@property (weak, nonatomic) IBOutlet UITextField *outerBackground;
@property (weak, nonatomic) IBOutlet UITextField *outerForeground;

@property (weak, nonatomic) IBOutlet UIButton *innerBackgroundButton;
@property (weak, nonatomic) IBOutlet UIButton *innerForegroundButton;
@property (weak, nonatomic) IBOutlet UITextField *innerRingSize;
@property (weak, nonatomic) IBOutlet UITextField *innerRingWidth;
@property (weak, nonatomic) IBOutlet UITextField *innerRingProgress;
@property (weak, nonatomic) IBOutlet UITextField *innerBackground;
@property (weak, nonatomic) IBOutlet UITextField *innerForeground;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchScreenWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchScreenHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *watchFaceYOffsetConstraint;

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

	CGFloat g = [self.outerRingProgress.text doubleValue];
	CGFloat s = [self.innerRingProgress.text doubleValue];
	[self setGroupProgress:g sessionProgress:s];
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
	
	self.outerBackgroundButton.backgroundColor = [UIColor colorWithHexString:self.outerBackground.text];
	self.outerForegroundButton.backgroundColor = [UIColor colorWithHexString:self.outerForeground.text];
	self.innerBackgroundButton.backgroundColor = [UIColor colorWithHexString:self.innerBackground.text];
	self.innerForegroundButton.backgroundColor = [UIColor colorWithHexString:self.innerForeground.text];
	
	self.outerRing.primaryColor = self.outerForegroundButton.backgroundColor;
	self.outerRing.secondaryColor = self.outerBackgroundButton.backgroundColor;
	self.innerRing.primaryColor = self.innerForegroundButton.backgroundColor;
	self.innerRing.secondaryColor = self.innerBackgroundButton.backgroundColor;
	
	[self.watchScreen setNeedsDisplay];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
	if ([textField isEqual:self.outerForeground] ||
		[textField isEqual:self.outerBackground] ||
		[textField isEqual:self.outerForeground] ||
		[textField isEqual:self.outerBackground]) {
		
		[self setupColors];
		return YES;
		
	} else if ([textField isEqual:self.outerRingProgress] ||
			   [textField isEqual:self.innerRingProgress]) {

		CGFloat g = [self.outerRingProgress.text doubleValue];
		CGFloat s = [self.innerRingProgress.text doubleValue];
		[self setGroupProgress:g sessionProgress:s];

		return YES;
	}
	
	[self setupSizes];
	return YES;
}

- (IBAction)switchTo38mm:(id)sender {

	self.watchScreenWidthConstraint.constant = 136;
	self.watchScreenHeightConstraint.constant = 170;
	[self.view layoutIfNeeded];

	self.watchFace.image = [UIImage imageNamed:@"bezel38mm"];
	self.watchApp.image = [UIImage imageNamed:@"paged38mm"];
}

- (IBAction)switchTo42mm:(id)sender {
	
	self.watchScreenWidthConstraint.constant = 156;
	self.watchScreenHeightConstraint.constant = 195;
	[self.view layoutIfNeeded];

	self.watchFace.image = [UIImage imageNamed:@"bezel42mm"];
	self.watchApp.image = [UIImage imageNamed:@"paged42mm"];
}



@end
