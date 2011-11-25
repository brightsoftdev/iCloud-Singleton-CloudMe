//
//  CloudMe.m
//  icloud_single
//
//  Created by Sergio on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CloudMe.h"
#import "NoteSheet.h"

@interface NSUbiquitousKeyValueStore (Singleton)

+ (NSUbiquitousKeyValueStore *)makeSingleton;

@end

@implementation NSUbiquitousKeyValueStore (Singleton)

+ (NSUbiquitousKeyValueStore *)makeSingleton
{
    static dispatch_once_t once;
    static NSUbiquitousKeyValueStore *store;
    
    dispatch_once(&once, ^ { 
        
        store = [NSUbiquitousKeyValueStore new];
    });
    
    return store; 
}

@end

#define kHeaderDocument @"Cloud_"
#define kFileName @"myDocument.dox"
#define kImageName @"myImage.png"
#define kCloudSyncNotification @"CloudSyncDidUpdateToLatest"

static void (^documentBlock)(UIDocument *);
static void (^objectChanged)(BOOL);
static CloudMe *cloudInstance = nil;

@interface CloudMe (Internal)

+ (BOOL)checkForCloud;
+ (void)updateToiCloud:(NSNotification *)notificationObject;
+ (void)updateFromiCloud:(NSNotification *)notificationObject;
- (void)loadData:(NSMetadataQuery *)queryParameter;

@end

@implementation CloudMe

+ (CloudMe *)shared
{
    static dispatch_once_t once;
    
    dispatch_once(&once, ^ { 
        
        cloudInstance = [CloudMe new];
    });
    
    return cloudInstance;
}

+ (BOOL)checkForCloud
{
    return ((NSClassFromString(@"NSUbiquitousKeyValueStore")) && ([NSUbiquitousKeyValueStore defaultStore])) ? YES : NO;
}

#pragma -
#pragma UIDocument to iCloud

- (void)uploadDocumentWithcontents:(NSString *)documentContents result:(void (^)(BOOL))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(NO);
    }
    else
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
        
        NSString *fileName = [NSString stringWithFormat:@"%@_%@%@", [formatter stringFromDate:[NSDate date]], kHeaderDocument, kFileName];
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:@"Documents"] URLByAppendingPathComponent:fileName];

        NoteSheet *documentLocal = [[NoteSheet alloc] initWithFileURL:ubiquitousPackage];
        documentLocal.noteContent = documentContents;
        
        [documentLocal saveToURL:[documentLocal fileURL] 
                forSaveOperation:UIDocumentSaveForCreating 
               completionHandler:^(BOOL success) {
         
              resultBlock(success);
        }];
    }
}

- (void)downloadAllDocumentsWithResult:(void (^)(UIDocument *))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(nil);
    }
    else
    {
        documentBlock = nil;
        documentBlock = [resultBlock copy];
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        if (ubiq) 
        {
            query = [[NSMetadataQuery alloc] init];
            [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K like '%@*'", NSMetadataItemFSNameKey, kHeaderDocument, kFileName];
            [query setPredicate:pred];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(queryDidFinishGathering:) 
                                                         name:NSMetadataQueryDidFinishGatheringNotification 
                                                       object:query];
        }
    }
}

- (void)downloadDocumentWithName:(NSString *)fileName result:(void (^)(UIDocument *))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(nil);
    }
    else
    {
        documentBlock = nil;
        documentBlock = [resultBlock copy];
        NSURL *ubiq = [[NSFileManager defaultManager] URLForUbiquityContainerIdentifier:nil];
        
        if (ubiq) 
        {
            query = [[NSMetadataQuery alloc] init];
            [query setSearchScopes:[NSArray arrayWithObject:NSMetadataQueryUbiquitousDocumentsScope]];
            
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K like '%@*'", NSMetadataItemFSNameKey, fileName];
            [query setPredicate:pred];
            
            [[NSNotificationCenter defaultCenter] addObserver:self 
                                                     selector:@selector(queryDidFinishGathering:) 
                                                         name:NSMetadataQueryDidFinishGatheringNotification 
                                                       object:query];
        }
    }
}

- (void)queryDidFinishGathering:(NSNotification *)notification 
{    
    NSMetadataQuery *queryLocal = [notification object];
    [query disableUpdates];
    [query stopQuery];
    
    [self loadData:queryLocal];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    
    query = nil;
}

- (void)loadData:(NSMetadataQuery *)queryParameter
{
    NSArray *arrayObjects = [queryParameter results];
    
    if (arrayObjects == nil) documentBlock(nil);
    if ([arrayObjects count] == 0) documentBlock(nil);
        
    for (NSMetadataItem *item in arrayObjects)
    {
        NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
        UIDocument *doc = [[UIDocument alloc] initWithFileURL:url];
        
        [doc openWithCompletionHandler:^(BOOL success) {
            
            if (success) 
            {
                documentBlock(doc);
            } 
            else 
            {
                NSLog(@"failed to open from iCloud");
            }
        }];        
    }
}

#pragma -
#pragma UIImage to iCloud

- (void)uploadImage:(UIImage *)image result:(void (^)(BOOL))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(NO);
    }
    else
    {
        keyStore = [NSUbiquitousKeyValueStore makeSingleton];
        objectChanged = nil;
        objectChanged = [resultBlock copy];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(ubiquitousKeyValueStoreDidChange:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:keyStore];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
        
        NSString *key = [NSString stringWithFormat:@"%@_%@%@", [formatter stringFromDate:[NSDate date]], kHeaderDocument, kImageName];
        
        [keyStore setData:UIImagePNGRepresentation(image) 
                   forKey:key];
        
        [keyStore synchronize];
    }
}

- (void)downloadAllImagesWithResult:(void (^)(UIImage *))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(nil);
    }
    else
    {
        keyStore = [NSUbiquitousKeyValueStore makeSingleton];
        NSArray *keys = [[keyStore dictionaryRepresentation] allKeys];
        
        [keys enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id object, NSUInteger idx, BOOL *stop) {
            
            NSData *data = [keyStore dataForKey:object];
            
            if (data != nil) 
            {
                UIImage *image = [UIImage imageWithData:data];
                
                if (image != nil) resultBlock(image);
            }
        }];
    }
}

- (void)downloadImageWithKey:(NSString *)key result:(void (^)(UIImage *))resultBlock
{
    if (![CloudMe checkForCloud]) 
    {
        resultBlock(nil);
    }
    else
    {
        keyStore = [NSUbiquitousKeyValueStore makeSingleton];
        NSData *data = [keyStore dataForKey:key];
            
        if (data != nil) 
        {
            UIImage *image = [UIImage imageWithData:data];
                
            if (image != nil) resultBlock(image);
        }
        else
            resultBlock(nil);
    }
}

- (void)ubiquitousKeyValueStoreDidChange:(NSNotification *)notification
{
    NSLog(@"Modified into iCloud");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:keyStore];
    
    objectChanged(YES);
}

#pragma -
#pragma NSUSerDefaults to iCloud

/*
    Visit https://github.com/MugunthKumar/MKiCloudSync/blob/master/MKiCloudSync.m
    http://blog.mugunthkumar.com/coding/ios-code-mkicloudsync-sync-your-nsuserdefaults-to-icloud-with-a-single-line-of-code/
*/
- (void)startSavingDefaultsToCloud
{
    //Call it in AppDelegate
    
    if ([CloudMe checkForCloud])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateFromiCloud:)
                                                     name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateToiCloud:)
                                                     name:NSUserDefaultsDidChangeNotification object:nil];
    }
}

+ (void)updateToiCloud:(NSNotification *)notificationObject 
{
    NSLog(@"Updating to iCloud");
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [[NSUbiquitousKeyValueStore defaultStore] setObject:obj forKey:key];
    }];
    
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                                                  object:nil];
}

+ (void)updateFromiCloud:(NSNotification *)notificationObject
{    
    NSLog(@"Updating from iCloud");
    
    NSUbiquitousKeyValueStore *iCloudStore = [NSUbiquitousKeyValueStore defaultStore];
    NSDictionary *dict = [iCloudStore dictionaryRepresentation];

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSUserDefaultsDidChangeNotification
                                                  object:nil];
    
    [dict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        [[NSUserDefaults standardUserDefaults] setObject:obj forKey:key];
    }];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateToiCloud:)
                                                 name:NSUserDefaultsDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCloudSyncNotification object:nil];
}

@end