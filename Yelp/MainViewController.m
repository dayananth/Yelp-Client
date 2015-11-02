//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "FiltersViewController.h"
#import "YelpBusiness.h"
#import "YelpBusinessCell.h"

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, FiltersViewControllerDelegate>
@property (nonatomic, strong) NSArray *yelpBusinesses;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property UISearchController *searchController;
@property NSMutableArray *filteredData;
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
    [button addTarget:self action:@selector(onFilterButton) forControlEvents:UIControlEventAllEvents];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    [leftButton setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                          forState:UIControlStateNormal];
//    [leftButton setCustomView:<#(__kindof UIView * _Nullable)#>]
//    leftButton.
//    [leftButton set
    self.navigationItem.leftBarButtonItem = leftButton;
    
//    self.searchController.searchBar = [[UISearchBar alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchController.searchBar.showsCancelButton = YES;
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setTintColor:[UIColor blackColor]];
    self.searchController.searchBar.placeholder = @"Restaurants";
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    
//    UIView *barWrapper = [[UIView alloc]initWithFrame:searchBar.bounds];
//    [barWrapper addSubview:searchBar];
    self.searchController.hidesNavigationBarDuringPresentation = false;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.navigationItem.titleView = self.searchController.searchBar;
    self.definesPresentationContext = true;
    
    [self searchWithTerm:@"Restaurants"
                        sortMode:YelpSortModeBestMatched
                      categories:@[@"burgers"]
                           deals:NO
                           radius:nil
//                      completion:^(NSArray *businesses, NSError *error) {
//                          for (YelpBusiness *business in businesses) {
//                              NSLog(@"%@", business);
//                          }
//                          self.yelpBusinesses = businesses;
//                          self.filteredData = [[NSMutableArray alloc] initWithCapacity:self.yelpBusinesses.count];
//                          [self.tableView reloadData];
//                      }
     ];
}


-(void) searchWithTerm:term
        sortMode:(YelpSortMode)sortMode categories:(NSArray *)categories deals:(BOOL)hasDeal
                radius:(NSDecimalNumber *)radius{
    
    [YelpBusiness searchWithTerm:term
                        sortMode:sortMode
                      categories:categories
                           deals:hasDeal
                        radius:radius
                      completion:^(NSArray *businesses, NSError *error) {
                          for (YelpBusiness *business in businesses) {
                              NSLog(@"%@", business);
                          }
                          self.yelpBusinesses = businesses;
                          self.filteredData = [[NSMutableArray alloc] initWithCapacity:self.yelpBusinesses.count];
                          [self.tableView reloadData];
                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.searchController.active){
        return self.filteredData.count;
    }
    return self.yelpBusinesses.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    YelpBusinessCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpBusinessCell"];
    if(self.searchController.active){
        cell.yelpBusiness = self.filteredData[indexPath.row];
    }else{
        cell.yelpBusiness = self.yelpBusinesses[indexPath.row];
    }
    return cell;
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    if(searchController.searchBar.text.length > 0){
        [self.filteredData removeAllObjects];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchController.searchBar.text];
        self.filteredData = [[self.yelpBusinesses filteredArrayUsingPredicate:predicate] mutableCopy];
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchController setActive:NO];
    searchBar.text = @"";
    [self.tableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if ([searchText length] == 0) {
//        [self.searchController setActive:NO];
//        [self.tableView reloadData];
//        [self.searchController.searchBar res]
//    }
}


#pragma mark FiltersViewController Delegate

-(void) filtersViewController: (FiltersViewController *) filtersViewController didChangeFilters: (NSDictionary *)filters{
//    NSLog(@"Filter applied: %s",filters[@"category_filter"]);
    YelpSortMode v = YelpSortModeBestMatched;
    NSDecimalNumber *radius = nil;
    if(filters[@"sort"]){
         int num = filters[@"sort"];
        if(num == 2){
            v = YelpSortModeDistance;
        }else{
            v = YelpSortModeHighestRated;
        }
        
    }
    if(filters[@"distance"]){
        radius = [NSDecimalNumber numberWithFloat:[filters[@"distance"] floatValue]];
     }
    [self searchWithTerm:@"Restaurants" sortMode:v categories:filters[@"category_filter"] deals:filters[@"deals_filter"] radius:radius];
}

#pragma mark - Private methods

-(void) onFilterButton{
    FiltersViewController *fvc = [[FiltersViewController alloc] init];
    fvc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:fvc];
    [self presentViewController:nvc animated:YES
                     completion:nil];
}

@end
