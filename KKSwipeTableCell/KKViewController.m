//
//  KKViewController.m
//  KKSwipeTableCell
//
//  Created by Krasimir Kazakov on 6/2/13.
//  Copyright (c) 2013 Krasimir Kazakov. All rights reserved.
//

#import "KKViewController.h"
#import "KKSwipeTableCell.h"
#import "MyCell.h"

@interface KKViewController ()

@end

@implementation KKViewController {
    NSMutableArray * myData;
    
    NSIndexPath * selectedIndexPath; // used for remove button later
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    myData = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 20; i++) {
        [myData addObject:[NSString stringWithFormat:@"Label %d", i]];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [myData count];
}

- (NSIndexPath*) getSelectedCellIndexPath
{
    NSArray * cells = [self.tableView visibleCells];
    
    for (KKSwipeTableCell * cell in cells) {
        if (cell.isCellOpen) {
            return [self.tableView indexPathForCell:cell];
        }
    }
    return nil;
}

- (void) btn1pressed
{
    NSIndexPath * indexPath = [self getSelectedCellIndexPath];
    if (indexPath == nil) return;

    NSLog(@"Pressed button 1 for cell %d, %@", indexPath.row, [myData objectAtIndex:indexPath.row]);
    
    // example for how to close a cell, when certain button is pressed
    KKSwipeTableCell * cell = (KKSwipeTableCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    [cell closeCell:YES];
}
- (void) btn2pressed
{
    NSIndexPath * indexPath = [self getSelectedCellIndexPath];
    if (indexPath == nil) return;
    
    NSLog(@"Pressed button 2 for cell %d, %@", indexPath.row, [myData objectAtIndex:indexPath.row]);
}

// this alertview is displayed when tapping button 3

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { //cancel
        if (alertView.tag == 157) {
            
            // close opened cell
            KKSwipeTableCell * cell = (KKSwipeTableCell*) [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            [cell closeCell:YES];

        }
    }
    if (buttonIndex == 1) {
        if (alertView.tag == 157) {
            
            // close opened cell
            //KKSwipeTableCell * cell = (KKSwipeTableCell*) [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            //[cell closeCell:NO];
            
            
            // do some other stuff - you have selectedIndexPath
            // .. you can call server method here
            
            // remove from our data
            [myData removeObjectAtIndex:selectedIndexPath.row];
            
            // remove cell
            KKSwipeTableCell * cell = (KKSwipeTableCell*) [self.tableView cellForRowAtIndexPath:selectedIndexPath];
            [cell removeCellFromSuperView];
            
        }
    }
}



- (void) btn3pressed
{
    NSIndexPath * indexPath = [self getSelectedCellIndexPath];
    if (indexPath == nil) return;
    
    // we use this later in alertView clickedButtonAtIndex
    selectedIndexPath = indexPath;
    
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Remove entry"
                              message:[NSString stringWithFormat:@"Are you sure that you want to remove entry %@", [myData objectAtIndex:indexPath.row]]
                              delegate:self
                              cancelButtonTitle:@"Cancel"
                              otherButtonTitles:@"Remove",nil];
    alertView.tag = 157;
    [alertView show];

    NSLog(@"Pressed button 3 for cell %d, %@", indexPath.row, [myData objectAtIndex:indexPath.row]);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    // KKSwipeTableCell properties

    cell.openPosition = 225; // opened position value
    cell.animationDuration = 0.3; // duration for opening

    // custom cell properties
    cell.label1.text = (NSString*) [myData objectAtIndex:indexPath.row];

    // button handling example
    [cell.btn1 addTarget:self action:@selector(btn1pressed) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(btn2pressed) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn3 addTarget:self action:@selector(btn3pressed) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KKSwipeTableCell * cell = (KKSwipeTableCell*) [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isCellOpen]) {
        // do nothing when tapping open cell
        return;
    }

    // do whatever you want here

    NSLog(@"Tapped cell at indexPath: %d, %d", indexPath.section, indexPath.row);


}

@end
