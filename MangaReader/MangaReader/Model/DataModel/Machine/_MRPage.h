// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRPage.h instead.

#import <CoreData/CoreData.h>


extern const struct MRPageAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *url;
} MRPageAttributes;

extern const struct MRPageRelationships {
	__unsafe_unretained NSString *chapter;
} MRPageRelationships;

extern const struct MRPageFetchedProperties {
} MRPageFetchedProperties;

@class MRChapter;





@interface MRPageID : NSManagedObjectID {}
@end

@interface _MRPage : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MRPageID*)objectID;





@property (nonatomic, strong) NSData* image;



//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* index;



@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* url;



//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MRChapter *chapter;

//- (BOOL)validateChapter:(id*)value_ error:(NSError**)error_;





@end

@interface _MRPage (CoreDataGeneratedAccessors)

@end

@interface _MRPage (CoreDataGeneratedPrimitiveAccessors)


- (NSData*)primitiveImage;
- (void)setPrimitiveImage:(NSData*)value;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;





- (MRChapter*)primitiveChapter;
- (void)setPrimitiveChapter:(MRChapter*)value;


@end
