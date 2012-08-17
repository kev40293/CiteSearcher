//
//  URLPost.h
//  CiteScholar
//
//  Created by Kevin Brandstatter on 7/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface URLPost : NSObject {
}

- (id) initWithData:(NSData *)theData;

- (void) post:(NSData *)toSend;

@end
