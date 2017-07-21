//
//  HYPOverlayContainerImp.m
//  Pods
//
//  Created by Chris Mays on 6/19/17.
//
//

#import "HYPOverlayContainerImp.h"
#import "HYPOverlayContainerListener.h"
#import "HYPListenerContainer.h"

@interface HYPOverlayContainerImp ()

@property (nonatomic) UIView *currentOverlay;
@property (nonatomic) NSMutableArray *listeners;

@end

@implementation HYPOverlayContainerImp

@synthesize overlayModule = _overlayModule;

-(void)setOverlayModule:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayModule
{
    _overlayModule = overlayModule;

    for (UIView *subview in self.subviews)
    {
        if (subview != self.snapshotView)
        {
            [subview removeFromSuperview];
        }
    }

    if (!overlayModule)
    {
        [self notifyOverlayModuleChanged:nil];
        return ;
    }

    UIView *newOverlay = overlayModule.overlayView;

    [self addSubview:newOverlay];
    newOverlay.frame = self.bounds;
    [self notifyOverlayModuleChanged:_overlayModule];
}

-(void)setSnapshotView:(UIView *)snapshotView
{
    [_snapshotView removeFromSuperview];
    _snapshotView = snapshotView;
    _currentOverlay.frame = _snapshotView.frame;
    [self addSubview:snapshotView];
    [self sendSubviewToBack:snapshotView];
}

-(void)notifyOverlayModuleChanged:(id<HYPPluginModule, HYPOverlayViewProvider>)overlayModule
{
    for (HYPListenerContainer *container in self.listeners)
    {
        id<HYPOverlayContainerListener> listener = (id<HYPOverlayContainerListener>)container.listener;

        if ([listener conformsToProtocol:@protocol(HYPOverlayContainerListener)])
        {
            [listener overlayModuleChanged:overlayModule];
        }
    }
}

-(void)addContainerListener:(NSObject<HYPOverlayContainerListener> *)listener
{
    HYPListenerContainer *container = [[HYPListenerContainer alloc] initWithListener:listener];

    self.listeners = self.listeners ?: [[NSMutableArray alloc] init];

    [self.listeners addObject:container];

}

-(void)removeContainerListener:(NSObject<HYPOverlayContainerListener> *)listener
{
    NSMutableArray *mutableListeners = [[NSMutableArray alloc] initWithArray:self.listeners];

    for (HYPListenerContainer *listenerContainer in self.listeners)
    {
        if (listenerContainer.listener != listener)
        {
            [mutableListeners addObject:listenerContainer];
        }
    }

    self.listeners = mutableListeners;
}

-(NSUInteger)numberOfOverlays
{
    //Don't count the snapshotview
    return [[self subviews] count] - 1;
}

@end