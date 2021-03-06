// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MRSeries.h instead.

#import <CoreData/CoreData.h>


extern const struct MRSeriesAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *path;
} MRSeriesAttributes;

extern const struct MRSeriesRelationships {
	__unsafe_unretained NSString *chapters;
} MRSeriesRelationships;

extern const struct MRSeriesFetchedProperties {
} MRSeriesFetchedProperties;

@class MRChapter;




@interface MRSeriesID : NSManagedObjectID {}
@end

@interface _MRSeries : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (MRSeriesID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* path;



//- (BOOL)validatePath:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *chapters;

- (NSMutableSet*)chaptersSet;





@end

@interface _MRSeries (CoreDataGeneratedAccessors)

- (void)addChapters:(NSSet*)value_;
- (void)removeChapters:(NSSet*)value_;
- (void)addChaptersObject:(MRChapter*)value_;
- (void)removeChaptersObject:(MRChapter*)value_;

@end

@interface _MRSeries (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSString*)primitivePath;
- (void)setPrimitivePath:(NSString*)value;





- (NSMutableSet*)primitiveChapters;
- (void)setPrimitiveChapters:(NSMutableSet*)value;


@end
