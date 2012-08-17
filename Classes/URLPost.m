//
//  URLPost.m
//  CiteScholar
//
//  Created by Kevin Brandstatter on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "URLPost.h"


@implementation URLPost

- (id) initWithData:(NSData *)theData{
	[super init];
	if (self) {
	}
	return self;
}

- (void) post:(NSData *)toSend{
	NSURL *url = [NSURL URLWithString:@"http://datasys.cs.iit.edu/projects/CiteSearcher/dataManager.php"];
	NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[postRequest setHTTPMethod:@"POST"];
	[postRequest setHTTPBody:toSend];
	[postRequest setValue:@"CiteSearcher" forHTTPHeaderField:@"User-Agent"];
	[[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	//[data release];
	//NSLog(@"%@", data);
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	[connection release];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	//[connection release];
	//NSLog(@"Could not complete request. Please try again.");
	//NSLog(@"%@", error);
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	//NSLog(@"%@", response);
}

- (void) dealloc{
	[super dealloc];
}


@end
