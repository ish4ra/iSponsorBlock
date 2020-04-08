#line 1 "Tweak.xm"
#import "iSponsorBlock.h"
#import "sponsorTimes.h"

YTDoubleTapToSeekController *YTDoubleTapToSeekControllerInstance;
MLHAMPlayer *MLHAMPlayerInstance;
YTWatchController *YTWatchControllerInstance;
MLNerdStatsPlaybackData *MLNerdStatsPlaybackDataInstance;

int secondVersionPart;
NSString *currentVideoID = nil;
BOOL didGetVideoIDWhenDataIsNil = FALSE;
NSString *videoIDWhenDataIsNil = nil;

dispatch_queue_t queue;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class YTMainWindow; @class YTWatchController; @class YTDoubleTapToSeekController; @class sponsorTimes; @class MLHAMPlayer; @class MLNerdStatsPlaybackData; 

static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$sponsorTimes(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("sponsorTimes"); } return _klass; }
#line 16 "Tweak.xm"
static YTDoubleTapToSeekController* (*_logos_orig$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$)(_LOGOS_SELF_TYPE_INIT YTDoubleTapToSeekController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static YTDoubleTapToSeekController* _logos_method$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$(_LOGOS_SELF_TYPE_INIT YTDoubleTapToSeekController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static YTMainWindow* (*_logos_orig$greaterthan08$YTMainWindow$initWithFrame$)(_LOGOS_SELF_TYPE_INIT YTMainWindow*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static YTMainWindow* _logos_method$greaterthan08$YTMainWindow$initWithFrame$(_LOGOS_SELF_TYPE_INIT YTMainWindow*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static void _logos_method$greaterthan08$YTMainWindow$skipFirstSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST, SEL, NSDictionary *); static void _logos_method$greaterthan08$YTMainWindow$skipSecondSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST, SEL, NSDictionary *); static YTWatchController* (*_logos_orig$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$)(_LOGOS_SELF_TYPE_INIT YTWatchController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static YTWatchController* _logos_method$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$(_LOGOS_SELF_TYPE_INIT YTWatchController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static MLNerdStatsPlaybackData* (*_logos_orig$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$)(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static MLNerdStatsPlaybackData* _logos_method$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; 


static YTDoubleTapToSeekController* _logos_method$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$(_LOGOS_SELF_TYPE_INIT YTDoubleTapToSeekController* __unused self, SEL __unused _cmd, id arg1, id arg2) _LOGOS_RETURN_RETAINED {
	YTDoubleTapToSeekControllerInstance = self;
	return _logos_orig$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$(self, _cmd, arg1, arg2);
}



static YTMainWindow* _logos_method$greaterthan08$YTMainWindow$initWithFrame$(_LOGOS_SELF_TYPE_INIT YTMainWindow* __unused self, SEL __unused _cmd, CGRect arg1) _LOGOS_RETURN_RETAINED {
	dispatch_async(queue, ^ {
		[NSThread sleepForTimeInterval:1.0f];
		currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
		while(TRUE){
			currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
			if(currentVideoID != nil){
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
				break;
			}
			else {
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[NSThread sleepForTimeInterval:0.5f];
				continue;
			}
		}
	});
	return _logos_orig$greaterthan08$YTMainWindow$initWithFrame$(self, _cmd, arg1);
}


static void _logos_method$greaterthan08$YTMainWindow$skipFirstSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * data) {
	currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
	if([data objectForKey:@"sponsorTimes"] != nil) {
		NSString *videoID = [data objectForKey:@"videoID"];
		if(currentVideoID == videoID) {
			int cnt = [[data objectForKey:@"sponsorTimes"]count];
			if(cnt > 1) {
				NSArray *firstSponsorship = [data objectForKey:@"sponsorTimes"][0];
				NSArray *secondSponsorship = [data objectForKey:@"sponsorTimes"][1];
				float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

				if(videoTime == ceil([firstSponsorship[0] floatValue])){
					CGFloat timeToSkip = [firstSponsorship[1] floatValue] - [firstSponsorship[0] floatValue];
					[YTDoubleTapToSeekControllerInstance attemptSeekByInterval:timeToSkip];
					
					[YTDoubleTapToSeekControllerInstance endDoubleTapToSeek];

					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						[self skipSecondSponsor:data];
					});
				}

				else if (videoTime < [firstSponsorship[0] floatValue]) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						[self skipFirstSponsor:data];
					});
				}
			else if (videoTime > [firstSponsorship[0] floatValue]) {
					dispatch_async(queue, ^{
						[NSThread sleepForTimeInterval:0.5f];
						currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
						[self skipSecondSponsor:data];
					});
				}
				else if (videoTime > [secondSponsorship[0] floatValue]) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
						[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					});
				}
			}

			if(cnt == 1) {
				NSArray *firstSponsorship = [data objectForKey:@"sponsorTimes"][0];
				float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

				if(videoTime == ceil([firstSponsorship[0] floatValue])){
					CGFloat timeToSkip = [firstSponsorship[1] floatValue] - [firstSponsorship[0] floatValue];
					[YTDoubleTapToSeekControllerInstance attemptSeekByInterval:timeToSkip];
					[YTDoubleTapToSeekControllerInstance endDoubleTapToSeek];
					dispatch_async(queue, ^ {
							[self skipFirstSponsor:nil];
					});
				}

				else if (videoTime < [firstSponsorship[0] floatValue]) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						[self skipFirstSponsor:data];
					});
				}

				else if(videoTime > [firstSponsorship[0] floatValue]) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
						[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					});
				}

			}
		}

		else {
			dispatch_async(queue, ^ {
				[NSThread sleepForTimeInterval:0.5f];
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
			});
		}

	}

	else {
		dispatch_async(queue, ^{
			if(didGetVideoIDWhenDataIsNil == FALSE){
				videoIDWhenDataIsNil = [MLNerdStatsPlaybackDataInstance videoID];
				didGetVideoIDWhenDataIsNil = TRUE;
			}
			while(TRUE){
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				if(currentVideoID != videoIDWhenDataIsNil){
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					didGetVideoIDWhenDataIsNil = FALSE;
					break;
				}
				else {
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					[NSThread sleepForTimeInterval:0.5f];
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					continue;
				}
			}
		});
	}

}


static void _logos_method$greaterthan08$YTMainWindow$skipSecondSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * data) {
	currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
	if([data objectForKey:@"sponsorTimes"] != nil) {
		NSString *videoID = [data objectForKey:@"videoID"];
		if(currentVideoID == videoID) {
			NSArray *secondSponsorship = [data objectForKey:@"sponsorTimes"][1];
			float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

			if(videoTime == ceil([secondSponsorship[0] floatValue])){

				CGFloat timeToSkip = [secondSponsorship[1] floatValue] - [secondSponsorship[0] floatValue];
				[YTDoubleTapToSeekControllerInstance attemptSeekByInterval:timeToSkip];
				[YTDoubleTapToSeekControllerInstance endDoubleTapToSeek];
				dispatch_async(queue, ^{
					[NSThread sleepForTimeInterval:0.5f];
					[self skipFirstSponsor:nil];
				});
			}
			else if(videoTime < [secondSponsorship[0] floatValue]){
				dispatch_async(queue, ^{
					[NSThread sleepForTimeInterval:0.5f];
					[self skipSecondSponsor:data];
				});
			}
			else if(videoTime > [secondSponsorship[0] floatValue]) {
				dispatch_async(queue, ^{
					[NSThread sleepForTimeInterval:0.5f];
					[self skipFirstSponsor:nil];
				});
			}
		}
		else {
			dispatch_async(queue, ^ {
				[NSThread sleepForTimeInterval:0.5f];
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
			});
		}
	}
}



static YTWatchController* _logos_method$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$(_LOGOS_SELF_TYPE_INIT YTWatchController* __unused self, SEL __unused _cmd, id arg1, id arg2) _LOGOS_RETURN_RETAINED {
	YTWatchControllerInstance = self;
	return _logos_orig$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$(self, _cmd, arg1, arg2);
}



static MLNerdStatsPlaybackData* _logos_method$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData* __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3) _LOGOS_RETURN_RETAINED {
	MLNerdStatsPlaybackDataInstance = self;
	return _logos_orig$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(self, _cmd, arg1, arg2, arg3);
}





static MLHAMPlayer* (*_logos_orig$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$)(_LOGOS_SELF_TYPE_INIT MLHAMPlayer*, SEL, id, id, id, id, id) _LOGOS_RETURN_RETAINED; static MLHAMPlayer* _logos_method$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$(_LOGOS_SELF_TYPE_INIT MLHAMPlayer*, SEL, id, id, id, id, id) _LOGOS_RETURN_RETAINED; static YTMainWindow* (*_logos_orig$lowerthan06$YTMainWindow$initWithFrame$)(_LOGOS_SELF_TYPE_INIT YTMainWindow*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static YTMainWindow* _logos_method$lowerthan06$YTMainWindow$initWithFrame$(_LOGOS_SELF_TYPE_INIT YTMainWindow*, SEL, CGRect) _LOGOS_RETURN_RETAINED; static void _logos_method$lowerthan06$YTMainWindow$skipFirstSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST, SEL, NSDictionary *); static void _logos_method$lowerthan06$YTMainWindow$skipSecondSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST, SEL, NSDictionary *); static YTWatchController* (*_logos_orig$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$)(_LOGOS_SELF_TYPE_INIT YTWatchController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static YTWatchController* _logos_method$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$(_LOGOS_SELF_TYPE_INIT YTWatchController*, SEL, id, id) _LOGOS_RETURN_RETAINED; static MLNerdStatsPlaybackData* (*_logos_orig$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$)(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; static MLNerdStatsPlaybackData* _logos_method$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData*, SEL, id, id, id) _LOGOS_RETURN_RETAINED; ;

static MLHAMPlayer* _logos_method$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$(_LOGOS_SELF_TYPE_INIT MLHAMPlayer* __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3, id arg4, id arg5) _LOGOS_RETURN_RETAINED {
	MLHAMPlayerInstance = self;
	return _logos_orig$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$(self, _cmd, arg1, arg2, arg3, arg4, arg5);
}



static YTMainWindow* _logos_method$lowerthan06$YTMainWindow$initWithFrame$(_LOGOS_SELF_TYPE_INIT YTMainWindow* __unused self, SEL __unused _cmd, CGRect arg1) _LOGOS_RETURN_RETAINED {
	dispatch_async(queue, ^ {
		[NSThread sleepForTimeInterval:1.0f];
		currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
		while(TRUE){
			currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
			if(currentVideoID != nil){
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
				break;
			}
			else {
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[NSThread sleepForTimeInterval:0.5f];
				continue;
			}
		}
	});
	return _logos_orig$lowerthan06$YTMainWindow$initWithFrame$(self, _cmd, arg1);
}


static void _logos_method$lowerthan06$YTMainWindow$skipFirstSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * data) {
	currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
	if([data objectForKey:@"sponsorTimes"] != nil) {
		NSString *videoID = [data objectForKey:@"videoID"];
		if(currentVideoID == videoID) {
			int cnt = [[data objectForKey:@"sponsorTimes"]count];
			if(cnt > 1) {
				NSArray *firstSponsorship = [data objectForKey:@"sponsorTimes"][0];
				float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

				if(videoTime == lroundf([firstSponsorship[0] floatValue])){
					dispatch_async(queue, ^ {
						[MLHAMPlayerInstance seekToTime:[firstSponsorship[1] floatValue]];
						[NSThread sleepForTimeInterval:0.5f];
						[self skipSecondSponsor:data];
					});
				}

				else if (videoTime < lroundf([firstSponsorship[0] floatValue])) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						[self skipFirstSponsor:data];
					});
				}
				else if (videoTime > lroundf([firstSponsorship[0] floatValue])) {
					dispatch_async(queue, ^{
						[NSThread sleepForTimeInterval:0.5f];
						currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
						[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					});
				}
			}

			if(cnt == 1) {
				NSArray *firstSponsorship = [data objectForKey:@"sponsorTimes"][0];
				float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

				if(videoTime == lroundf([firstSponsorship[0] floatValue])){
					dispatch_async(queue, ^ {
						[MLHAMPlayerInstance seekToTime:[firstSponsorship[1] floatValue]];
						[self skipFirstSponsor:nil];
					});
				}

				else if (videoTime < lroundf([firstSponsorship[0] floatValue])) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						[self skipFirstSponsor:data];
					});
				}

				else if(videoTime > lroundf([firstSponsorship[0] floatValue])) {
					dispatch_async(queue, ^ {
						[NSThread sleepForTimeInterval:0.5f];
						currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
						[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					});
				}

			}
		}

		else {
			dispatch_async(queue, ^ {
				[NSThread sleepForTimeInterval:0.5f];
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
			});
		}

	}

	else {
		dispatch_async(queue, ^{
			if(didGetVideoIDWhenDataIsNil == FALSE){
				videoIDWhenDataIsNil = [MLNerdStatsPlaybackDataInstance videoID];
				didGetVideoIDWhenDataIsNil = TRUE;
			}
			while(TRUE){
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				if(currentVideoID != videoIDWhenDataIsNil){
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
					didGetVideoIDWhenDataIsNil = FALSE;
					break;
				}
				else {
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					[NSThread sleepForTimeInterval:0.5f];
					currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
					continue;
				}
			}
		});
	}

}


static void _logos_method$lowerthan06$YTMainWindow$skipSecondSponsor$(_LOGOS_SELF_TYPE_NORMAL YTMainWindow* _LOGOS_SELF_CONST __unused self, SEL __unused _cmd, NSDictionary * data) {
	if([data objectForKey:@"sponsorTimes"] != nil) {
		NSString *videoID = [data objectForKey:@"videoID"];
		if(currentVideoID == videoID) {
			NSArray *secondSponsorship = [data objectForKey:@"sponsorTimes"][1];
			float videoTime = lroundf([YTWatchControllerInstance activeVideoMediaTime]);

			if(videoTime == lroundf([secondSponsorship[0] floatValue])){
				dispatch_async(queue, ^{
					[MLHAMPlayerInstance seekToTime:[secondSponsorship[1] floatValue]];
					[self skipFirstSponsor:nil];
				});
			}
			else if(videoTime < lroundf([secondSponsorship[0] floatValue])){
				dispatch_async(queue, ^{
					[NSThread sleepForTimeInterval:0.5f];
					[self skipSecondSponsor:data];
				});
			}
		}
		else {
			dispatch_async(queue, ^ {
				currentVideoID = [MLNerdStatsPlaybackDataInstance videoID];
				[_logos_static_class_lookup$sponsorTimes() getSponsorTimes:currentVideoID completionTarget:self completionSelector:@selector(skipFirstSponsor:)];
			});
		}
	}
}



static YTWatchController* _logos_method$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$(_LOGOS_SELF_TYPE_INIT YTWatchController* __unused self, SEL __unused _cmd, id arg1, id arg2) _LOGOS_RETURN_RETAINED {
	YTWatchControllerInstance = self;
	return _logos_orig$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$(self, _cmd, arg1, arg2);
}



static MLNerdStatsPlaybackData* _logos_method$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(_LOGOS_SELF_TYPE_INIT MLNerdStatsPlaybackData* __unused self, SEL __unused _cmd, id arg1, id arg2, id arg3) _LOGOS_RETURN_RETAINED {
	MLNerdStatsPlaybackDataInstance = self;
	return _logos_orig$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$(self, _cmd, arg1, arg2, arg3);
}



static __attribute__((constructor)) void _logosLocalCtor_d4641f91(int __unused argc, char __unused **argv, char __unused **envp) {
	queue = dispatch_queue_create("com.galacticdev.skipSponsorQueue", NULL);

	NSArray *version = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] componentsSeparatedByString:@"."];
	secondVersionPart = [version[1] intValue];

	if(secondVersionPart <= 8){
		{Class _logos_class$lowerthan06$MLHAMPlayer = objc_getClass("MLHAMPlayer"); MSHookMessageEx(_logos_class$lowerthan06$MLHAMPlayer, @selector(initWithVideo:playerConfig:stickySettings:playerView:frameSourceDelegate:), (IMP)&_logos_method$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$, (IMP*)&_logos_orig$lowerthan06$MLHAMPlayer$initWithVideo$playerConfig$stickySettings$playerView$frameSourceDelegate$);Class _logos_class$lowerthan06$YTMainWindow = objc_getClass("YTMainWindow"); MSHookMessageEx(_logos_class$lowerthan06$YTMainWindow, @selector(initWithFrame:), (IMP)&_logos_method$lowerthan06$YTMainWindow$initWithFrame$, (IMP*)&_logos_orig$lowerthan06$YTMainWindow$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$lowerthan06$YTMainWindow, @selector(skipFirstSponsor:), (IMP)&_logos_method$lowerthan06$YTMainWindow$skipFirstSponsor$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$lowerthan06$YTMainWindow, @selector(skipSecondSponsor:), (IMP)&_logos_method$lowerthan06$YTMainWindow$skipSecondSponsor$, _typeEncoding); }Class _logos_class$lowerthan06$YTWatchController = objc_getClass("YTWatchController"); MSHookMessageEx(_logos_class$lowerthan06$YTWatchController, @selector(initWithWatchFlowController:parentResponder:), (IMP)&_logos_method$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$, (IMP*)&_logos_orig$lowerthan06$YTWatchController$initWithWatchFlowController$parentResponder$);Class _logos_class$lowerthan06$MLNerdStatsPlaybackData = objc_getClass("MLNerdStatsPlaybackData"); MSHookMessageEx(_logos_class$lowerthan06$MLNerdStatsPlaybackData, @selector(initWithPlayer:videoID:CPN:), (IMP)&_logos_method$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$, (IMP*)&_logos_orig$lowerthan06$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$);}
	} else {
		{Class _logos_class$greaterthan08$YTDoubleTapToSeekController = objc_getClass("YTDoubleTapToSeekController"); MSHookMessageEx(_logos_class$greaterthan08$YTDoubleTapToSeekController, @selector(initWithDelegate:parentResponder:), (IMP)&_logos_method$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$, (IMP*)&_logos_orig$greaterthan08$YTDoubleTapToSeekController$initWithDelegate$parentResponder$);Class _logos_class$greaterthan08$YTMainWindow = objc_getClass("YTMainWindow"); MSHookMessageEx(_logos_class$greaterthan08$YTMainWindow, @selector(initWithFrame:), (IMP)&_logos_method$greaterthan08$YTMainWindow$initWithFrame$, (IMP*)&_logos_orig$greaterthan08$YTMainWindow$initWithFrame$);{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$greaterthan08$YTMainWindow, @selector(skipFirstSponsor:), (IMP)&_logos_method$greaterthan08$YTMainWindow$skipFirstSponsor$, _typeEncoding); }{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; memcpy(_typeEncoding + i, @encode(NSDictionary *), strlen(@encode(NSDictionary *))); i += strlen(@encode(NSDictionary *)); _typeEncoding[i] = '\0'; class_addMethod(_logos_class$greaterthan08$YTMainWindow, @selector(skipSecondSponsor:), (IMP)&_logos_method$greaterthan08$YTMainWindow$skipSecondSponsor$, _typeEncoding); }Class _logos_class$greaterthan08$YTWatchController = objc_getClass("YTWatchController"); MSHookMessageEx(_logos_class$greaterthan08$YTWatchController, @selector(initWithWatchFlowController:parentResponder:), (IMP)&_logos_method$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$, (IMP*)&_logos_orig$greaterthan08$YTWatchController$initWithWatchFlowController$parentResponder$);Class _logos_class$greaterthan08$MLNerdStatsPlaybackData = objc_getClass("MLNerdStatsPlaybackData"); MSHookMessageEx(_logos_class$greaterthan08$MLNerdStatsPlaybackData, @selector(initWithPlayer:videoID:CPN:), (IMP)&_logos_method$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$, (IMP*)&_logos_orig$greaterthan08$MLNerdStatsPlaybackData$initWithPlayer$videoID$CPN$);}
	}

}
