//
//  AppDelegate.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "APLProduct.h"

@interface SearchResultsTableViewController ()

@end

@implementation SearchResultsTableViewController

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.filteredProducts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"ResultsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    APLProduct *product = self.filteredProducts[indexPath.row];
    cell.textLabel.text = product.title;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *priceString = [numberFormatter stringFromNumber:product.introPrice];
    NSString *detailedStr = [NSString stringWithFormat:@"%@ | %@", priceString, (product.yearIntroduced).stringValue];
    cell.detailTextLabel.text = detailedStr;
    
    return cell;
}

@end
