//
//  AppDelegate.m
//  QiNavigationBar
//
//  Created by wangdacheng on 2019/3/26.
//  Copyright © 2019 dac_1033. All rights reserved.
//

#import "LargeTitleTableViewController.h"
#import "SearchResultsTableViewController.h"
#import "APLProduct.h"

@interface LargeTitleTableViewController () <UISearchResultsUpdating>

@property (nonatomic, copy) NSArray *products;
@property (nonatomic, strong) UISearchController *searchController;

@end

@implementation LargeTitleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"LargeTitle";
    
    [self setupData];
    [self setupViews];
    [self setupNavBarStyle];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    }
}

- (void)setupNavBarStyle {
    
    // 设置导航栏属性
    NSDictionary  *textAttributes=@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:30]};
    [self.navigationController.navigationBar setTitleTextAttributes:textAttributes];
    
//    // 设置导航栏背景图
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_handscene_timing"] forBarMetrics:UIBarMetricsDefault];
}

- (void)setupViews {
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    if (@available(iOS 10.0, *)) {
        [self.tableView setRefreshControl:refreshControl];
    } else {
        [self.tableView addSubview:refreshControl];
    }
    
    SearchResultsTableViewController* resultsController = [[SearchResultsTableViewController alloc] init];
    _searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
    _searchController.searchResultsUpdater = self;
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = _searchController;
    } else {
        self.tableView.tableHeaderView = _searchController.searchBar;
    }
    
    // Search is now just presenting a view controller. As such, normal view controller
    // presentation semantics apply. Namely that presentation will walk up the view controller
    // hierarchy until it finds the root view controller or one that defines a presentation context.
    // know where you want UISearchController to be displayed
    self.definesPresentationContext = YES;
}

- (void)beginRefresh:(UIRefreshControl *)control {
    
    [control endRefreshing];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.products.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"UITableViewControllerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    APLProduct *product = self.products[indexPath.row];
    cell.textLabel.text = product.title;
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    NSString *priceString = [numberFormatter stringFromNumber:product.introPrice];
    NSString *detailedStr = [NSString stringWithFormat:@"%@ | %@", priceString, (product.yearIntroduced).stringValue];
    cell.detailTextLabel.text = detailedStr;
    
    return cell;
}


#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    // update the filtered array based on the search text
    NSString *searchText = searchController.searchBar.text;
    NSMutableArray *searchResults = [self.products mutableCopy];
    
    // strip out all the leading and trailing spaces
    NSString *strippedString = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    // break up the search terms (separated by spaces)
    NSArray *searchItems = nil;
    if (strippedString.length > 0) {
        searchItems = [strippedString componentsSeparatedByString:@" "];
    }
    
    // build all the "AND" expressions for each value in the searchString
    //
    NSMutableArray *andMatchPredicates = [NSMutableArray array];
    
    for (NSString *searchString in searchItems) {
        // each searchString creates an OR predicate for: name, yearIntroduced, introPrice
        //
        // example if searchItems contains "iphone 599 2007":
        //      name CONTAINS[c] "iphone"
        //      name CONTAINS[c] "599", yearIntroduced ==[c] 599, introPrice ==[c] 599
        //      name CONTAINS[c] "2007", yearIntroduced ==[c] 2007, introPrice ==[c] 2007
        //
        NSMutableArray *searchItemsPredicate = [NSMutableArray array];
        
        // Below we use NSExpression represent expressions in our predicates.
        // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value)
        
        // name field matching
        NSExpression *lhs = [NSExpression expressionForKeyPath:@"title"];
        NSExpression *rhs = [NSExpression expressionForConstantValue:searchString];
        NSPredicate *finalPredicate = [NSComparisonPredicate
                                       predicateWithLeftExpression:lhs
                                       rightExpression:rhs
                                       modifier:NSDirectPredicateModifier
                                       type:NSContainsPredicateOperatorType
                                       options:NSCaseInsensitivePredicateOption];
        [searchItemsPredicate addObject:finalPredicate];
        
        // yearIntroduced field matching
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        numberFormatter.numberStyle = NSNumberFormatterNoStyle;
        NSNumber *targetNumber = [numberFormatter numberFromString:searchString];
        if (targetNumber != nil) {   // searchString may not convert to a number
            lhs = [NSExpression expressionForKeyPath:@"yearIntroduced"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
            
            // price field matching
            lhs = [NSExpression expressionForKeyPath:@"introPrice"];
            rhs = [NSExpression expressionForConstantValue:targetNumber];
            finalPredicate = [NSComparisonPredicate
                              predicateWithLeftExpression:lhs
                              rightExpression:rhs
                              modifier:NSDirectPredicateModifier
                              type:NSEqualToPredicateOperatorType
                              options:NSCaseInsensitivePredicateOption];
            [searchItemsPredicate addObject:finalPredicate];
        }
        
        // at this OR predicate to our master AND predicate
        NSCompoundPredicate *orMatchPredicates = [NSCompoundPredicate orPredicateWithSubpredicates:searchItemsPredicate];
        [andMatchPredicates addObject:orMatchPredicates];
    }
    
    // match up the fields of the Product object
    NSCompoundPredicate *finalCompoundPredicate =
    [NSCompoundPredicate andPredicateWithSubpredicates:andMatchPredicates];
    searchResults = [[searchResults filteredArrayUsingPredicate:finalCompoundPredicate] mutableCopy];
    
    // hand over the filtered results to our search results table
    SearchResultsTableViewController *tableController = (SearchResultsTableViewController *)searchController.searchResultsController;
    tableController.filteredProducts = searchResults;
    [tableController.tableView reloadData];
}

- (void)setupData {
    
    NSArray *products = @[[APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iPhone"
                                                 year:@2007
                                                price:@599.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iPod"
                                                 year:@2001
                                                price:@399.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iPod touch"
                                                 year:@2007
                                                price:@210.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iPad"
                                                 year:@2010
                                                price:@499.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iPad mini"
                                                 year:@2012
                                                price:@659.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"iMac"
                                                 year:@1997
                                                price:@1299.00],
                          [APLProduct productWithType:[APLProduct deviceTypeTitle]
                                                 name:@"Mac Pro"
                                                 year:@2006
                                                price:@2499.00],
                          [APLProduct productWithType:[APLProduct portableTypeTitle]
                                                 name:@"MacBook Air"
                                                 year:@2008
                                                price:@1799.00],
                          [APLProduct productWithType:[APLProduct portableTypeTitle]
                                                 name:@"MacBook Pro"
                                                 year:@2006
                                                price:@1499.00]
                          ];
    self.products = products;
}
@end
