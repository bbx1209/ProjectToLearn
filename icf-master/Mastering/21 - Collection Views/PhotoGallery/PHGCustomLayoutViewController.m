//
//  PHGCustomLayoutViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/21/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomLayoutViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGCustomLayout.h"
#import "PHGAnimatingFlowLayout.h"
@import Photos;

NSString *kCustomCell = @"kCustomCell"; // UICollectionViewCell storyboard id
NSString *kCustomSectionHdr = @"kCustomSectionHeader"; //section header storyboard id

@interface PHGCustomLayoutViewController ()
@property (nonatomic, strong) PHGCustomLayout *customLayout;
@property (nonatomic, strong) NSIndexPath *pinchedIndexPath;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchIn;
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchOut;
@property (nonatomic, strong) PHFetchResult *albumsResult;
@property (nonatomic, strong) NSMutableArray *albumAssetsResults;
@end

@implementation PHGCustomLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView setCollectionViewLayout:[[PHGCustomLayout alloc] init]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PHGCustomSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHdr];
    
    self.albumsResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.albumAssetsResults = [[NSMutableArray alloc] initWithCapacity:self.albumsResult.count];
    
    for (PHAssetCollection *album in self.albumsResult) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        [self.albumAssetsResults insertObject:result atIndex:[self.albumsResult indexOfObject:album]];
    }
    
    self.pinchIn = [[UIPinchGestureRecognizer alloc]
                    initWithTarget:self
                    action:@selector(pinchInReceived:)];

    self.pinchOut = [[UIPinchGestureRecognizer alloc]
                     initWithTarget:self
                     action:@selector(pinchOutReceived:)];

    [self.collectionView addGestureRecognizer:self.pinchOut];
}

#pragma mark - Collection view methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.albumsResult count];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    PHFetchResult *albumAssets = self.albumAssetsResults[section];
    return [albumAssets count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHdr forIndexPath:indexPath];
    PHAssetCollection *album = [self.albumsResult objectAtIndex:indexPath.section];
    
    [sectionHeader.headerLabel setText:album.localizedTitle];
    
    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCustomCell forIndexPath:indexPath];
    
    PHFetchResult *albumAssets = self.albumAssetsResults[indexPath.section];
    PHAsset *asset = albumAssets[indexPath.row];
    
    PHImageManager *imageManager = [PHImageManager defaultManager];
    [imageManager requestImageForAsset:asset
                            targetSize:CGSizeMake(50, 50)
                           contentMode:PHImageContentModeAspectFill
                               options:nil
                         resultHandler:^(UIImage *result, NSDictionary *info){
                             [cell.thumbImageView setImage:result];
                             [cell setNeedsLayout];
                         }];
    
    return cell;
}

#pragma mark - Gesture methods

- (void)pinchInReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan )
    {
        CGPoint pinchPoint =
        [pinchRecognizer locationInView:self.collectionView];
        
        self.pinchedIndexPath =
        [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded)
    {
        [self.collectionView removeGestureRecognizer:self.pinchIn];
        PHGCustomLayout *customLayout = [[PHGCustomLayout alloc] init];
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchOut = self.pinchOut;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        void (^finishedBlock)(BOOL) = ^(BOOL finished) {
            
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath
            atScrollPosition:UICollectionViewScrollPositionCenteredVertically
            animated:YES];
            
            [weakCollectionView addGestureRecognizer:weakPinchOut];
        };
        
        [self.collectionView setCollectionViewLayout:customLayout
                                            animated:YES
                                          completion:finishedBlock];
    }
}

- (void)pinchOutReceived:(UIGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.state == UIGestureRecognizerStateBegan)
    {
        CGPoint pinchPoint =
        [pinchRecognizer locationInView:self.collectionView];
        
        self.pinchedIndexPath =
        [self.collectionView indexPathForItemAtPoint:pinchPoint];
    }
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded) {
        [self.collectionView removeGestureRecognizer:self.pinchOut];

        UICollectionViewFlowLayout *individualLayout =
        [[PHGAnimatingFlowLayout alloc] init];
                
        __weak UICollectionView *weakCollectionView = self.collectionView;
        __weak UIPinchGestureRecognizer *weakPinchIn = self.pinchIn;
        __weak NSIndexPath *weakPinchedIndexPath = self.pinchedIndexPath;
        void (^finishedBlock)(BOOL) = ^(BOOL finished) {
            
            [weakCollectionView scrollToItemAtIndexPath:weakPinchedIndexPath
            atScrollPosition:UICollectionViewScrollPositionCenteredVertically
            animated:YES];
            
            [weakCollectionView addGestureRecognizer:weakPinchIn];
        };
        [self.collectionView setCollectionViewLayout:individualLayout
                                            animated:YES
                                          completion:finishedBlock];
    }
}

@end
