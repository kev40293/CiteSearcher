    //
//  statsViewController.m
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 8/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "statsViewController.h"


@implementation statsViewController

@synthesize name, data, numberOfCites, hIndex, gIndex, attributes;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        attributes = [[NSArray alloc] initWithObjects:@"Name", @"Number of citations", @"h-Index", @"g-Index", nil];
    }
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
	[data dealloc];
	[name dealloc];
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
	NSLog(@"HERE");
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//[cell setLineBreakMode:UILineBreakModeCharacterWrap];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	switch ([indexPath section]) {
		case 0:
			[cell.textLabel setText:name];
			break;
		case 1:
			[cell.textLabel setText:[[NSString alloc] initWithFormat:@"%d", numberOfCites]];
			break;
		case 2:
			[cell.textLabel setText:[[NSString alloc] initWithFormat:@"%d", hIndex]];
			break;
		case 3:
			[cell.textLabel setText:[[NSString alloc] initWithFormat:@"%d", gIndex]];
			break;
		default:
			break;
	}
	[cell.textLabel setNumberOfLines:0];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	//helloworldAppDelegate *appDelagate = (helloworldAppDelegate *)[[UIApplication sharedApplication] delegate];
	[data deselectRowAtIndexPath:indexPath animated:NO];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [self.attributes objectAtIndex:section];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
