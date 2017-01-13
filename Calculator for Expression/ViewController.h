//
//  ViewController.h
//  Calculator for Expression
//
//  Created by victor on 31/12/2016.
//  Copyright © 2016 Victor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    IBOutlet UILabel *input;
    IBOutlet UILabel *output;
    
}

-(IBAction)input_pressed: (UIButton *)sender;
-(IBAction)output_pressed: (UIButton *)sender;

@end

