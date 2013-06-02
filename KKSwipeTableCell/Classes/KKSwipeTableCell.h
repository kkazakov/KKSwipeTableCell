//
//  KKSwipeTableCell.h
//  KKSwipeTableCell
//
//  Created by Krasimir Kazakov on 6/2/13.
//  Copyright (c) 2013 Krasimir Kazakov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KKSwipeTableCell : UITableViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, retain) IBOutlet UIView * viewStatic;
@property (nonatomic, retain) IBOutlet UIView * viewMovable;

@property (nonatomic) bool isCellOpen;

@property (nonatomic) int openPosition;
@property (nonatomic) float animationDuration;


- (void) removeCellFromSuperView;
- (void) closeCell:(bool)animated;

@end
