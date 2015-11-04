/*
    File:		QTKitPlayerAppDelegate.h

    Copyright:	©2005 by Apple Computer, Inc., all rights reserved.

*/

#import <Cocoa/Cocoa.h>
#import "OpenURLPanel.h"

@interface QTKitPlayerAppDelegate : NSObject

	// NSMenu validation protocol
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem;

  // OpenURLPanel delegates
- (void)openURLPanelDidEnd:(OpenURLPanel *)openURLPanel returnCode:(int)returnCode contextInfo:(void *)contextInfo;

    // actions
- (IBAction)doOpenURL:(id)sender;
- (IBAction)doOpenURLData:(id)sender;

    // methods
- (BOOL)createMovieDocumentWithURL:(NSURL *)url asData:(BOOL)asData;

@end
