//
//  ViewController.m
//  Calculator for Expression
//
//  Created by victor on 31/12/2016.
//  Copyright © 2016 Victor. All rights reserved.
//

#import "ViewController.h"
#import <Foundation/Foundation.h>

@implementation ViewController

-(bool) priority:(char) top :(char) current
{
    if(top=='*'||top=='/'){
        return YES;
    }
    else if((top=='+'||top=='-')&&(current=='+'||current=='-')){
        return YES;
    }
    else{
        return NO;
    }
}
-(NSString *)convert_Infix_to_Suffix: (NSString *)infix
{
    NSMutableString *suffix=[NSMutableString string];
    NSMutableArray *mark=[[NSMutableArray alloc]init];
    char current;
    int i;
    for(i=0;i<[infix length];i++){
        current=[infix characterAtIndex:i];
        switch(current) {
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '.':
                [suffix appendString:[NSString stringWithFormat:@"%c",current]];
                break;
                
            case '+':
            case '-':
            case '*':
            case '/':
                if ([infix characterAtIndex:(i-1)] != ')')
                    [suffix appendString:[NSString stringWithFormat:@"%c",'#']];
                if (mark.count!=0) {
                    id top = [mark lastObject];
                    char topp=[[NSString stringWithFormat:@"%@",top]characterAtIndex:0];
                    while (topp != '(' && [self priority: topp:current]) {
                        [suffix appendString:[NSString stringWithFormat:@"%@",top]];
                        [mark removeLastObject];
                        if (mark.count==0)break;
                        top = [mark lastObject];
                        topp=[[NSString stringWithFormat:@"%@",top]characterAtIndex:0];
                    }
                }
                [mark addObject:[NSString stringWithFormat:@"%c",current]];
                break;
                
            case '(':
                if ([infix characterAtIndex:i-1] <= '9' && [infix characterAtIndex:i-1] >= '0') {
                    [mark addObject:[NSString stringWithFormat:@"%c",'*']];
                    [suffix appendString:[NSString stringWithFormat:@"%c",'#']];
                }
                [mark addObject:[NSString stringWithFormat:@"%c",current]];
                break;
            case ')':
                [suffix appendString:[NSString stringWithFormat:@"%c",'#']];
                while (![[mark lastObject]isEqualToString:@"("]) {
                    [suffix appendString:[NSString stringWithFormat:@"%@", [mark lastObject]]];
                    [mark removeLastObject];
                }
                break;
            default:
                break;
        }
    }
    
    if([infix characterAtIndex:[infix length]-1]!=')'){
        [suffix appendString:[NSString stringWithFormat:@"%c",'#']];
    }
    while(mark.count!=0){
        [suffix appendString:[NSString stringWithFormat:@"%@",[mark lastObject]]];
        [mark removeLastObject];
    }
    NSLog(@"%@",suffix);
    return suffix;
}

-(double) calculate_Suffix:(NSString *)suffix
{
    NSMutableArray *num=[[NSMutableArray alloc]init];
    NSMutableString *strnum=[NSMutableString string];
    double temp;
    int i;
    for(i=0;i<[suffix length];i++){
        char current=[suffix characterAtIndex:i];
        switch(current){
            case '0':
            case '1':
            case '2':
            case '3':
            case '4':
            case '5':
            case '6':
            case '7':
            case '8':
            case '9':
            case '.':
                [strnum appendString:[NSString stringWithFormat:@"%c",current]];
                break;
            case'+':
                temp=[[num lastObject]doubleValue];
                [num removeLastObject];
                temp+=[[num lastObject]doubleValue];
                [num removeLastObject];
                [num addObject:[NSString stringWithFormat:@"%f",temp]];
                break;
            case'-':
                temp=[[num lastObject]doubleValue];
                [num removeLastObject];
                temp=[[num lastObject]doubleValue]-temp;
                [num removeLastObject];
                [num addObject:[NSString stringWithFormat:@"%f",temp]];
                break;
            case'/':
                temp=[[num lastObject]doubleValue];
                [num removeLastObject];
                temp=[[num lastObject]doubleValue]/temp;
                [num removeLastObject];
                [num addObject:[NSString stringWithFormat:@"%f",temp]];
                break;
            case'*':
                temp=[[num lastObject]doubleValue];
                [num removeLastObject];
                temp*=[[num lastObject]doubleValue];
                [num removeLastObject];
                [num addObject:[NSString stringWithFormat:@"%f",temp]];
                break;
            case'#':
                [num addObject:[NSString stringWithFormat:@"%f",[strnum doubleValue]]];
                [strnum setString:@""];
                break;
        }
    }
    return [[num lastObject]doubleValue];
}
-(double)calculate_Infix: (NSString *)expression
{
    return [self calculate_Suffix:[self convert_Infix_to_Suffix:expression ]];
}
-(IBAction)input_pressed: (UIButton *)sender
{
    NSString *in = [[sender titleLabel]text];
    [input setText: [[input text]stringByAppendingString:in]];
}
-(IBAction)output_pressed: (UIButton *)sender
{
    NSString *out = [[sender titleLabel]text];
    if([out isEqual:@"="]){
        NSString *expression=[input text];
        [output setText: [NSString stringWithFormat: @"%f",[self calculate_Infix:expression]]];
    }
    else{
        [output setText:@""];
        [input setText:@""];
    }
}

@end
