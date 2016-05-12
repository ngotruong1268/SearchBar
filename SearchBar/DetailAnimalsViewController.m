//
//  DetailAnimalsViewController.m
//  SearchBar
//
//  Created by Ngô Sỹ Trường on 5/12/16.
//  Copyright © 2016 ngotruong. All rights reserved.
//

#import "DetailAnimalsViewController.h"

@interface DetailAnimalsViewController ()

@end

@implementation DetailAnimalsViewController
{
    UIImageView *images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor brownColor];
    self.title = self.titleContents;
    images = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imageAnimals]];
    images.frame = CGRectMake(50, 120, 200, 200);
    
    [self.view addSubview:images];
}


@end
