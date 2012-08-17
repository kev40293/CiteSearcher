//
//  articleViewController.h
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#include "article.h";
#import "webViewController.h"


@interface articleViewController : UIViewController <UITableViewDelegate>{
	UIWindow *window;
	UITableView *details;
	article *theArticle;
	NSArray *attributes;
	webViewController *webControl;
}

@property (nonatomic, retain) IBOutlet UITableView *details;

@property (nonatomic, retain) article *theArticle;

@property (nonatomic, retain) NSArray *attributes;

@property (nonatomic, retain) webViewController *webControl;

- (id)initWithNibNameAndArticle:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil art:(article *)anArticle;

@end
