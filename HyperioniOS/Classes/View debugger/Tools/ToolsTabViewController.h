//
//  ToolsTabViewController.h
//  WhatIsThatFont
//
//  Created by Chris Mays on 5/2/17.
//  Copyright © 2017 Willow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InteractionView;

@protocol ToolsTabViewControllerDelegate

-(void)toolSelectedWithInteractionView:(InteractionView *)view;

@end

@interface ToolsTabViewController : UIViewController

@property (nonatomic, weak) id<ToolsTabViewControllerDelegate> delegate;

@end
