//
//  searchOptionsController.h
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "helloworldAppDelegate.h"


@interface searchOptionsController : UIViewController <UITableViewDelegate, UITextFieldDelegate>{
	UITextField *early;
	UITextField *late;
	UITableView *categories;
	UIWindow *window;
	NSArray *values;
	int opt;
}

@property (nonatomic, retain) IBOutlet UITableView *categories;

@property (nonatomic,retain) IBOutlet UITextField *early, *late;

@property (nonatomic, retain) NSArray *values;

@property  (readwrite, assign) int opt;

- (IBAction) finishedEdit;

- (IBAction)textViewShouldReturn:(id)sender;

- (IBAction)backgroundTouched:(id)sender;

@end
