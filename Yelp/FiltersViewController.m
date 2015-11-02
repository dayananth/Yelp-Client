//
//  FiltersViewController.m
//  Yelp
//
//  Created by Ramasamy Dayanand on 10/30/15.
//  Copyright © 2015 codepath. All rights reserved.
//

#import "FiltersViewController.h"
#import "switchCell.h"
#import "ListBoxCell.h"

@interface FiltersViewController () <UITableViewDataSource, UITableViewDataSource, SwitchCellDelegate, UIPickerViewDataSource,
                                     UIPickerViewDelegate>

@property (nonatomic,readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *filtersTableView;
@property (nonatomic, strong) NSMutableArray *filtersData;
@property (nonatomic, strong) NSArray *filtersNameArray;
@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property BOOL isDealOffered;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSMutableArray *toggleArray;
@property (nonatomic, strong) NSMutableArray *pickerViewArray;
@property (nonatomic, strong) NSString *distanceFilter;
@property (nonatomic, strong) NSDictionary *sortByFilter;
@property NSInteger *toggle;

typedef NS_ENUM(NSInteger, ListBox) {
    DISTANCE_LIST_BOX = 0,
    SORT_BY_LIST_BOX = 1
};

@end

@implementation FiltersViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.filtersData = [[NSMutableArray alloc] init];
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancel)];
    [self.navigationItem.leftBarButtonItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                              forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(onSearch)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], NSForegroundColorAttributeName,nil]
                                                         forState:UIControlStateNormal];
    self.filtersTableView.dataSource = self;
    self.filtersTableView.delegate = self;
    [self setFilterProperties];
    [self.filtersTableView registerNib:[UINib nibWithNibName:@"switchCell" bundle:nil] forCellReuseIdentifier:@"switchCell"];
    [self.filtersTableView registerNib:[UINib nibWithNibName:@"ListBoxCell" bundle:nil] forCellReuseIdentifier:@"ListBoxCell"];
    [self.filtersTableView reloadData];
    [self configurePickerView];
    
}

#pragma mark uipicker view configuration
-(void) configurePickerView{
    int i;
    self.pickerViewArray = [[NSMutableArray alloc] init];
    self.toggleArray = [[NSMutableArray alloc] init];
    for (i=0; i<2; i++) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:(CGRect){{0, 0}, 320, 480}];;
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.center = (CGPoint){160, 640};
        pickerView.hidden = YES;
        [pickerView setBackgroundColor:[UIColor whiteColor]];
        [pickerView setTintColor:[UIColor whiteColor]];
        [self.pickerViewArray insertObject:pickerView atIndex:i];
        [self.toggleArray insertObject:[NSNumber numberWithInt:0] atIndex:i];
        [self.view addSubview:pickerView];
    }
    
    
//    self.toggle = 0;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Methods

- (void) onCancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onSearch{
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSDictionary *) filters{
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    if(self.selectedCategories.count > 0){
        NSMutableArray *names = [NSMutableArray array];
        for(NSDictionary *category in self.selectedCategories){
            [names addObject:category[@"code"]];
        }
        NSString *filterString = [names componentsJoinedByString:@","];
        [filters setObject:names forKey:@"category_filter"];

    }
    [filters setObject:[NSNumber numberWithBool:self.isDealOffered] forKey:@"deals_filter"];
    if(self.distanceFilter){
        [filters setObject:self.distanceFilter forKey:@"distance"];
    }
    if(self.sortByFilter){
        [filters setObject:self.sortByFilter[@"code"] forKey:@"sort"];
    }
    
    return filters;
}

-(void) setFilterProperties{
    [self setFiltersNames];
    [self setDealFilter:0];
    [self setDistance:1];
    [self setSortBy:2];
    [self setCategories:3];
    self.selectedCategories = [NSMutableSet set];
    
}

- (void) setFiltersNames{
    self.filtersNameArray = @[@"deal", @"Distance", @"SortBy",  @"categories"];
}

-(void) setDealFilter:(int) index{
    NSArray *deal = [[NSArray alloc] init];
    deal = @[@{@"name": @"Offering a Deal"}];
    NSMutableDictionary *dealDictionary = [[NSMutableDictionary alloc] init];
    [dealDictionary setObject:deal forKey:@"deal"];
    [dealDictionary setObject:@"deal" forKey:@"title"];
    [dealDictionary setObject:@"switch" forKey:@"type"];
    [dealDictionary setObject:[NSNumber numberWithInt:1] forKey:@"count"];
    [self.filtersData insertObject:dealDictionary atIndex:index];
    
}

-(void) setDistance:(int) index{
    NSArray *distancesArray = @[@"0.5", @"1", @"2", @"5"];
    NSMutableDictionary *distanceDictionary = [[NSMutableDictionary alloc] init];
    [distanceDictionary setObject:distancesArray forKey:@"distance"];
    [distanceDictionary setObject:@"Distance" forKey:@"title"];
    [distanceDictionary setObject:[NSNumber numberWithInt:1] forKey:@"count"];
    [self.filtersData insertObject:distanceDictionary atIndex:index];
    
}

-(void) setSortBy:(int) index{
    NSArray *sortByArray = @[@{@"name": @"Best Match", @"code":@0},
                                @{@"name": @"Distance", @"code":@1},
                                @{@"name": @"Highest Rated", @"code":@2}];
    NSMutableDictionary *sortByDictionary = [[NSMutableDictionary alloc] init];
    [sortByDictionary setObject:sortByArray forKey:@"sortBy"];
    [sortByDictionary setObject:@"SortBy" forKey:@"title"];
    [sortByDictionary setObject:[NSNumber numberWithInt:1] forKey:@"count"];
    [self.filtersData insertObject:sortByDictionary atIndex:index];
    
}

-(void) setCategories:(int) index{
    NSArray *categories = [[NSArray alloc] init];
    categories = @[@{@"name": @"Afghan", @"code": @"afghani"},
                            @{@"name": @"African", @"code": @"african"},
                            @{@"name": @"American, New", @"code": @"newamerican"},
                            @{@"name": @"American, Traditional", @"code": @"tradamerican"},
                            @{@"name": @"Arabian", @"code": @"arabian"},
                            @{@"name": @"Argentine", @"code": @"argentine"},
                            @{@"name": @"Armenian", @"code": @"armenian"},
                            @{@"name": @"Asian Fusion", @"code": @"asianfusion"},
                            @{@"name": @"Asturian", @"code": @"asturian"},
                            @{@"name": @"Australian", @"code": @"australian"},
                            @{@"name": @"Austrian", @"code": @"austrian"},
                            @{@"name": @"Baguettes", @"code": @"baguettes"},
                            @{@"name": @"Bangladeshi", @"code": @"bangladeshi"},
                            @{@"name": @"Barbeque", @"code": @"bbq"},
                            @{@"name": @"Basque", @"code": @"basque"},
                            @{@"name": @"Bavarian", @"code": @"bavarian"},
                            @{@"name": @"Beer Garden", @"code": @"beergarden"},
                            @{@"name": @"Beer Hall", @"code": @"beerhall"},
                            @{@"name": @"Beisl", @"code": @"beisl"},
                            @{@"name": @"Belgian", @"code": @"belgian"},
                            @{@"name": @"Bistros", @"code": @"bistros"},
                            @{@"name": @"Black Sea", @"code": @"blacksea"},
                            @{@"name": @"Brasseries", @"code": @"brasseries"},
                            @{@"name": @"Brazilian", @"code": @"brazilian"},
                            @{@"name": @"Breakfast & Brunch", @"code": @"breakfast_brunch"},
                            @{@"name": @"British", @"code": @"british"},
                            @{@"name": @"Buffets", @"code": @"buffets"},
                            @{@"name": @"Bulgarian", @"code": @"bulgarian"},
                            @{@"name": @"Burgers", @"code": @"burgers"},
                            @{@"name": @"Burmese", @"code": @"burmese"},
                            @{@"name": @"Cafes", @"code": @"cafes"},
                            @{@"name": @"Cafeteria", @"code": @"cafeteria"},
                            @{@"name": @"Cajun/Creole", @"code": @"cajun"},
                            @{@"name": @"Cambodian", @"code": @"cambodian"},
                            @{@"name": @"Canadian", @"code": @"New)"},
                            @{@"name": @"Canteen", @"code": @"canteen"},
                            @{@"name": @"Caribbean", @"code": @"caribbean"},
                            @{@"name": @"Catalan", @"code": @"catalan"},
                            @{@"name": @"Chech", @"code": @"chech"},
                            @{@"name": @"Cheesesteaks", @"code": @"cheesesteaks"},
                            @{@"name": @"Chicken Shop", @"code": @"chickenshop"},
                            @{@"name": @"Chicken Wings", @"code": @"chicken_wings"},
                            @{@"name": @"Chilean", @"code": @"chilean"},
                            @{@"name": @"Chinese", @"code": @"chinese"},
                            @{@"name": @"Comfort Food", @"code": @"comfortfood"},
                            @{@"name": @"Corsican", @"code": @"corsican"},
                            @{@"name": @"Creperies", @"code": @"creperies"},
                            @{@"name": @"Cuban", @"code": @"cuban"},
                            @{@"name": @"Curry Sausage", @"code": @"currysausage"},
                            @{@"name": @"Cypriot", @"code": @"cypriot"},
                            @{@"name": @"Czech", @"code": @"czech"},
                            @{@"name": @"Czech/Slovakian", @"code": @"czechslovakian"},
                            @{@"name": @"Danish", @"code": @"danish"},
                            @{@"name": @"Delis", @"code": @"delis"},
                            @{@"name": @"Diners", @"code": @"diners"},
                            @{@"name": @"Dumplings", @"code": @"dumplings"},
                            @{@"name": @"Eastern European", @"code": @"eastern_european"},
                            @{@"name": @"Ethiopian", @"code": @"ethiopian"},
                            @{@"name": @"Fast Food", @"code": @"hotdogs"},
                            @{@"name": @"Filipino", @"code": @"filipino"},
                            @{@"name": @"Fish & Chips", @"code": @"fishnchips"},
                            @{@"name": @"Fondue", @"code": @"fondue"},
                            @{@"name": @"Food Court", @"code": @"food_court"},
                            @{@"name": @"Food Stands", @"code": @"foodstands"},
                            @{@"name": @"French", @"code": @"french"},
                            @{@"name": @"French Southwest", @"code": @"sud_ouest"},
                            @{@"name": @"Galician", @"code": @"galician"},
                            @{@"name": @"Gastropubs", @"code": @"gastropubs"},
                            @{@"name": @"Georgian", @"code": @"georgian"},
                            @{@"name": @"German", @"code": @"german"},
                            @{@"name": @"Giblets", @"code": @"giblets"},
                            @{@"name": @"Gluten-Free", @"code": @"gluten_free"},
                            @{@"name": @"Greek", @"code": @"greek"},
                            @{@"name": @"Halal", @"code": @"halal"},
                            @{@"name": @"Hawaiian", @"code": @"hawaiian"},
                            @{@"name": @"Heuriger", @"code": @"heuriger"},
                            @{@"name": @"Himalayan/Nepalese", @"code": @"himalayan"},
                            @{@"name": @"Hong Kong Style Cafe", @"code": @"hkcafe"},
                            @{@"name": @"Hot Dogs", @"code": @"hotdog"},
                            @{@"name": @"Hot Pot", @"code": @"hotpot"},
                            @{@"name": @"Hungarian", @"code": @"hungarian"},
                            @{@"name": @"Iberian", @"code": @"iberian"},
                            @{@"name": @"Indian", @"code": @"indpak"},
                            @{@"name": @"Indonesian", @"code": @"indonesian"},
                            @{@"name": @"International", @"code": @"international"},
                            @{@"name": @"Irish", @"code": @"irish"},
                            @{@"name": @"Island Pub", @"code": @"island_pub"},
                            @{@"name": @"Israeli", @"code": @"israeli"},
                            @{@"name": @"Italian", @"code": @"italian"},
                            @{@"name": @"Japanese", @"code": @"japanese"},
                            @{@"name": @"Jewish", @"code": @"jewish"},
                            @{@"name": @"Kebab", @"code": @"kebab"},
                            @{@"name": @"Korean", @"code": @"korean"},
                            @{@"name": @"Kosher", @"code": @"kosher"},
                            @{@"name": @"Kurdish", @"code": @"kurdish"},
                            @{@"name": @"Laos", @"code": @"laos"},
                            @{@"name": @"Laotian", @"code": @"laotian"},
                            @{@"name": @"Latin American", @"code": @"latin"},
                            @{@"name": @"Live/Raw Food", @"code": @"raw_food"},
                            @{@"name": @"Lyonnais", @"code": @"lyonnais"},
                            @{@"name": @"Malaysian", @"code": @"malaysian"},
                            @{@"name": @"Meatballs", @"code": @"meatballs"},
                            @{@"name": @"Mediterranean", @"code": @"mediterranean"},
                            @{@"name": @"Mexican", @"code": @"mexican"},
                            @{@"name": @"Middle Eastern", @"code": @"mideastern"},
                            @{@"name": @"Milk Bars", @"code": @"milkbars"},
                            @{@"name": @"Modern Australian", @"code": @"modern_australian"},
                            @{@"name": @"Modern European", @"code": @"modern_european"},
                            @{@"name": @"Mongolian", @"code": @"mongolian"},
                            @{@"name": @"Moroccan", @"code": @"moroccan"},
                            @{@"name": @"New Zealand", @"code": @"newzealand"},
                            @{@"name": @"Night Food", @"code": @"nightfood"},
                            @{@"name": @"Norcinerie", @"code": @"norcinerie"},
                            @{@"name": @"Open Sandwiches", @"code": @"opensandwiches"},
                            @{@"name": @"Oriental", @"code": @"oriental"},
                            @{@"name": @"Pakistani", @"code": @"pakistani"},
                            @{@"name": @"Parent Cafes", @"code": @"eltern_cafes"},
                            @{@"name": @"Parma", @"code": @"parma"},
                            @{@"name": @"Persian/Iranian", @"code": @"persian"},
                            @{@"name": @"Peruvian", @"code": @"peruvian"},
                            @{@"name": @"Pita", @"code": @"pita"},
                            @{@"name": @"Pizza", @"code": @"pizza"},
                            @{@"name": @"Polish", @"code": @"polish"},
                            @{@"name": @"Portuguese", @"code": @"portuguese"},
                            @{@"name": @"Potatoes", @"code": @"potatoes"},
                            @{@"name": @"Poutineries", @"code": @"poutineries"},
                            @{@"name": @"Pub Food", @"code": @"pubfood"},
                            @{@"name": @"Rice", @"code": @"riceshop"},
                            @{@"name": @"Romanian", @"code": @"romanian"},
                            @{@"name": @"Rotisserie Chicken", @"code": @"rotisserie_chicken"},
                            @{@"name": @"Rumanian", @"code": @"rumanian"},
                            @{@"name": @"Russian", @"code": @"russian"},
                            @{@"name": @"Salad", @"code": @"salad"},
                            @{@"name": @"Sandwiches", @"code": @"sandwiches"},
                            @{@"name": @"Scandinavian", @"code": @"scandinavian"},
                            @{@"name": @"Scottish", @"code": @"scottish"},
                            @{@"name": @"Seafood", @"code": @"seafood"},
                            @{@"name": @"Serbo Croatian", @"code": @"serbocroatian"},
                            @{@"name": @"Signature Cuisine", @"code": @"signature_cuisine"},
                            @{@"name": @"Singaporean", @"code": @"singaporean"},
                            @{@"name": @"Slovakian", @"code": @"slovakian"},
                            @{@"name": @"Soul Food", @"code": @"soulfood"},
                            @{@"name": @"Soup", @"code": @"soup"},
                            @{@"name": @"Southern", @"code": @"southern"},
                            @{@"name": @"Spanish", @"code": @"spanish"},
                            @{@"name": @"Steakhouses", @"code": @"steak"},
                            @{@"name": @"Sushi Bars", @"code": @"sushi"},
                            @{@"name": @"Swabian", @"code": @"swabian"},
                            @{@"name": @"Swedish", @"code": @"swedish"},
                            @{@"name": @"Swiss Food", @"code": @"swissfood"},
                            @{@"name": @"Tabernas", @"code": @"tabernas"},
                            @{@"name": @"Taiwanese", @"code": @"taiwanese"},
                            @{@"name": @"Tapas Bars", @"code": @"tapas"},
                            @{@"name": @"Tapas/Small Plates", @"code": @"tapasmallplates"},
                            @{@"name": @"Tex-Mex", @"code": @"tex-mex"},
                            @{@"name": @"Thai", @"code": @"thai"},
                            @{@"name": @"Traditional Norwegian", @"code": @"norwegian"},
                            @{@"name": @"Traditional Swedish", @"code": @"traditional_swedish"},
                            @{@"name": @"Trattorie", @"code": @"trattorie"},
                            @{@"name": @"Turkish", @"code": @"turkish"},
                            @{@"name": @"Ukrainian", @"code": @"ukrainian"},
                            @{@"name": @"Uzbek", @"code": @"uzbek"},
                            @{@"name": @"Vegan", @"code": @"vegan"},
                            @{@"name": @"Vegetarian", @"code": @"vegetarian"},
                            @{@"name": @"Venison", @"code": @"venison"},
                            @{@"name": @"Vietnamese", @"code": @"vietnamese"},
                            @{@"name": @"Wok", @"code": @"wok"},
                            @{@"name": @"Wraps", @"code": @"wraps"},
                            @{@"name": @"Yugoslav", @"code": @"yugoslav"}];
    NSMutableDictionary *categoryDictionary = [[NSMutableDictionary alloc] init];
//    NSNumber count =[NSNumber numberWithInt:categories.count];
    [categoryDictionary setObject:categories forKey:@"categories"];
    [categoryDictionary setObject:@"switch" forKey:@"type"];
    [categoryDictionary setObject:@"Categories" forKey:@"title"];
    [categoryDictionary setObject:[NSNumber numberWithInt:categories.count] forKey:@"count"];
    [self.filtersData insertObject:categoryDictionary atIndex:index];
}

-(NSInteger)getListIndex: (int) section{
    if (section == 1) {
        return DISTANCE_LIST_BOX;
    }
    return SORT_BY_LIST_BOX;
}

#pragma mark table delegate methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *dic = [self.filtersData objectAtIndex:section];
    return [[dic objectForKey:@"count"] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(self.filtersNameArray.description);
    return [self.filtersNameArray count];
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.filtersNameArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell"];
    NSDictionary *dic = [self.filtersData objectAtIndex:indexPath.section];
    NSDictionary *data = dic[[self.filtersNameArray objectAtIndex:indexPath.section]];
//    cell.titleLabel.text = data[][@"name"]];
    
    if(indexPath.section == 0){
        [cell setOn:self.isDealOffered];
        cell.titleLabel.text = @"Offering a Deal";
    }else if(indexPath.section == 3){
//        if(indexPath.row > 20){
//            UITableViewCell *loadMoreCell = [[UITableViewCell alloc] init];
//            UIButton *button = [[UIButton alloc] init];
//            button.titleLabel.text = @"See All Options";
//            loadMoreCell
//        }
        NSArray *categoryArray = dic[@"categories"];
        cell.on = [self.selectedCategories containsObject:categoryArray[indexPath.row]];
        cell.titleLabel.text = categoryArray[indexPath.row][@"name"];
    }else{
        ListBoxCell *lbCell = [tableView dequeueReusableCellWithIdentifier:@"ListBoxCell"];
        NSInteger listBoxindex = [self getListIndex:indexPath.section];
//        if(indexPath.section == 1){
//            listBoxindex = DISTANCE_LIST_BOX;
//        }
        lbCell.textLabel.text = @"Select";
        if(listBoxindex == DISTANCE_LIST_BOX){
            if(self.distanceFilter.length > 0)
                lbCell.textLabel.text = self.distanceFilter;
        }else{
            if(self.sortByFilter)
                lbCell.textLabel.text = self.sortByFilter[@"name"];
        }
        
//        if([[self.toggleArray objectAtIndex:listBoxindex] integerValue]== 0)
//        {
//            lbCell.textLabel.text = @"Select";
//        }
//        else
//        {
//            lbCell.textLabel.text = @"Cancel";
//        }
//        lbCell.textLabel.text = @"Distance";
        return lbCell;
    }
    cell.delegate = self;
//    [cell setOn:YES];
//    cell.titleLabel.text = @"test";
    return cell;
}

#pragma mark switchCell delegate methods
-(void) switchCell: (switchCell *) switchCell didUpdateValue:(BOOL) value{
    NSIndexPath *indexPath = [self.filtersTableView indexPathForCell:switchCell];
    NSInteger section = indexPath.section;
    if (section == 0) {
        self.isDealOffered = value;
        return;
    }
    
    NSDictionary *dic = [self.filtersData objectAtIndex:indexPath.section];
    NSArray *categoryArray = dic[@"categories"];
    if(value){

        [self.selectedCategories addObject:categoryArray[indexPath.row]];
    }else{
        [self.selectedCategories removeObject:categoryArray[indexPath.row]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger listBoxindex = [self getListIndex:indexPath.section];
//    if(indexPath.section == 1)
//    {
        //if([[self.toggleArray objectAtIndex:listBoxindex] integerValue] == 0)
        if(1==1)
        {
            self.toggleArray[listBoxindex] = [NSNumber numberWithInt:1];
            [self.filtersTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            [self bringUpPickerViewWithRow:indexPath];
        }
        else
        {
            self.toggleArray[listBoxindex] = [NSNumber numberWithInt:0];
            [self.filtersTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:YES];
            [self hidePickerView];
        }
//    }
}

- (void)bringUpPickerViewWithRow:(NSIndexPath*)indexPath
{
    NSInteger listBoxindex = [self getListIndex:indexPath.section];
    UITableViewCell *currentCellSelected = [self.filtersTableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.pickerViewArray[listBoxindex] setHidden:NO];
         [self.pickerViewArray[listBoxindex] setCenter:(CGPoint){currentCellSelected.frame.size.width/2, self.filtersTableView.frame.origin.y + currentCellSelected.frame.size.height*4}];
     }
                     completion:nil];
}

- (void)hidePickerView
{
    int i;
    for(i = 0; i< 2; i++){
        [UIView animateWithDuration:1.0f
                              delay:0.0f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             [self.pickerViewArray[i] setCenter:(CGPoint){160, 800}];
         }
                         completion:^(BOOL finished)
         {
             [self.pickerViewArray[i] setHidden:YES];
         }];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger index = [self.pickerViewArray indexOfObject:pickerView];
    [self.toggleArray insertObject:[NSNumber numberWithInt:1] atIndex:index];
    NSString *rowTitle = @"";
    if (index == DISTANCE_LIST_BOX) {
        rowTitle = self.filtersData[1][@"distance"][row];
        self.distanceFilter = rowTitle;
    }
    else if(index == SORT_BY_LIST_BOX) {
        NSDictionary *sortByDic = self.filtersData[2][@"sortBy"][row];
        self.sortByFilter = sortByDic;
    }
    [self.filtersTableView reloadData];
    [self hidePickerView];

    
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSInteger index = [self.pickerViewArray indexOfObject:pickerView];
    NSString *rowTitle = @"";
    if (index == DISTANCE_LIST_BOX) {
        rowTitle = self.filtersData[1][@"distance"][row];
    }else if(index == SORT_BY_LIST_BOX) {
        rowTitle = self.filtersData[2][@"sortBy"][row][@"name"];
    }
    return rowTitle;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger index = [self.pickerViewArray indexOfObject:pickerView];
    if (index == DISTANCE_LIST_BOX) {
        return [self.filtersData[1][@"distance"] count];
    }
    return [self.filtersData[2][@"sortBy"] count];
}


@end
