//
//  helloworldAppDelegate.h
//  helloworld
//
//  Created by Kevin Brandstatter on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class searchViewController;

@interface helloworldAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	searchViewController *svControl;
	UINavigationController *navControl;
	int searchOptions, beginYear, endYear;
	//webViewController *webControl;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) searchViewController *svControl;
@property (nonatomic, retain) IBOutlet UINavigationController *navControl;
@property  (readwrite, assign) int searchOptions, beginYear, endYear;

@end

