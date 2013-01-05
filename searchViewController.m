    //
//  viewController.m
//  helloworld
//
//  Created by Kevin Brandstatter on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "searchViewController.h"



@implementation searchViewController

@synthesize version, advancedOptions, spinner, DELETE, MENU_ACTIVE, postDelegate, table, window, search, articleView, searchData, articles, lastSearch, searchHistory, deleteBar;
// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		version = @"1.0";
		DELETE = NO;
		PDFVIEW = NO;
		articles = [[NSMutableArray alloc] init];
		lastSearch = [[[NSString alloc] init] autorelease];
		searchHistory = [[NSMutableArray alloc] init];
		[table reloadData];
    }
    return self;
}
*/

- (void) setup {
	version =[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
	DELETE = NO;
    MENU_ACTIVE = NO;
	articles = [[NSMutableArray alloc] init];
	lastSearch = [[[NSString alloc] init] autorelease];
	searchHistory = [[NSMutableArray alloc] init];
	postDelegate = [[URLPost alloc] initWithData:nil];
	advancedOptions = [[NSArray alloc] initWithObjects:@"eng",@"bio",@"med",@"bus",@"phy",@"chm",@"soc",nil];
	[table reloadData];
}


// prepares an xml formatted log and posts it to the server
- (void) sendLog{
	NSDate *logTime = [[[NSDate alloc] init] autorelease];
	NSMutableString *logFile = [[[NSMutableString alloc] initWithFormat:@"data=		<time>%@</time>\n",logTime] autorelease];
	[logFile appendFormat:@"		<version>iOS %@</version>\n",version];
	for (NSString *searchSent in searchHistory){
		[logFile appendFormat:@"		<search>%@</search>\n",searchSent];
	}
	//replace log code with code to post data to server
	NSData *data = [logFile dataUsingEncoding:NSUTF8StringEncoding];
	//URLPost *postDelagate = [[URLPost alloc] initWithData:data];
	//[postDelegate release];
	//postDelegate = [[URLPost alloc] initWithData:data];
	//[postDelegate setToSend:data];
	[postDelegate post:data];
	[searchHistory removeAllObjects];
}

//Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [self.deleteBar setHidden:TRUE];
    [spinner setHidden:TRUE];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
	//[self setTextBox:nil];
	[self setTable:nil];
	[self setSearch:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//release textBox, table, window, search, searchData, articles, website, lastSearch, views, navBar, searchHistory, pdfBar;
- (void)dealloc {
	[table release];
	[window release];
	[search release];
	[searchData release];
	[lastSearch release];
	[articles release];
	[searchHistory release];
	[deleteBar release];
	[postDelegate release];
	[advancedOptions dealloc];
    [super dealloc];
}

/*actions to take when search button clicked
* - resign keyboard
* - call method to send the request
* - reload the table data upon completion of http request
*/
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
	[spinner startAnimating];
    [spinner setHidden:FALSE];
	[self deactivateDelete:nil];
	if ([[search text] isEqualToString:@""]){
		return;
	}
	[lastSearch release];
	lastSearch = [[NSString alloc] initWithString:[search text]];
	[searchHistory addObject:lastSearch];
	NSString *searchString = [search text];
	[search resignFirstResponder];
	[self sendHttpRequest:searchString];
	[table reloadData];
	[self sendLog];
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar{
	[searchBar resignFirstResponder];
}

// hide keyboard when lost focus
- (BOOL)textViewShouldReturn:(id)sender {
	[sender resignFirstResponder];
	return YES;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [articles count];
}

// table cell = Number cites + title of article
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
	}
	article *toUse = [articles objectAtIndex:indexPath.row];
	NSString *textVal = [[NSString alloc] initWithFormat:@"%d %@", [toUse cites], [toUse title]];
	[cell.textLabel setText:textVal];
	if (DELETE) {
		if ([toUse flagged]) {
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
		}else{
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	else {
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	
	[textVal release];
	return cell;
}

/*
 * actions to take when selecting to element in list
 * - set web view url to selected.
 * - loads website in background
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[search resignFirstResponder];
	if (DELETE){
		article *chosen = [articles objectAtIndex:indexPath.row];
		[chosen toggleFlag];
		[table reloadData];
	}
	else {
		article *chosen = [articles objectAtIndex:indexPath.row];
		helloworldAppDelegate *appDelegate = (helloworldAppDelegate *)[[UIApplication sharedApplication] delegate];
		articleView = [[articleViewController alloc] initWithNibNameAndArticle:@"articleView" bundle:[NSBundle mainBundle] art:chosen];
		[appDelegate.navControl pushViewController:articleView animated:YES];
	}
}

// creates the url request object
// sends te request to google
- (void) sendHttpRequest:(NSString *)toSend {
	searchData = [NSMutableData new];
	[articles removeAllObjects];
	helloworldAppDelegate *appDel = [(helloworldAppDelegate *) [UIApplication sharedApplication] delegate];
	NSString *years = [NSString stringWithFormat:@"&as_ylo=%d&as_yhi=%d",appDel.beginYear,appDel.endYear];
	//NSString *years = [NSString stringWithFormat:@"&as_ylo=%d&as_yhi=%d",1000,3000];
	NSMutableString *cat = @"";
	for (int x = 0; x < 7; x++){
		if (([appDel searchOptions] & (1 << x)) >0){
			cat = [cat stringByAppendingFormat:@"&as_subj=%@",[advancedOptions objectAtIndex:x]];
		}
	}
	// Base of query
	// @"http://scholar.google.com/scholar?hl=en&num=100&btnG=Search&as_sdt=1%2C14&as_sdtp=on&authors=";
	
	NSMutableString *query = @"http://scholar.google.com:80/scholar?num=100&start=0&q=author:";
	query = [query stringByAppendingFormat:@"%@%@%@",[toSend stringByReplacingOccurrencesOfString:@" " withString:@"+"],years,cat];
	NSURL *url = [NSURL URLWithString:query];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setHTTPMethod:@"GET"];
	NSString *userAgent = @"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30";
	[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
	//[cat release];
}

//collects incoming data
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[searchData appendData:data];
	//[textBox setText:@"Searching"];
}

/* send actions upon full reception of data
 * calls the html parser function
 * requests more data if needed for h-index
 * releases connection and returned data objects
 */
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
	NSMutableString *http = [[NSMutableString alloc] initWithData:searchData encoding:NSUTF8StringEncoding];
	[http replaceOccurrencesOfString:@"<b>" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [http length])];
	[self parseHtmlResults:http];
	[connection release];
	[searchData release];
	if ([self calculateHIndex:articles] >= [articles count] && [articles count] != 0){
		[self loadMoreResults:lastSearch];
	}
	[table reloadData];
	[http release];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[searchData setLength:0];
}

/*
 *take two of parsing html
 *take each result
 *parse out what is needed
 *create article
 *add it to list
 */
- (void) parseHtmlResults:(NSMutableString *)htmlResults {
	NSError *error = nil;
	HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlResults error:&error];
	if (error){
		return;
	}
	HTMLNode *bodyNode = [parser body];
	NSArray *results = [bodyNode findChildrenOfClass:@"gs_r"];
	int num = 0;
	for (HTMLNode *result in results){
		HTMLNode *titleNode = [result findChildOfClass:@"gs_rt"];
		HTMLNode *aTitle = [titleNode findChildTag:@"a"];
		NSString *author = [[result findChildOfClass:@"gs_a"] contents];
		NSString *theURL = [aTitle getAttributeNamed:@"href"];
		HTMLNode *PDF = [result findChildOfClass:@"gs_ggs gs_fl"];
		NSURL *pdfUrl = nil;
		HTMLNode *citeLine = [result findChildOfClass:@"gs_fl"];
		if (PDF) {
			NSString *temp = [[PDF findChildTag:@"a"] getAttributeNamed:@"href"];
			pdfUrl = [[[NSURL alloc] initWithString:temp] autorelease];
		}
		int numCites = 0;
		if (citeLine && [citeLine findChildTag:@"a"]){
			NSString *citeString = [[citeLine findChildTag:@"a"] contents];
			if ([citeString hasPrefix:@"Cited by"]){
				numCites = [[citeString substringFromIndex:[@"Cited by " length]] intValue];
			}
		}
		if (aTitle){
			NSString *theTitle = [aTitle contents];
			article *newEntry = [[article alloc] initWithTitle:theTitle author:author citations:numCites url:theURL];
			[articles addObject:newEntry];
			[newEntry release];
			if (pdfUrl){
				[newEntry setPDF:pdfUrl];
			}
		}
		num++;
	}
	[table reloadData];
	[parser release];
    [spinner setHidden:TRUE];
	[spinner stopAnimating];
}

// returns an array of the results sorted by number of citations
// uses insertion sort
-(NSArray *)sortResults:(NSArray *)toSort{
		if ([toSort count] == 1)
			return toSort;
		NSMutableArray *sorts = [[[NSMutableArray alloc] initWithArray:toSort] autorelease];
		for (int x = 1; x < [sorts count]; x++){
			int cur = x;
			while (cur > 0){
				if ([[sorts objectAtIndex:cur] cites] > [[sorts objectAtIndex:(cur-1)] cites]){
					[sorts exchangeObjectAtIndex:cur withObjectAtIndex:(cur-1)];
					cur--;
				}
				else {
					break;
				}
				
			}
		}
		return sorts;
		//return [[[NSArray alloc] initWithArray:sorts] autorelease;
}

//calculates the h-index
-(int) calculateHIndex:(NSArray *)results{
	int h = 0;
	for (article *a in [self sortResults:results]){
		if ([a cites] >= h && [results count] < 1000){
			h++;
		}
		else 
			break;
	}
	return h;
}

//removes selected elements from results
- (IBAction)removeElements:(id)sender{
	for (int x = 0; x < [articles count]; x++) {
		if ([[articles objectAtIndex:x] flagged]) {
			[articles removeObjectAtIndex:x];
			x--;
		}
	}
	[self deactivateDelete:nil];
	//[self.view sendSubviewToBack:deleteBar];
	if ([self calculateHIndex:articles] >= [articles count]){
		[self loadMoreResults:lastSearch];
	}
	[table reloadData];
}

// loads another set of data for further calculations
// same implementation as sendHttpRequest except doesn't reset data arrays
-(void)loadMoreResults:(NSString *)toSend{
	searchData = [NSMutableData new];
	NSString *query = @"http://scholar.google.com:80/scholar?num=100&start=100&q=author:";
	NSURL *url = [NSURL URLWithString:[query stringByAppendingString:[toSend stringByReplacingOccurrencesOfString:@" " withString:@"+author:"]]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setHTTPMethod:@"GET"];
	NSString *userAgent = @"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.100 Safari/534.30";
	[request setValue:userAgent forHTTPHeaderField:@"User-Agent"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

//brings up screen with information about application
- (void) showInfoScreen:(id)sender{
	[search resignFirstResponder];
	helloworldAppDelegate *appDelagate = (helloworldAppDelegate *) [[UIApplication sharedApplication] delegate];
	UIViewController *infoScreen = [[UIViewController alloc] initWithNibName:@"infoScreen" bundle:[NSBundle mainBundle]];
    NSString *infoText = [[NSString alloc] initWithFormat:@
    "CiteSearcher v%@\n"
    "A Google Scholar Search Tool\n\n"
    
    "Created by Kevin Brandstatter\n"
    "in the DataSys Laboratory\n"
    "at Illinois Institute of Technology.\n"
    "Sponsored by National Science Foundation grant NSF-1054974\n\n"
    
    "This app searches for scholarly articles by author using Google Scholar (http://scholar.google.com/) and\n"
                                                                             "returns the h-index about the authors publications.\n"
                                                                             
                                                                             "For more information, visit\n"
     "http://datasys.cs.iit.edu/projects/ CiteScholar/", version];
    [(UITextView *) [[[infoScreen view] subviews] objectAtIndex:0] setText:infoText];
	[appDelagate.navControl pushViewController:infoScreen animated:YES];
	//[self.view bringSubviewToFront:infoScreen];
}

//toggles delete mode on
- (void) activateDelete{
	self.DELETE = YES;
	[self.deleteBar setHidden:FALSE];
	[table reloadData];
	//[self returnToSearchScreen:nil];
	//[self.view bringSubviewToFront:deleteBar];
}

//cancels delete mode
- (IBAction) deactivateDelete:(id)sender{
	self.DELETE = NO;
	//[self.view sendSubviewToBack:deleteBar];
	[self.deleteBar setHidden:TRUE];
	for (article *art in articles){
		if ([art flagged])
			[art toggleFlag];
	}
	[table reloadData];
}

- (IBAction) popupMenu:(id)sender{
    if (MENU_ACTIVE) {
        return;
    }
    MENU_ACTIVE = YES;
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Menu" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Author Info", @"Delete Results", @"Advanced Search", nil];
    [menu showFromBarButtonItem:sender animated:YES];
	[menu release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
			[self showAuthorInfo];
			break;
		case 1:
			[self activateDelete];
			break;
		case 2:
			[self advancedSearchOptions];
			break;
		default:
			break;
	}
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    MENU_ACTIVE = NO;
}

- (void) showAuthorInfo{
	statsViewController *statsView = [[statsViewController alloc] initWithNibName:@"statsView" bundle:[NSBundle mainBundle]];
	[statsView setName:lastSearch];
	int x = 0;
	for (article *art in articles){
		x += [art cites];
	}
	[statsView setNumberOfCites:x];
	[statsView setHIndex:[self calculateHIndex:articles]];
	[statsView setGIndex:[self calculateGIndex:articles]];
	helloworldAppDelegate *appDelagate = (helloworldAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelagate.navControl pushViewController:statsView animated:YES];
}

-(int) calculateGIndex:(NSArray *)results{
	int x = 0;
	int total = 0;
	for (article *a in [self sortResults:results]){
		total += [a cites];
		if (pow(x+1, 2) > total){
			return x;
		}
		x++;
	}
	return x;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void) advancedSearchOptions{

	searchOptionsController *soControl = [[searchOptionsController alloc] initWithNibName:@"searchOptions" bundle:[NSBundle mainBundle]];
	helloworldAppDelegate *appDelagate = (helloworldAppDelegate *) [[UIApplication sharedApplication] delegate];
	[appDelagate.navControl pushViewController:soControl animated:YES];
}

@end
