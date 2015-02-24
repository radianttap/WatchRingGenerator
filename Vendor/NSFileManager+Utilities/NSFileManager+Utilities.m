/*
 
 Aleksandar Vacić, Radiant Tap
 http://radianttap.com/
 
 BSD License, Use at your own risk
 
 */

#import "NSFileManager+Utilities.h"

NSString *NSDocumentsFolder() {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = paths[0];
	return documentsDirectory;
}

NSString *NSLibraryFolder() {

	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *libraryDirectory = paths[0];
	return libraryDirectory;
}

NSString *NSApplicationSupportFolder() {
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
	NSString *libraryDirectory = paths[0];
	return libraryDirectory;
}

NSString *NSBundleFolder() {

	return [[NSBundle mainBundle] bundlePath];
}

NSString *NSDCIMFolder() {

	return @"/var/mobile/Media/DCIM";
}

@implementation NSFileManager (Utilities)

+ (NSString *) pathForItemNamed: (NSString *) fname inFolder: (NSString *) path {
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject]) 
		if ([[file lastPathComponent] isEqualToString:fname]) 
			return [path stringByAppendingPathComponent:file];
	return nil;
}

+ (NSString *) pathForDocumentNamed: (NSString *) fname {
	
	return [NSFileManager pathForItemNamed:fname inFolder:NSDocumentsFolder()];
}

+ (NSString *) pathForBundleDocumentNamed: (NSString *) fname {
	
	return [NSFileManager pathForItemNamed:fname inFolder:NSBundleFolder()];
}

+ (NSArray *) filesInFolder: (NSString *) path {
	
	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject])
	{
		BOOL isDir;
		[[NSFileManager defaultManager] fileExistsAtPath:[path stringByAppendingPathComponent:file] isDirectory: &isDir];
		if (!isDir) [results addObject:file];
	}
	return results;
}

// Case insensitive compare, with deep enumeration
+ (NSArray *) pathsForItemsMatchingExtension: (NSString *) ext inFolder: (NSString *) path {

	NSString *file;
	NSMutableArray *results = [NSMutableArray array];
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:path];
	while (file = [dirEnum nextObject]) 
		if ([[file pathExtension] caseInsensitiveCompare:ext] == NSOrderedSame)
			[results addObject:[path stringByAppendingPathComponent:file]];
	return results;
}

+ (NSArray *) pathsForDocumentsMatchingExtension: (NSString *) ext {
	
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSDocumentsFolder()];
}

// Case insensitive compare
+ (NSArray *) pathsForBundleDocumentsMatchingExtension: (NSString *) ext {
	
	return [NSFileManager pathsForItemsMatchingExtension:ext inFolder:NSBundleFolder()];
}


@end




@implementation NSFileManager (RadiantTap)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
	
	NSError *error = nil;
	BOOL success = [URL setResourceValue:@YES forKey:NSURLIsExcludedFromBackupKey error:&error];
	if (!success) {
		NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
	}
	
	return success;
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path {

	return [NSFileManager findOrCreateDirectoryPath:path backup:YES dataProtection:nil];
}

+ (BOOL)findOrCreateDirectoryPath:(NSString *)path backup:(BOOL)shouldBackup dataProtection:(NSString *)dataProtection {
	
	BOOL isDirectory;
	BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
	if (exists) {
		if (isDirectory) return YES;
		return NO;
	}
	
	//
	// Create the path if it doesn't exist
	//
	NSError *error;
	BOOL success = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];

	//
	if (success && !shouldBackup) {
		//	try to set no-iCloud-backup folder, but do not fail everything if this particular bit fails
		[[NSFileManager defaultManager] addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:path]];
	}
	
	if (success && dataProtection != nil) {
		//	also, set protection level as requested
		[[NSFileManager defaultManager] setAttributes:@{NSFileProtectionKey:dataProtection} ofItemAtPath:path error:&error];
	}
	
	return success;
}

//	example how to add your own stuff, for the particular app you work with
//+ (NSString *)RTOrdersFolder {
//	
//	NSString *f = [NSDocumentsFolder() stringByAppendingPathComponent:@"orders"];
//	if ([NSFileManager findOrCreateDirectoryPath:f shouldBackup:YES dataProtection:NSFileProtectionComplete])
//		return f;
//	
//	return nil;
//}

@end