/*
    File:		ViewTestsController.m

    Copyright:	©2005 by Apple Computer, Inc., all rights reserved.

*/


#import "ViewTestsController.h"

@implementation ViewTestsController

-(void)awakeFromNib
{
	// we want to be notified when the window
	// is closing so we can do cleanup
    [ [NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(closeWin:)
       name:NSWindowWillCloseNotification object:mViewTestsWindow ];
}

	// returns YES if the movie is currently playing, NO if not
-(BOOL)isPlaying:(QTMovie *)aMovie
{
	if ([aMovie rate] == 0)
	{
		return NO;
	}
	
	return YES;
}

-(void)stopPlayingMovie:(QTMovie *)aMovie
{
	if ([self isPlaying:aMovie] == YES)
	{
		[aMovie stop];
	}
}


- (void)closeWin:(void *)userInfo
{
	// stop any currently playing movies
	[self stopPlayingMovie:[mSplitViewMovieView1 movie]];
	[self stopPlayingMovie:[mSplitViewMovieView2 movie]];
	[self stopPlayingMovie:[mSplitViewMovieView3 movie]];
	[self stopPlayingMovie:[mTabViewMovieView1 movie]];
	[self stopPlayingMovie:[mTabViewMovieView2 movie]];
	[self stopPlayingMovie:[mScrollViewMovieView movie]];

    // clear the movies that were previously set for each view
    [mSplitViewMovieView1 setMovie:NULL];
    [mSplitViewMovieView2 setMovie:NULL];
    [mSplitViewMovieView3 setMovie:NULL];
    [mTabViewMovieView1 setMovie:NULL];
    [mTabViewMovieView2 setMovie:NULL];
    [mScrollViewMovieView setMovie:NULL];

}

#pragma mark --- actions ---

- (QTMovie *)getAMovieFile
{
    NSOpenPanel *openPanel;
	
	openPanel = [NSOpenPanel openPanel];
    [openPanel setCanChooseDirectories:NO];

    if ([openPanel runModalForTypes:[QTMovie movieUnfilteredFileTypes]] == NSOKButton)
	{
        return [QTMovie movieWithFile:[openPanel filename] error:NULL];
	}

	return nil;
}

- (IBAction)doSetMovies:(id)sender
{
    // set the movies
    [mSplitViewMovieView1 setMovie:[self getAMovieFile]];
    [mSplitViewMovieView2 setMovie:[self getAMovieFile]];
    [mSplitViewMovieView3 setMovie:[self getAMovieFile]];
    [mTabViewMovieView1 setMovie:[self getAMovieFile]];
    [mTabViewMovieView2 setMovie:[self getAMovieFile]];
    [mScrollViewMovieView setMovie:[self getAMovieFile]];
}

- (IBAction)doShowViewTestsWindow:(id)sender
{
    // add a toolbar
    if ([mViewTestsWindow toolbar] == nil)
        [mViewTestsWindow setToolbar:[[[NSToolbar alloc] initWithIdentifier:@"QTKitPlayer"] autorelease]];

    // show the window
    [mViewTestsWindow makeKeyAndOrderFront:nil];
}

@end
