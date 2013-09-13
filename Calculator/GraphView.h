//
//  GraphView.h
//  Calculator
//
//  Created by Nop Jiarathanakul on 9/13/13.
//  Copyright (c) 2013 Prutsdom Jiarathanakul. All rights reserved.
//

#import <UIKit/UIKit.h>

// forward declaration
@class GraphView;

// delegation
@protocol GraphViewDataSource
- (id)programForGraphView:(GraphView *)sender;
@end

@interface GraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;

@end