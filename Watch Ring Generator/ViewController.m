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
#import "NSFileManager+Utilities.h"
@import QuartzCore;
@import CoreGraphics;



NSString *const DefaultsKeyOuterForegroundColor				= @"DefaultsKeyOuterForegroundColor";
NSString *const DefaultsKeyOuterBackgroundColor				= @"DefaultsKeyOuterBackgroundColor";
NSString *const DefaultsKeyOuterSize						= @"DefaultsKeyOuterSize";
NSString *const DefaultsKeyOuterWidth						= @"DefaultsKeyOuterWidth";
NSString *const DefaultsKeyOuterProgress					= @"DefaultsKeyOuterProgress";

NSString *const DefaultsKeyInnerForegroundColor				= @"DefaultsKeyInnerForegroundColor";
NSString *const DefaultsKeyInnerBackgroundColor				= @"DefaultsKeyInnerBackgroundColor";
NSString *const DefaultsKeyInnerSize						= @"DefaultsKeyInnerSize";
NSString *const DefaultsKeyInnerWidth						= @"DefaultsKeyInnerWidth";
NSString *const DefaultsKeyInnerProgress					= @"DefaultsKeyInnerProgress";

NSString *const DefaultsKeyWatchSize						= @"DefaultsKeyWatchSize";

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
	
	//	load saved values
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
	if ([def stringForKey:DefaultsKeyOuterForegroundColor])
		self.outerForeground.text = [def stringForKey:DefaultsKeyOuterForegroundColor];
	if ([def stringForKey:DefaultsKeyOuterBackgroundColor])
		self.outerBackground.text = [def stringForKey:DefaultsKeyOuterBackgroundColor];
	if ([def stringForKey:DefaultsKeyInnerForegroundColor])
		self.innerForeground.text = [def stringForKey:DefaultsKeyInnerForegroundColor];
	if ([def stringForKey:DefaultsKeyInnerBackgroundColor])
		self.innerBackground.text = [def stringForKey:DefaultsKeyInnerBackgroundColor];

	if ([def objectForKey:DefaultsKeyOuterSize])
		self.outerRingSize.text = [def stringForKey:DefaultsKeyOuterSize];
	if ([def objectForKey:DefaultsKeyOuterWidth])
		self.outerRingWidth.text = [def stringForKey:DefaultsKeyOuterWidth];
	if ([def objectForKey:DefaultsKeyOuterProgress])
		self.outerRingProgress.text = [def stringForKey:DefaultsKeyOuterProgress];

	if ([def objectForKey:DefaultsKeyInnerSize])
		self.innerRingSize.text = [def stringForKey:DefaultsKeyInnerSize];
	if ([def objectForKey:DefaultsKeyInnerWidth])
		self.innerRingWidth.text = [def stringForKey:DefaultsKeyInnerWidth];
	if ([def objectForKey:DefaultsKeyInnerProgress])
		self.innerRingProgress.text = [def stringForKey:DefaultsKeyInnerProgress];
	
	if ([def integerForKey:DefaultsKeyWatchSize] == 42) {
		[self switchTo42mm:nil];
	}
	
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
	
	[self saveToDefaults:textField];
	
	if ([textField isEqual:self.outerForeground] ||
		[textField isEqual:self.outerBackground] ||
		[textField isEqual:self.innerForeground] ||
		[textField isEqual:self.innerBackground]) {
		
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
	
	[[NSUserDefaults standardUserDefaults] setInteger:38 forKey:DefaultsKeyWatchSize];
}

- (IBAction)switchTo42mm:(id)sender {
	
	self.watchScreenWidthConstraint.constant = 156;
	self.watchScreenHeightConstraint.constant = 195;
	[self.view layoutIfNeeded];

	self.watchFace.image = [UIImage imageNamed:@"bezel42mm"];
	self.watchApp.image = [UIImage imageNamed:@"paged42mm"];

	[[NSUserDefaults standardUserDefaults] setInteger:42 forKey:DefaultsKeyWatchSize];
}

- (IBAction)generateImages:(id)sender {

	NSString *folder = [NSDocumentsFolder() stringByAppendingPathComponent:@"img/"];
	NSLog(@"Destination folder: %@", folder);
	[NSFileManager findOrCreateDirectoryPath:folder];
	
	CGFloat op = [self.outerRingProgress.text doubleValue];
	CGFloat ip = [self.innerRingProgress.text doubleValue];
	
	BOOL (^imagegen)(M13ProgressViewRing *, NSString *, CGSize) = ^BOOL(M13ProgressViewRing *iv, NSString *filePath, CGSize size) {
		UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
		CGContextRef context = UIGraphicsGetCurrentContext();
		[iv.layer renderInContext:context];
		UIImage *stepImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		NSData *pngData = UIImagePNGRepresentation(stepImage);
		NSError *error = nil;
		[pngData writeToFile:filePath options:NSDataWritingFileProtectionNone error:&error];
		if (error) {
			NSLog(@"Error writing to file path = %@", filePath);
			UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Oops, error" message:[error description] preferredStyle:UIAlertControllerStyleAlert];
			[ac addAction:[UIAlertAction actionWithTitle:@"Grumpf" style:UIAlertActionStyleCancel handler:nil]];
			[self presentViewController:ac
							   animated:YES
							 completion:nil];
			return NO;
		}
		
		return YES;
	};
	
	BOOL success = YES;
	
	//	outer ring
	CGSize size = self.outerRing.bounds.size;
	NSInteger i = 0;
	[self.outerRing setProgress:i animated:NO];
	while (i < 100) {
		NSString *filePath = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"outer-%ld-%ld-%ld@2x.png", (long)size.width, (long)self.outerRing.progressRingWidth, i]];
		success = imagegen(self.outerRing, filePath, size);
		if (!success)
			break;
		i++;
		[self.outerRing setProgress:((float)i / 100.0) animated:NO];
	}
	[self.outerRing setProgress:op animated:NO];
	
	//	inner ring
	if (success) {
		size = self.innerRing.bounds.size;
		i = 0;
		[self.innerRing setProgress:i animated:NO];
		while (i < 100) {
			NSString *filePath = [folder stringByAppendingPathComponent:[NSString stringWithFormat:@"inner-%ld-%ld-%ld@2x.png", (long)size.width, (long)self.innerRing.progressRingWidth, i]];
			success = imagegen(self.innerRing, filePath, size);
			if (!success)
				break;
			i++;
			[self.innerRing setProgress:((float)i / 100.0) animated:NO];
		}
		[self.innerRing setProgress:ip animated:NO];
	}

	if (success) {
		UIAlertController *ac = [UIAlertController alertControllerWithTitle:nil message:@"Images generated with file name format: RING_id–SIZE_in_pt–WIDTH_in_pt–COUNTER into folder:" preferredStyle:UIAlertControllerStyleAlert];
		[ac addTextFieldWithConfigurationHandler:^(UITextField *textField) {
			textField.placeholder = @"Destination folder";
			textField.text = folder;
		}];
		[ac addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[ac addAction:[UIAlertAction actionWithTitle:@"Copy folder" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
			[[UIPasteboard generalPasteboard] setString:folder];
		}]];
		[self presentViewController:ac
						   animated:YES
						 completion:nil];
	}
}

- (void)saveToDefaults:(UITextField *)textField {
	
	NSUserDefaults *def = [NSUserDefaults standardUserDefaults];

	if ([textField isEqual:self.outerForeground]) {
		[def setObject:textField.text forKey:DefaultsKeyOuterForegroundColor];
	} else if ([textField isEqual:self.outerBackground]) {
		[def setObject:textField.text forKey:DefaultsKeyOuterBackgroundColor];
	} else if ([textField isEqual:self.innerForeground]) {
		[def setObject:textField.text forKey:DefaultsKeyInnerForegroundColor];
	} else if ([textField isEqual:self.innerBackground]) {
		[def setObject:textField.text forKey:DefaultsKeyInnerBackgroundColor];

	} else if ([textField isEqual:self.outerRingSize]) {
		[def setObject:textField.text forKey:DefaultsKeyOuterSize];
	} else if ([textField isEqual:self.outerRingWidth]) {
		[def setObject:textField.text forKey:DefaultsKeyOuterWidth];
	} else if ([textField isEqual:self.outerRingProgress]) {
		[def setObject:textField.text forKey:DefaultsKeyOuterProgress];
	} else if ([textField isEqual:self.innerRingSize]) {
		[def setObject:textField.text forKey:DefaultsKeyInnerSize];
	} else if ([textField isEqual:self.innerRingWidth]) {
		[def setObject:textField.text forKey:DefaultsKeyInnerWidth];
	} else if ([textField isEqual:self.innerRingProgress]) {
		[def setObject:textField.text forKey:DefaultsKeyInnerProgress];
	}
}

@end
