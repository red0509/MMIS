//
//  TableViewControllerRegister.h
//  DGTU
//
//  Created by Anton Pavlov on 26.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTMLReader.h>

@interface TableViewControllerRegister : UITableViewController

@property (strong,nonatomic) NSString *referenceUniversity;

-(void) loadRegister:(NSString*) URLFacul;



@end
