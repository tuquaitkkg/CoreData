//
//  NEDBAccessor.h
//
//  Created by Akihiro Matsui
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/*!
 @class NEDBAccessor
 データベースアクセス用ラッパークラス
 CoreDataへのアクセスを簡易化するラッパークラス
 */
@interface NEDBAccessor : NSObject

/*!
 @property managedObjectModel
 CoreData用オブジェクトモデルアクセサ
 */
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;

/*!
 @property managedObjectContext
 CoreData用オブジェクトコンテキストアクセサ
 */
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectContext *mainManagedObjectContext;

/*!
 @property persistentStoreCoordinator
 CoreData用コーディネータアクセサ
 */
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 @method instance
 @return NEDBAccessorインスタンス
 NEDBAccessorインスタンスを取得するメソッド
 */
+ (id)instance;

/**
 @method editContextDidSave:
 @param saveNotification 通知オブジェクト
 保存通知を受け取るメソッド
 */
- (void)editContextDidSave:(NSNotification *)saveNotification;

/**
 @method deleteCoreDataFile
 コアデータのデータ保存ファイルを削除する（データクリア）
 */
- (void)deleteCoreDataFile;

@end
