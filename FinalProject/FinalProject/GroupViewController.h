#import <GLKit/GLKit.h>
#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>

@interface GroupViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate> {
    double _min, _max;
    __weak IBOutlet UILabel *_labelValue;
    UIImageView *img;
    int counter;
    CGPoint location;

    NSMutableArray *coordinates;
    NSMutableArray *shotDistances;

    __weak IBOutlet UIButton *addShotsButton;
    __weak IBOutlet UIButton *setMarkerButton;
    __weak IBOutlet UIButton *deleteCurrentButton;
    __weak IBOutlet UIButton *calculateScoreButton;
    CGFloat distance;
    int radiusDistanceConverted;
    CGPoint phoneCenter;
    CGFloat totalScore;
    __weak IBOutlet UILabel *pointsLabel;
    int shotCounter;
    
    float averageInt;
    __weak IBOutlet UIButton *takePictureButton;
    __weak IBOutlet UIButton *galleryButton;
    __weak IBOutlet UIButton *deleteButton;
    __weak IBOutlet UIButton *setButton;
    BOOL moveX;
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)pickImageFromGallery:(id)sender;
- (IBAction)takePictureFromCamera;
- (IBAction)addShots;
- (IBAction)saveImage;
- (IBAction)setMarker;
- (IBAction)deleteCurrentMarker;
- (IBAction)calculate;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end
