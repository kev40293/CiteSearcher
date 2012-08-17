//
//  viewController.h
//  Scholar Search
//
//  Created by Kevin Brandstatter on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLParser.h"
#import "article.h";
#import "URLPost.h"
#import "articleViewController.h"
#import "statsViewController.h"
#import "searchOptionsController.h"
#import "helloworldAppDelegate.h"

@interface searchViewController : UIViewController <UITextViewDelegate,
			UISearchBarDelegate, UITableViewDelegate, UIWebViewDelegate,
			UINavigationBarDelegate, UIActionSheetDelegate> {
	UIWindow *window;
	UITableView *table;
	UISearchBar *search;
				UIToolbar *deleteBar;
	NSString *lastSearch;
	NSMutableArray *articles;
	NSMutableArray *searchHistory;
	NSMutableData *searchData;
	NSString *version;
	articleViewController *articleView;
	BOOL DELETE, MENU_ACTIVE;
				UIActivityIndicatorView *spinner;
				URLPost *postDelegate;
				NSArray *advancedOptions;
}

@property (nonatomic, retain) NSString *version;

@property (nonatomic) BOOL DELETE, MENU_ACTIVE;

@property (nonatomic, retain) URLPost *postDelegate;

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UITableView *table;

@property (nonatomic, retain) IBOutlet UISearchBar *search;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) NSMutableData *searchData;

@property (nonatomic, retain) NSMutableArray *articles;

@property (nonatomic, retain) NSString *lastSearch;

@property (nonatomic, retain) NSMutableArray *searchHistory;

@property (nonatomic, retain) IBOutlet UIToolbar *deleteBar;

@property (nonatomic, retain) articleViewController *articleView;

@property (nonatomic, retain) NSArray *advancedOptions;

-(void) activateDelete;

-(IBAction) deactivateDelete:(id)sender;

- (IBAction)removeElements:(id)sender;

- (IBAction) showInfoScreen:(id)sender;

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar;

-(void) parseHtmlResults:(NSMutableString *)htmlResults;

-(NSArray *) sortResults:(NSArray *)toSort;

-(int) calculateHIndex:(NSArray *)results;

-(int) calculateGIndex:(NSArray *)results;

-(void) sendHttpRequest:(NSString *)toSend;

-(void) loadMoreResults:(NSString *)toSend;

- (void) sendLog;

-(void) setup;

- (IBAction) popupMenu:(id)sender;

-(void) showAuthorInfo;
-(void) advancedSearchOptions;

@end
