//
//  statsViewController.h
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface statsViewController : UIViewController <UITableViewDelegate>{
	UITableView *data;
	NSArray *attributes;
	NSString *name;
	int numberOfCites;
	int hIndex;
	int gIndex;
}

@property (nonatomic, retain) IBOutlet UITableView *data;

@property (nonatomic, retain) NSArray *attributes;

@property (nonatomic, retain) NSString *name;

@property (nonatomic) int numberOfCites;

@property (nonatomic) int hIndex;

@property (nonatomic) int gIndex;

@end
