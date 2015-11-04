/*
    File:		OpenURLPanel.h

    Copyright:	©2004, 2005 by Apple Computer, Inc., all rights reserved.

*/


#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@interface OpenURLPanel : NSObject
{
        // panel
    IBOutlet NSPanel	*mPanel;
    IBOutlet NSComboBox	*mUrlComboBox;

        // open url panel
    id 					mDelegate;
    SEL					mDidEndSelector;
    void				*mContextInfo;
    NSMutableArray		*mUrlArray;
    BOOL				mIsSheet;
}

    // class methods
+ (id)openURLPanel;

    // getters
- (NSString *)urlString;
- (NSURL *)url;

    // setters
- (void)setURLArray:(NSMutableArray *)urlArray;

    // delegates
- (void)awakeFromNib;

    // notifications
- (void)writeURLs:(NSNotification *)notification;

    // actions
- (IBAction)doOpenURL:(id)sender;

    // methods
- (void)beginSheetWithWindow:(NSWindow *)window delegate:(id)delegate didEndSelector:(SEL)didEndSelector contextInfo:(void *)contextInfo;
- (void)close;

@end
