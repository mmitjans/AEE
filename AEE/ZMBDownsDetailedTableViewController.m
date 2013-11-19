//
//  ZMBDownsDetailedTableViewController.m
//  AEE
//
//  Created by Milton D. Mitjans on 6/12/13.
//  Copyright (c) 2013 Milton D. Mitjans. All rights reserved.
//

#import "ZMBDownsDetailedTableViewController.h"

#import "ZMBDownsDetailedTableViewCell.h"

#import "BreakdownReportSvc.h"

#import "ZMGradientView.h"
#import "ZMMapViewController.h"

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>
@interface ZMBDownsDetailedTableViewController ()

@end

@implementation ZMBDownsDetailedTableViewController

@synthesize townName;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    
    return self;
}
- (IBAction)mapNeeded:(id)sender {
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(semiModalDismissed:)
                                                 name:kSemiModalDidHideNotification
                                               object:nil];
    
    myView = [[ZMMapViewController alloc] initWithNibName:@"ZMMapViewController" bundle:nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)semiModalDismissed:(NSNotification *) notification {
    if (notification.object == self) {
        NSLog(@"A view controller was dismissed with semi modal annimation");
        
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.townName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DetailedCell";
    ZMBDownsDetailedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSMutableArray *myArray = [self.townName mutableCopy];
    
    ax22_BreakdownArea *area = [myArray objectAtIndex:indexPath.row];
    cell.area.text = area.r2Area;
    cell.status.text = area.r3Status;
    cell.lastUpdate.text = area.r4LastUpdate;
    
    cell.backgroundView = [[ZMGradientView alloc] init];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *myArray = [self.townName mutableCopy];
    
    ax22_BreakdownArea *area = [myArray objectAtIndex:indexPath.row];
    
    NSString *barrioName = [area r2Area];
    
    NSString *search = @"Bo ";
    
    NSRange theRange = [barrioName rangeOfString:search];
    
    if (theRange.location != NSNotFound) {
        
        NSString *sub =
            [barrioName substringFromIndex:NSMaxRange(theRange)];
        [myView setBarrioName:sub];
    } else {
        [myView setBarrioName:barrioName];
    }
    
    [myView setPuebloName:[area r1TownOrCity]];
    
    [self presentSemiViewController:myView withOptions:@{
     KNSemiModalOptionKeys.pushParentBack    : @(YES),
     KNSemiModalOptionKeys.animationDuration : @(1.0),
     KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
	 }];
}

@end
