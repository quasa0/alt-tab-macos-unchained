@import Cocoa;
#import "AppCenterApplication.h"

@implementation AppCenterApplication

- (void)reportException:(NSException *)exception {
    [super reportException:exception];
}

- (void)sendEvent:(NSEvent *)theEvent {
    @try {
        [super sendEvent:theEvent];
    } @catch (NSException *exception) {
        [self reportException:exception];
    }
}

@end
