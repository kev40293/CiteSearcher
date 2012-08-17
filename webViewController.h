//
//  webViewController.h
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface webViewController : UIViewController <UIWebViewDelegate>{
	UIWebView *webpage;

}

@property (nonatomic, retain) IBOutlet UIWebView *webpage;

@end
