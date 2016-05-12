//
//  TableViewController.m
//  SearchBar
//
//  Created by Ngô Sỹ Trường on 5/11/16.
//  Copyright © 2016 ngotruong. All rights reserved.
//

#import "TableViewController.h"
#import "DetailAnimalsViewController.h"

@interface TableViewController () <UISearchResultsUpdating>

@end

@implementation TableViewController
{
    NSDictionary *dictAnimals;
    NSArray *arrayKeys;
    NSMutableArray *filteredNames;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    filteredNames = [NSMutableArray new];
    dictAnimals = @{@"B" : @[@"Bear", @"Black Swan", @"Buffalo"],
                    @"C" : @[@"Camel", @"Cockatoo"],
                    @"D" : @[@"Dog", @"Donkey"],
                    @"E" : @[@"Emu"],
                    @"G" : @[@"Giraffe", @"Greater Rhea"],
                    @"H" : @[@"Hippopotamus", @"Horse"],
                    @"K" : @[@"Koala"],
                    @"L" : @[@"Lion", @"Llama"],
                    @"M" : @[@"Manatus", @"Meerkat"],
                    @"P" : @[@"Panda", @"Peacock", @"Pig", @"Platypus", @"Polar Bear"],
                    @"R" : @[@"Rhinoceros"],
                    @"S" : @[@"Seagull"],
                    @"T" : @[@"Tasmania Devil"],
                    @"W" : @[@"Whale", @"Whale Shark", @"Wombat"]};
    
    arrayKeys = [dictAnimals allKeys];
    arrayKeys = [arrayKeys sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.placeholder = @"Search for animals";
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = 0;
    self.definesPresentationContext = true;
}


#pragma mark - Table view data source


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [filteredNames removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [c] %@",self.searchController.searchBar.text];
    for (NSString *key in arrayKeys) {
        NSArray *array = dictAnimals[key];
        NSArray *matches = [array filteredArrayUsingPredicate:predicate];
        [filteredNames addObjectsFromArray:matches];
    }
    [self.tableView reloadData];
}

-(NSString*) getImageFileName: (NSString*) animal {
    NSString *imageFileName = animal.lowercaseString;
    imageFileName = [imageFileName stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    imageFileName = [imageFileName stringByAppendingString:@".jpg"];
    return imageFileName;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.searchBar.text.length > 0) {
        if (filteredNames.count > 0) {
            return 1;
        }else {
            return 0;
        }
    }
    return arrayKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.searchBar.text.length > 0) {
        if (filteredNames.count > 0) {
            return [filteredNames count];
        }else {
            return 0;
        }
    }
    NSString *key = arrayKeys[section];
    NSArray *arrayAnimalsInsection = dictAnimals[key];
    return arrayAnimalsInsection.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchController.searchBar.text.length > 0) {
        return nil;
    }
    return arrayKeys[section];
}

-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (self.searchController.searchBar.text.length > 0) {
        return nil;
    }
    return arrayKeys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.searchController.searchBar.text.length > 0 && filteredNames.count > 0) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:filteredNames[indexPath.row]];
        NSRange range = [filteredNames[indexPath.row] rangeOfString:self.searchController.searchBar.text options:NSCaseInsensitiveSearch];
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        cell.textLabel.attributedText = attributedText;
        NSString *animal = filteredNames[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:[self getImageFileName:animal]];
        
        return cell;
    }
    
    //cell.textLabel.attributedText = nil;
    NSString *key = arrayKeys[indexPath.section];
    NSArray *arrayAnimalsInsection = dictAnimals[key];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *animal = arrayAnimalsInsection[indexPath.row];
    cell.textLabel.text = animal;
    cell.imageView.image = [UIImage imageNamed:[self getImageFileName:animal]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = selectedCell.textLabel.text;
    DetailAnimalsViewController *details = [DetailAnimalsViewController new];
    
    details.imageAnimals = [self getImageFileName:cellText];
    //NSLog(@"%@",details.imageAnimals);
    [self.navigationController pushViewController:details animated:true];
    
}

@end
