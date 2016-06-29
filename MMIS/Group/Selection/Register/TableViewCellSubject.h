//
//  TableViewCellSubject.h
//  DGTU
//
//  Created by Anton Pavlov on 30.01.16.
//  Copyright © 2016 Anton Pavlov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCellSubject : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (strong , nonatomic) NSString *cellSubjectReference;

@end
