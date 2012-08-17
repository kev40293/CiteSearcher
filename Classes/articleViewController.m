    //
//  articleViewController.m
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 8/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "articleViewController.h"
#import "helloworldAppDelegate.h"

@implementation articleViewController

@synthesize theArticle, attributes, webControl, details;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibNameAndArticle:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil art:(article *)anArticle{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        theArticle = anArticle;
    }
	attributes = [[NSArray alloc] initWithObjects:@"Title", @"Authors", @"URL", @"PDF", nil];
	[details reloadData];
    return self;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[attributes dealloc];
	[details dealloc];
	[theArticle dealloc];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [attributes count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//[cell setLineBreakMode:UILineBreakModeCharacterWrap];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	switch ([indexPath section]) {
		case 0:
			[cell.textLabel setText:[theArticle title]];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			break;
		case 1:
			[cell.textLabel setText:[theArticle author]];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			break;
		case 2:
			[cell.textLabel setText:[theArticle website]];
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			break;
		case 3:
			if ([theArticle PDF]) {
				[cell.textLabel setText:[[theArticle PDF] absoluteString]];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
			else {
				[cell.textLabel setText:@"No PDF for this article"];
				[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			}

			break;
		default:
			break;
	}
	[cell.textLabel setNumberOfLines:0];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	helloworldAppDelegate *appDelagate = (helloworldAppDelegate *)[[UIApplication sharedApplication] delegate];
	switch ([indexPath section]) {
		case 0:
			break;
		case 1:
			break;
		case 2:
			[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[theArticle website]]];
			/*
			webControl = [[webViewController alloc] initWithNibName:@"webViewer" bundle:[NSBundle mainBundle]];
			[appDelagate.navControl pushViewController:webControl animated:YES];
			[webControl.webpage loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[theArticle website]]]];
			 */
			break;
		case 3:
			if ([theArticle PDF] == nil){
				break;
			}
			webControl = [[webViewController alloc] initWithNibName:@"webViewer" bundle:[NSBundle mainBundle]];
			[appDelagate.navControl pushViewController:webControl animated:YES];
			[webControl.webpage loadRequest:[NSURLRequest requestWithURL:[theArticle PDF]]];
			break;
		default:
			break;
	}
	[details deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
		return [self.attributes objectAtIndex:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
