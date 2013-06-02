//
//  KKSwipeTableCell.m
//  KKSwipeTableCell
//
//  Created by Krasimir Kazakov on 6/2/13.
//  Copyright (c) 2013 Krasimir Kazakov. All rights reserved.
//

#import "KKSwipeTableCell.h"

@implementation KKSwipeTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {

    if ( !(self = [super initWithCoder:aDecoder]) ) return nil;
    
    [self initCell];
    
    return self;
}

- (void)prepareForReuse
{
    [self closeCell:NO];
}

- (void)initCell
{
    // by default - 3/4. Can be customized for each cell
    self.openPosition = (self.frame.size.width / 4 * 3);
    self.animationDuration = 0.3;

    UISwipeGestureRecognizer* gestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedRight:)];
    [gestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:gestureRight];

    UISwipeGestureRecognizer* gestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(cellSwipedLeft:)];
    [gestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:gestureLeft];
    
    self.isCellOpen = NO;

}

- (void) openCell
{
    if (self.isCellOpen) return;

    CGRect frame = self.viewMovable.frame;
    frame.origin.x = self.openPosition;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.animationDuration];
    self.viewMovable.frame = frame;
    [UIView commitAnimations];
    
    self.isCellOpen = YES;

}

- (void) removeCellFromSuperView
{
    CGRect frame1 = self.viewStatic.frame;
    CGRect frame2 = self.viewMovable.frame;

    int w = self.frame.size.width;
    
    int offs = w - frame1.origin.x;

    frame1.origin.x = w + 1; // outside the screen
    frame2.origin.x = frame2.origin.x + offs + 1; // outside the screen
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:self.animationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeCellRowAnimated)];
    
    self.viewStatic.frame = frame1;
    self.viewMovable.frame = frame2;
    
    [UIView commitAnimations];
    
    //[self removeCellRowAnimated];
}

- (void) removeCellRowAnimated
{
    UITableView * tv = (UITableView *) self.superview;
    
    NSArray *deleteIndexPaths = [[NSArray alloc] initWithObjects:[tv indexPathForCell:self], nil];
    [tv beginUpdates];
    [tv deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [tv endUpdates];
}

- (void) closeCell:(bool)animated
{
    if (!self.isCellOpen) return;
    
    CGRect frame = self.viewMovable.frame;
    frame.origin.x = 0;

    if (!animated) {
        self.viewMovable.frame = frame;
    } else {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.animationDuration];
        self.viewMovable.frame = frame;
        [UIView commitAnimations];
    }

    self.isCellOpen = NO;
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if(!newSuperview) {
        [self closeCell:NO];
    }
}

- (void)cellSwipedLeft:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self closeCell:YES];
    }
}

- (void)cellSwipedRight:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (![self.superview isKindOfClass:[UITableView class]]) {
            [NSException raise:@"Invalid superview, not a tableview" format:nil];
        }
        
        UITableView * tv = (UITableView *) self.superview;
        
        NSArray * cells = [tv visibleCells];
        
        for (KKSwipeTableCell * cell in cells) {
            if (cell.isCellOpen) {
                [cell closeCell:YES];
            }
        }
        
        [self openCell];
    }
}



@end
