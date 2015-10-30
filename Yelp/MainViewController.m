//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpBusiness.h"
#import "YelpBusinessCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSArray *yelpBusinesses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UISearchController *searchController;
@property UISearchBar *searchBar;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpBusinessCell" bundle:nil] forCellReuseIdentifier:@"YelpBusinessCell"];
    self.tableView.estimatedRowHeight = 86;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
//    self.title = @"Yelp";
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 0, 100, 30);
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 1.0f;
    [button setTitle:@"Filters" forState:UIControlStateNormal];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [leftButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                          forState:UIControlStateNormal];
//    [leftButton setCustomView:<#(__kindof UIView * _Nullable)#>]
//    leftButton.
//    [leftButton set
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = YES;
    [self.searchBar sizeToFit];
    [self.searchBar setTintColor:[UIColor blackColor]];
    self.searchBar.placeholder = @"Restaurants";
    self.searchBar.delegate = self;
    
//    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
//    [barWrapper addSubview:searchBar];
    self.navigationItem.titleView = self.searchBar;
    
    [YelpBusiness searchWithTerm:@"Restaurants"
                        sortMode:YelpSortModeBestMatched
                      categories:@[@"burgers"]
                           deals:NO
                      completion:^(NSArray *businesses, NSError *error) {
                          for (YelpBusiness *business in businesses) {
                              NSLog(@"%@", business);
                          }
                          self.yelpBusinesses = businesses;
                          [self.tableView reloadData];
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.yelpBusinesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YelpBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpBusinessCell"];
    cell.yelpBusiness = self.yelpBusinesses[indexPath.row];
    return cell;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSLog(searchText);
}


@end
