//
//  GeoJSONSerialization_GeoJSONSerialization.h
//  trgv_mapkit
//
//  Created by Guowen Hu on 8/30/16.
//  Copyright © 2016 trgv. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 
 */
@interface GeoJSONSerialization : NSObject

/// @name Creating MKShape objects from GeoJSON

/**
 
 */
+ (MKShape *)shapeFromGeoJSONFeature:(NSDictionary *)feature
                               error:(NSError * __autoreleasing *)error;

/**
 
 */
+ (NSArray *)shapesFromGeoJSONFeatureCollection:(NSDictionary *)featureCollection
                                          error:(NSError * __autoreleasing *)error;

/// @name Creating GeoJSON from MKShape objects

/**
 
 */
+ (NSDictionary *)GeoJSONFeatureFromShape:(MKShape *)shape
                               properties:(NSDictionary *)properties
                                    error:(NSError * __autoreleasing *)error;

/**
 */
+ (NSDictionary *)GeoJSONFeatureCollectionFromShapes:(NSArray *)shapes
                                          properties:(NSArray *)arrayOfProperties
                                               error:(NSError * __autoreleasing *)error;

@end

extern NSString * const GeoJSONSerializationErrorDomain;