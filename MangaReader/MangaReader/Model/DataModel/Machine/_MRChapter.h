// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRChapter.h instead.

#import <CoreData/CoreData.h>


extern const struct MRChapterAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *pageCount;
	__unsafe_unretained NSString *path;
	__unsafe_unretained NSString *title;
} MRChapterAttributes;

extern const struct MRChapterRelationships {
	__unsafe_unretained NSString *pages;
	__unsafe_unretained NSString *series;
} MRChapterRelationships;

extern const struct MRChapterFetchedProperties {
} MRChapterFetchedProperties;

@class MRPage;
@class MRSeries;






@interface MRChapterID : NSManagedObjectID {}
@end

@interface _MRChapter : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MRChapterID*)objectID;





@property (nonatomic, strong) NSNumber* index;



@property int32_t indexValue;
- (int32_t)indexValue;
- (void)setIndexValue:(int32_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pageCount;



@property int32_t pageCountValue;
- (int32_t)pageCountValue;
- (void)setPageCountValue:(int32_t)value_;

//- (BOOL)validatePageCount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* path;



//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) MRPage *pages;

//- (BOOL)validatePages:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) MRSeries *series;

//- (BOOL)validateSeries:(id*)value_ error:(NSError**)error_;





@end

@interface _MRChapter (CoreDataGeneratedAccessors)

@end

@interface _MRChapter (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int32_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int32_t)value_;




- (NSNumber*)primitivePageCount;
- (void)setPrimitivePageCount:(NSNumber*)value;

- (int32_t)primitivePageCountValue;
- (void)setPrimitivePageCountValue:(int32_t)value_;




- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (MRPage*)primitivePages;
- (void)setPrimitivePages:(MRPage*)value;



- (MRSeries*)primitiveSeries;
- (void)setPrimitiveSeries:(MRSeries*)value;


@end
