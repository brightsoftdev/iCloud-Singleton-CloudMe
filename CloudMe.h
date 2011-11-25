//
//  CloudMe.h
//  icloud_single
//
//  Created by Sergio on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudMe : NSObject
{
   
@private 
    NSMetadataQuery *query;
    NSUbiquitousKeyValueStore *keyStore;
}

+ (CloudMe *)shared;
- (void)uploadDocumentWithcontents:(NSString *)documentContents result:(void (^)(BOOL))resultBlock;
- (void)downloadAllDocumentsWithResult:(void (^)(UIDocument *))resultBlock;
- (void)downloadDocumentWithName:(NSString *)fileName result:(void (^)(UIDocument *))resultBlock;

- (void)uploadImage:(UIImage *)document result:(void (^)(BOOL))resultBlock;
- (void)downloadAllImagesWithResult:(void (^)(UIImage *))resultBlock;
- (void)downloadImageWithKey:(NSString *)key result:(void (^)(UIImage *))resultBlock;

- (void)startSavingDefaultsToCloud;

@end
