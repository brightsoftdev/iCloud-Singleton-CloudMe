//
//  NoteSheet.h
//  icloud_single
//
//  Created by Sergio on 25/11/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteSheet : UIDocument
{
    NSString *noteContent;
}

@property (strong) NSString *noteContent;

@end
