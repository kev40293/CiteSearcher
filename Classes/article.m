//
//  article.m
//  helloworld
//
//  Created by Kevin Brandstatter on 6/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "article.h"

@implementation article

@synthesize title, author, website, PDF;

-(id) initWithTitle:(NSString *)theTitle author:(NSString *)theAuthor citations:(int)theCites url:(NSString *)web{
	self = [super init];
	[self setTitle:theTitle];
	[self setAuthor:theAuthor];
	[self setCites:theCites];
	[self setWebsite:web];
	[self setPDF:nil];
	flag = NO;
	return self;
}


-(void) dealloc{
	[title release];
	[author release];
	[website release];
	[PDF release];
	[super dealloc];
}

-(int) cites {
	return cites;
}

-(void) setCites:(int)numCites{
	cites = numCites;
}

-(BOOL) hasPDF{
	return ([self PDF] == nil);
}

-(BOOL)flagged{
	return flag;
}

-(void)toggleFlag{
	flag = ![self flagged];
}

@end
