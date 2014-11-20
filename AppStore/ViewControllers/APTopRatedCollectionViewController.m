//
//  APTopRatedCollectionViewController.m
//  AppStore
//
//  Created by Dan Mac Hale on 10/11/2014.
//  Copyright (c) 2014 iElmo. All rights reserved.
//

#import "APTopRatedCollectionViewController.h"
#import "APAppItemCollectionViewCell.h"
#import "APAPIController.h"
#import "APAppItemObject.h"
#import "APLoadMoreCollectionViewCell.h"
#import "UIViewController+WaitView.h"

#define PAGESIZE 50
#define MAXPAGESIZE 150

@interface APTopRatedCollectionViewController () <UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource> {
    BOOL inProgress;
}

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic) NSInteger currentPage;

-(IBAction)segmentChanged:(UISegmentedControl *)segment;
@end

static const NSString *topGrossingUrlString = @"https://itunes.apple.com/gb/rss/topgrossingapplications/";
static const NSString *topFreeUrlString = @"https://itunes.apple.com/gb/rss/topfreeapplications/";
static const NSString *topPaidUrlString = @"https://itunes.apple.com/gb/rss/toppaidapplications/";

@implementation APTopRatedCollectionViewController

#pragma mark - View Implementation
- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [[NSMutableArray alloc] init];
    self.currentPage = 1;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self executeRSSQuery:[NSString stringWithFormat:@"%@limit=%ld/json", topPaidUrlString, (PAGESIZE * self.currentPage)]];
}

#pragma mark - API Methods

- (void)executeRSSQuery:(NSString *)query {
    inProgress = YES;
    __weak APTopRatedCollectionViewController *blockSelf = self;
    [self showWaitView];
    [APAPIController executeRssQuery:query withCompletionBlock:^(NSArray *items, NSError *error) {
        if (!error) {
            blockSelf.items = [NSMutableArray arrayWithArray:items];
            [blockSelf.collectionView reloadData];
        }
        inProgress = NO;
        [blockSelf hideWaitView];
    }];
}

#pragma mark - Actions

-(IBAction)segmentChanged:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self executeRSSQuery:[NSString stringWithFormat:@"%@limit=%ld/json", topPaidUrlString, (PAGESIZE * self.currentPage)]];
            break;
        case 1:
            [self executeRSSQuery:[NSString stringWithFormat:@"%@limit=%ld/json", topFreeUrlString, (PAGESIZE * self.currentPage)]];
            break;
        case 2:
            [self executeRSSQuery:[NSString stringWithFormat:@"%@limit=%ld/json", topGrossingUrlString, (PAGESIZE * self.currentPage)]];
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id cell;
    if (indexPath.row < self.items.count) {
        APAppItemCollectionViewCell *itemCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APAppItemCollectionViewCell" forIndexPath:indexPath];
        APAppItemObject *item = self.items[indexPath.row];
        [itemCell decorateCellWithAppItem:item];
        cell = itemCell;
    }
    else {
        APLoadMoreCollectionViewCell *loadMoreCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"APLoadMoreCollectionViewCell" forIndexPath:indexPath];
        if (!inProgress && self.items.count < MAXPAGESIZE) {
            self.currentPage ++;
            [self segmentChanged:self.segmentControl];
        }
        cell = loadMoreCell;
    }
    return cell;
}

#pragma mark - UICollectionView Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count < MAXPAGESIZE && self.items.count ? self.items.count + 1 : self.items.count;
}

@end
