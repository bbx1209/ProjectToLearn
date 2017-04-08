//
//  PHGBasicFlowViewController.m
//  PhotoGallery
//
//  Created by Joe Keeley on 7/20/13.
//  Copyright (c) 2013 ICF. All rights reserved.
//

#import "PHGBasicFlowViewController.h"

#import "PHGThumbCell.h"
#import "PHGSectionHeader.h"
#import "PHGSectionFooter.h"
@import Photos;

NSString *kThumbCell = @"kThumbCell"; // UICollectionViewCell storyboard id
NSString *kSectionHeader = @"kSectionHeader"; //section header storyboard id
NSString *kSectionFooter = @"kSectionFooter"; //section footer storyboard id

@interface PHGBasicFlowViewController ()
@property (nonatomic, strong) UICollectionViewFlowLayout *pageLayout;
@property (nonatomic, strong) PHFetchResult *albumsResult;
@property (nonatomic, strong) NSMutableArray *albumAssetsResults;
@end

@implementation PHGBasicFlowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.collectionView setAllowsMultipleSelection:YES];
    
    self.albumsResult = [PHCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    self.albumAssetsResults = [[NSMutableArray alloc] initWithCapacity:self.albumsResult.count];
    
    for (PHAssetCollection *album in self.albumsResult) {
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:album options:nil];
        [self.albumAssetsResults insertObject:result atIndex:[self.albumsResult indexOfObject:album]];
    }
}

#pragma mark - Collection View Data Source methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.albumsResult count];
}

- (NSInteger)collectionView:(UICollectionView *)view
     numberOfItemsInSection:(NSInteger)section;
{
    PHFetchResult *albumAssets = self.albumAssetsResults[section];
    return [albumAssets count];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *supplementaryView = nil;
    PHAssetCollection *album = [self.albumsResult objectAtIndex:indexPath.section];
    PHFetchResult *albumAssets = [self.albumAssetsResults objectAtIndex:indexPath.section];

    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        PHGSectionHeader *sectionHeader =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
        withReuseIdentifier:kSectionHeader forIndexPath:indexPath];
        
        [sectionHeader.headerLabel
         setText:[NSString stringWithFormat:@"%@ - %lu",album.localizedTitle,
                  (unsigned long)albumAssets.count]];
        
        supplementaryView = sectionHeader;
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        PHGSectionFooter *sectionFooter =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kSectionFooter
                                                  forIndexPath:indexPath];
        
        NSString *footerString = [NSString stringWithFormat:@"...end of %@ - %lu",
                                  album.localizedTitle, (unsigned long)albumAssets.count];
        
        [sectionFooter.footerLabel setText:footerString];
        
        supplementaryView = sectionFooter;
    }
    
    return supplementaryView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PHGThumbCell *cell =
    [cv dequeueReusableCellWithReuseIdentifier:kThumbCell
                                  forIndexPath:indexPath];

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

#pragma mark - Collection View Delegate methods

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item selected at indexPath: %@",indexPath);
}

- (void)collectionView:(UICollectionView *)collectionView
didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Item deselected at indexPath: %@",indexPath);
}

#pragma mark - Action methods

- (IBAction)actionTapped:(id)sender
{
    NSString *message = nil;

    if ([self.collectionView.indexPathsForSelectedItems count] == 0)
    {
        message = @"There are no selected items.";
    }
    else if ([self.collectionView.indexPathsForSelectedItems count] == 1)
    {
        message = @"There is 1 selected item.";
    }
    else if ([self.collectionView.indexPathsForSelectedItems count] > 1) {
        message = [NSString stringWithFormat:@"There are %lu selected items.",(unsigned long)[self.collectionView.indexPathsForSelectedItems count]];
    }
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Selected Items"
                                        message:message
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *dismissAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleCancel
                           handler:^(UIAlertAction *action){
                               [self dismissViewControllerAnimated:YES completion:nil];
                           }];
    
    [alert addAction:dismissAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
