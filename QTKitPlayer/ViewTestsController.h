/*
    File:		ViewTestsController.h

    Copyright:	©2005 by Apple Computer, Inc., all rights reserved.

*/


#import <Cocoa/Cocoa.h>
#import <QTKit/QTKit.h>

@class QTMovieView;

@interface ViewTestsController : NSObject
{
    IBOutlet NSWindow 		*mViewTestsWindow;
    IBOutlet QTMovieView	*mSplitViewMovieView1;
    IBOutlet QTMovieView	*mSplitViewMovieView2;
    IBOutlet QTMovieView	*mSplitViewMovieView3;
    IBOutlet QTMovieView	*mTabViewMovieView1;
    IBOutlet QTMovieView	*mTabViewMovieView2;
    IBOutlet QTMovieView	*mScrollViewMovieView;
}

    // actions
- (IBAction)doSetMovies:(id)sender;
- (IBAction)doShowViewTestsWindow:(id)sender;

@end
