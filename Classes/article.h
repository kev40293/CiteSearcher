//
//  article.h
//  helloworld
//
//  Created by Kevin Brandstatter on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface article : NSObject {
	NSString *title;
	NSString *author;
	NSURL *PDF;
	NSString *website;
	int cites;
	BOOL flag;
}

@property (nonatomic, retain) NSString *title;

@property (nonatomic, retain) NSString *author;

@property (nonatomic, retain) NSString *website;

@property (nonatomic, retain) NSURL *PDF;

-(id) initWithTitle:(NSString *)theTitle author:(NSString *)theAuthor citations:(int)theCites url:(NSString *)web;

-(int) cites;

-(void) setCites:(int)numCites;

-(BOOL) hasPDF;

-(BOOL)flagged;

-(void)toggleFlag;

@end
