/*
    File:		OpenURLPanel.m

    Copyright:	©2004, 2005 by Apple Computer, Inc., all rights reserved.

*/


#import "OpenURLPanel.h"

    // user defaults keys
#define kUserDefaultURLsKey	@"UserDefaultURLsKey"

    // maximum urls
#define kMaximumURLs		15

@implementation OpenURLPanel

static OpenURLPanel *openURLPanel = nil;

    // class methods
+ (id)openURLPanel
{
    if (openURLPanel == nil)
        openURLPanel = [[self alloc] init];

    return openURLPanel;
}

- (id)init
{
    [super init];

    // init
    [self setURLArray:[NSMutableArray arrayWithCapacity:10]];

    // listen for app termination notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(writeURLs:) name:NSApplicationWillTerminateNotification object:NSApp];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setURLArray:nil];
    [super dealloc];
}

    // getters
- (NSString *)urlString
{
    NSString *urlString = nil;

    // get the url
    urlString = [mUrlComboBox stringValue];

    if (urlString == nil)
        urlString = [mUrlComboBox objectValueOfSelectedItem];

    if ([urlString length] == 0)
        urlString = nil;

    return urlString;
}

- (NSURL *)url
{
    NSURL		*url = nil;
    NSString 	*urlString;

    // get the url
    urlString = [self urlString];

    if (urlString)
        url = [NSURL URLWithString:urlString];

    return url;
}

    // setters
- (void)setURLArray:(NSMutableArray *)urlLArray
{
    [urlLArray retain];
    [mUrlArray retain];
    mUrlArray = urlLArray;
}

    // delegates
- (void)awakeFromNib
{
    NSArray *urls;

    // restore the previous urls
    urls = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultURLsKey];
    [mUrlArray addObjectsFromArray:urls];

    if (urls)
        [mUrlComboBox addItemsWithObjectValues:urls];
}

    // notifications
- (void)writeURLs:(NSNotification *)notification
{
    NSUserDefaults *userDefaults;

    if ([mUrlArray count])
    {
        // init
        userDefaults = [NSUserDefaults standardUserDefaults];
    
        // write out the urls
        [userDefaults setObject:mUrlArray forKey:kUserDefaultURLsKey];
        [userDefaults synchronize];
    }
}

    // actions
- (IBAction)doOpenURL:(id)sender
{
    NSString	*urlString;
    NSURL		*url;
    BOOL		informDelegate = YES;
    IMP			callback;

    if ([sender tag] == NSOKButton)
    {
        // validate the URL
        url = [self url];
        urlString = [self urlString];

        if (url)
        {
            // save the url
            if (![mUrlArray containsObject:urlString])
            {
                // save the url
                [mUrlArray addObject:urlString];

                // add the url to the combo box
                [mUrlComboBox addItemWithObjectValue:urlString];

                // remove the oldest url if the maximum has been exceeded
                if ([mUrlArray count] > kMaximumURLs)
                {
                    [mUrlArray removeObjectAtIndex:0];
                    [mUrlComboBox removeItemAtIndex:0];
                }
            }
            else
            {
                // move the url to the bottom of the list
                [mUrlArray removeObject:urlString];
                [mUrlArray addObject:urlString];
                [mUrlComboBox removeItemWithObjectValue:urlString];
                [mUrlComboBox addItemWithObjectValue:urlString];
            }
        }
        else
        {
            if (mIsSheet)
                NSRunAlertPanel(@"Invalid URL", @"The URL is not valid.", nil, nil, nil);
            else
                NSBeginAlertSheet(@"Invalid URL", nil, nil, nil, mPanel, nil, nil, nil, nil, @"The URL is not valid.");

            informDelegate = NO;
        }
	}

    // inform the delegate
    if (informDelegate && mDelegate && mDidEndSelector)
    {
        callback = [mDelegate methodForSelector:mDidEndSelector];
        callback(mDelegate, mDidEndSelector, self, [sender tag], mContextInfo);
    }
}

    // methods
- (void)beginSheetWithWindow:(NSWindow *)window delegate:(id)delegate didEndSelector:(SEL)didEndSelector contextInfo:(void *)contextInfo
{
    // will this run as a sheet
    mIsSheet = (window ? YES : NO);

    // save the delegate, did end selector, and context info
    mDelegate = delegate;
    mDidEndSelector = (didEndSelector);
    mContextInfo = contextInfo;

    // load the bundle (if necessary)
    if (mPanel == nil)
        [NSBundle loadNibNamed:@"OpenURLPanel" owner:self];

    // start the sheet (or window)
    [NSApp beginSheet:mPanel modalForWindow:window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (void)close
{
    // close it down
    [NSApp endSheet:mPanel];
    [mPanel close];
}

@end
