/*
    File:		QTKitPlayerAppDelegate.m

    Copyright:	©2005 by Apple Computer, Inc., all rights reserved.

*/

#import "QTKit/QTKit.h"
#import "QTKitPlayerAppDelegate.h"
#import "MovieDocument.h"

enum
{
    kQTKitPlayerOpenAsURL = 0,
	kQTKitPlayerOpenAsData
  
};

@implementation QTKitPlayerAppDelegate

#pragma mark --- NSMenu validation protocol ---
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    BOOL	valid = NO;
    SEL		action;

    // init
    action = [menuItem action];

    // validate
    if (action == @selector(doOpenURL:))
        valid = YES;
    else if (action == @selector(doOpenURLData:))
        valid = YES;
    else
        valid = [[NSDocumentController sharedDocumentController] validateMenuItem:menuItem];

    return valid;
}

#pragma mark --- OpenURLPanel delegates ---
- (void)openURLPanelDidEnd:(OpenURLPanel *)openURLPanel returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
    BOOL closePanel = YES;

    // create the movie document
    if (returnCode == NSOKButton)
        closePanel = [self createMovieDocumentWithURL:[openURLPanel url] asData:((long)contextInfo == kQTKitPlayerOpenAsData)];

    if (closePanel)
        [openURLPanel close];
}

#pragma mark --- actions ---

- (IBAction)doOpenURL:(id)sender
{
    [[OpenURLPanel openURLPanel] beginSheetWithWindow:nil delegate:self didEndSelector:@selector(openURLPanelDidEnd:returnCode:contextInfo:) contextInfo:((void *)kQTKitPlayerOpenAsURL)];
}

- (IBAction)doOpenURLData:(id)sender
{
    [[OpenURLPanel openURLPanel] beginSheetWithWindow:nil delegate:self didEndSelector:@selector(openURLPanelDidEnd:returnCode:contextInfo:) contextInfo:((void *)kQTKitPlayerOpenAsData)];
}


#pragma mark --- methods ---
- (BOOL)createMovieDocumentWithURL:(NSURL *)url asData:(BOOL)asData
{
    NSDocument				*movieDocument = nil;
    NSDocumentController	*documentController;
    BOOL					success = YES;

    // init
    documentController = [NSDocumentController sharedDocumentController];

    // try to create the document from the URL
    if (url)
    {
        if (asData)
            movieDocument = [documentController makeDocumentWithContentsOfURL:url ofType:@"MovieDocumentData"];
        else
            movieDocument = [documentController makeDocumentWithContentsOfURL:url ofType:@"MovieDocument"];
    }

    // add the document
    if (movieDocument)
    {
        [documentController addDocument:movieDocument];

        // setup
        [movieDocument makeWindowControllers];
        [movieDocument updateChangeCount:NSChangeCleared];
        [movieDocument showWindows];
    }
    else
    {
        NSRunAlertPanel(@"Invalid movie", @"The url is not a valid movie.", nil, nil, nil);
        success = NO;
    }

    return success;
}

#pragma mark --- delegates ---

// don't want an untitled document opened upon program launch
// so return NO here
- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender 
{ 
	return NO; 
}

@end
