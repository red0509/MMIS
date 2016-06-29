//
//  ViewControllerPageContent.h
//  DGTU
//
//  Created by Anton Pavlov on 18.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>


@interface ViewControllerPageContent : UIViewController <UITableViewDataSource , UITableViewDelegate>

@property (strong,nonatomic) HTMLDocument *document;
@property (strong,nonatomic) NSString *referenceContent;
@property (strong,nonatomic) NSString *referenceUniversity;
@property (strong, nonatomic) IBOutlet UIView *viewSeg;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmented;
- (IBAction)actionSegmented:(id)sender;
@end
