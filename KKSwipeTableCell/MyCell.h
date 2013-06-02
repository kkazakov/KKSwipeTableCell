//
//  MyCell.h
//  KKSwipeTableCell
//
//  Created by Krasimir Kazakov on 6/2/13.
//  Copyright (c) 2013 Krasimir Kazakov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKSwipeTableCell.h"

@interface MyCell : KKSwipeTableCell

@property (nonatomic, retain) IBOutlet UILabel * label1;

@property (nonatomic, retain) IBOutlet UIButton * btn1;
@property (nonatomic, retain) IBOutlet UIButton * btn2;
@property (nonatomic, retain) IBOutlet UIButton * btn3;


@end
