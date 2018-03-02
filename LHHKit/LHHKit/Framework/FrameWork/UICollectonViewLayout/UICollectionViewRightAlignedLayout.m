//
//   ___           ___        ___      ___        ___
//  /\  \         /\  \      /\  \    /\  \      /\  \
//  \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//   \ \  \        \ \  \_____\ \  \   \ \  \_____\ \  \
//    \ \  \______  \ \  \     \ \  \   \ \  \     \ \  \
//     \ \________\  \ \__\     \ \__\   \ \__\     \ \__\
//      \/________/   \/__/      \/__/    \/__/      \/__/
//
//  欢欢为人民服务
//  有问题请联系我，http://www.jianshu.com/u/3c6ff28fdc63
//
// -----------------------------------------------------------------------------


#import "UICollectionViewRightAlignedLayout.h"

@implementation UICollectionViewRightAlignedLayout
#pragma mark - UICollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSInteger left = -1, right = -1;//记录每一行最左和最右
    CGFloat width = 0;
    NSInteger section = 0;
    CGFloat lastx = self.collectionView.frame.size.width;
    NSMutableArray *updatedAttributes = [[NSMutableArray alloc]initWithArray:[super layoutAttributesForElementsInRect:rect] copyItems:YES];
    NSInteger index = 0;
    for (NSInteger i = 0; i < [updatedAttributes count]; i ++)
    {
        UICollectionViewLayoutAttributes * attributes = updatedAttributes[i];
        if (!attributes.representedElementKind)
        {
            section = attributes.indexPath.section;
            if(attributes.frame.origin.x < lastx)
            {
                index ++;
                if(left != -1)
                {
                    //处理上一行的内容
                    [self getAttributesForLeft:left right:right offset:[self calOffset:section width:width] originalAttributes:updatedAttributes];
                }
                left = i;
                lastx = attributes.frame.origin.x + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
                width = [self evaluatedSectionInsetForItemAtIndex:section].left + [self evaluatedSectionInsetForItemAtIndex:section].right - [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
            }
            lastx = attributes.frame.origin.x + attributes.frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
            right = i;
            width += attributes.frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:section];
            
        }
    }
    if ( self.whenIndex )
    {
        self.whenIndex(index);
    }
    //确保最后一行更新
    if (left != -1)
    {
        [self getAttributesForLeft:left right:right offset:[self calOffset:section width:width] originalAttributes:updatedAttributes];
    }
    
    return updatedAttributes;
}

- (CGFloat)calOffset:(NSInteger)section width:(CGFloat)width
{
    CGFloat offset = [self evaluatedSectionInsetForItemAtIndex:section].left;
    offset += self.collectionView.frame.size.width - width;
    return offset;
}

- (void)getAttributesForLeft:(NSInteger)left right:(NSInteger) right offset:(CGFloat)offset originalAttributes:(NSMutableArray *)updatedAttributes
{
    CGFloat currentOffset = offset;
    for(NSInteger i = left; i <= right; i ++)
    {
        UICollectionViewLayoutAttributes *attributes = updatedAttributes[i];
        CGRect frame = attributes.frame;
        frame.origin.x = currentOffset;
        attributes.frame = frame;
        currentOffset += frame.size.width + [self evaluatedMinimumInteritemSpacingForSectionAtIndex:attributes.indexPath.section];
        [updatedAttributes setObject:attributes atIndexedSubscript:i];
    }
}

- (CGFloat)evaluatedMinimumInteritemSpacingForSectionAtIndex:(NSInteger)sectionIndex
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)])
    {
        
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:sectionIndex];
    }
    else
    {
        return self.minimumInteritemSpacing;
    }
}

- (UIEdgeInsets)evaluatedSectionInsetForItemAtIndex:(NSInteger)index
{
    if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:index];
    }
    else
    {
        return self.sectionInset;
    }
}

@end
