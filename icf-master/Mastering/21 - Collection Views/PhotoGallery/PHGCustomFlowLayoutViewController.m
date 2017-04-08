//
//  PHGCustomFlowLayoutViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/13/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGCustomFlowLayoutViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGCustomFlowLayout.h"
@import Photos;

NSString *kCustomThumbCell = @"kCustomThumbCell"; // UICollectionViewCell storyboard id
NSString *kCustomSectionHeader = @"kCustomSectionHeader"; //section header storyboard id

@interface PHGCustomFlowLayoutViewController ()
@property (nonatomic, strong) UICollectionViewFlowLayout *pageLayout;
@property (nonatomic, strong) PHFetchResult *albumsResult;
@property (nonatomic, strong) NSMutableArray *albumAssetsResults;
@end

@implementation PHGCustomFlowLayoutViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView setCollectionViewLayout:[[PHGCustomFlowLayout alloc] init]];
    [self.collectionView registerNib:[UINib nibWithNibName:@"PHGSectionHeader" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCustomSectionHeader];

    self.albumsResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.albumAssetsResults = [[NSMutableArray alloc] initWithCapacity:self.albumsResult.count];
    
    for (PHAssetCollection *album in self.albumsResult) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        [self.albumAssetsResults insertObject:result atIndex:[self.albumsResult indexOfObject:album]];
    }
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
    PHGSectionHeader *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kCustomSectionHeader forIndexPath:indexPath];
    PHAssetCollection *album = [self.albumsResult objectAtIndex:indexPath.section];
    
    [sectionHeader.headerLabel setText:album.localizedTitle];
    
    return sectionHeader;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PHGThumbCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCustomThumbCell forIndexPath:indexPath];
    
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

@end
