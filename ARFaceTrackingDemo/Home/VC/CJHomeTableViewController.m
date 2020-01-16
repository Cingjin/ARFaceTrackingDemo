//
//  CJHomeTableViewController.m
//  ARFaceTrackingDemo
//
//  Created by Anmo on 2020/1/16.
//  Copyright © 2020 com.Cingjin. All rights reserved.
//

#import "CJHomeTableViewController.h"
#import "CJFaceViewController.h"

@interface CJHomeTableViewController ()

/** titlesArr*/
@property (nonatomic ,copy) NSArray     * titlesArr;

@end

@implementation CJHomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self cj_baseSet];
}

- (void)cj_baseSet {
    
    self.title = @"ARKitDemo";
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.titlesArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.titlesArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView reloadData];

    CJFaceViewController * faceVC = [[CJFaceViewController alloc]init];
    faceVC.nodeType = indexPath.row;
    [self.navigationController pushViewController:faceVC animated:YES];

}

#pragma mark - Lazy

- (NSArray *)titlesArr {
    if (!_titlesArr) {
        _titlesArr = @[@"面部拓扑的网格",@"面具",@"机器人"];
    }
    return _titlesArr;
}


@end
