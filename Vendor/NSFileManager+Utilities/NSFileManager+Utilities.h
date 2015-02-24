/*
 Aleksandar Vacić, Radiant Tap
 http://radianttap.com/
 
 BSD License, Use at your own risk

 */

@import UIKit;

/*
 
 Provided by Apple
 
 NSHomeDirectory()			= YOUR_APP/
 NSTemporaryDirectory()		= YOUR_APP/tmp/
 
 */

// Path utilities
NSString *NSDocumentsFolder();
NSString *NSLibraryFolder();
NSString *NSBundleFolder();
NSString *NSDCIMFolder();
NSString *NSApplicationSupportFolder();

/*
 
 Original work by
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition

 */
@interface NSFileManager (Utilities)
+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path;
+ (NSString *) pathForDocumentNamed: (NSString *) fname;
+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname;

+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path;
+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext;
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext;

+ (NSArray *) filesInFolder: (NSString *) path;
@end



@interface NSFileManager (RadiantTap)

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path;
+ (BOOL)findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection;

@end
