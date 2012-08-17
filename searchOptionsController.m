    //
//  searchOptionsController.m
//  CiteSearcher
//
//  Created by Kevin Brandstatter on 9/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "searchOptionsController.h"

@implementation searchOptionsController

@synthesize early, late, categories, values, opt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		values = [[NSArray alloc] initWithObjects:@"Engineering, Computer Science, Mathematics",
				  @"Biology, Life Sciences, and Environmental Science",
				  @"Medicine, Pharmacology, and Veterinary Science",
				  @"Business, Administration, Finance, and Economics",
				  @"Physics, Astronomy, and Planetary Science",
				  @"Chemistry and Materials Science",
				  @"Social Sciences, Arts, and Humanities ", nil];
		helloworldAppDelegate *appDel = [(helloworldAppDelegate *) [UIApplication sharedApplication] delegate];
		opt = [appDel searchOptions];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
	helloworldAppDelegate *appDel = [(helloworldAppDelegate *) [UIApplication sharedApplication] delegate];
	[early setText:[NSString stringWithFormat:@"%d", appDel.beginYear]];
	[late setText:[NSString stringWithFormat:@"%d", appDel.endYear]];
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
	[early release];
	[late release];
	[categories release];
	[values release];
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [values count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	//[cell setLineBreakMode:UILineBreakModeCharacterWrap];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	[cell.textLabel setNumberOfLines:0];
	[cell.textLabel setText:[values objectAtIndex:[indexPath row]]];
	if ((opt & (1 << indexPath.row)) > 0){
		[cell setAccessoryType:UITableViewCellAccessoryCheckmark];
	}
	else {
		[cell setAccessoryType:UITableViewCellAccessoryNone];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self textFieldShouldReturn:early];
	[self textFieldShouldReturn:late];
	opt = opt^(1<<indexPath.row);
	[categories reloadData];
	//[appDel.navControl popViewControllerAnimated:YES];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//	//return @"Fields:";
//}

- (IBAction) finishedEdit{
	helloworldAppDelegate *appDel = [(helloworldAppDelegate *) [UIApplication sharedApplication] delegate];
	[appDel setSearchOptions:opt];
	if ([[NSScanner scannerWithString:[early text]] scanInt:nil]){
		appDel.beginYear = [[early text] intValue];
	}
	else{
		appDel.beginYear = 0;
	}
	if ([[NSScanner scannerWithString:[late text]] scanInt:nil]){
		appDel.endYear = [[late text] intValue];
	}
	else {
		appDel.endYear = 3000;
	}

	[appDel.navControl popViewControllerAnimated:YES];
	//[appDel release];
}

// hide keyboard when lost focus
- (IBAction)textFieldShouldReturn:(UITextField *)sender {
	[sender resignFirstResponder];
	return YES;
}

- (IBAction)backgroundTouched:(id)sender{
	[self textFieldShouldReturn:early];
	[self textFieldShouldReturn:late];
}

@end
