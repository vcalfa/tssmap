//
//  ViewController.m
//  tssmap
//
//  Created by Vladimir Calfa on 26/06/15.
//  Copyright (c) 2015 Vladimir Calfa. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "Service.h"
#import "Directions.h"
#import "AppData.h"
#import "Route.h"
#import "GMSAnimateMarker.h"

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, GMSPanoramaViewDelegate>


@property (weak, nonatomic) IBOutlet GMSMapView *mapView;
@property (weak, nonatomic) GMSPanoramaView *panoView;
@property (strong, nonatomic) GMSAnimateMarker *car;

@property (weak, nonatomic) IBOutlet UITextField *startLocationField;
@property (weak, nonatomic) IBOutlet UITextField *endLocationField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *streetMapButton;
@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;

@end

@implementation ViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"appDataChanged" object:nil];
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:48.971516
                                                            longitude:18.187169
                                                                 zoom:10];

    [self.mapView setCamera:camera];
    
    
    [self styleButton:self.streetMapButton];
    [self styleButton:self.playPauseButton];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)styleButton:(UIButton*)button {
    
    button.layer.cornerRadius = 8;
    button.clipsToBounds = YES;
    button.layer.borderWidth = 0.5;
    button.layer.borderColor = [UIColor colorWithRed:187.0/255.0 green:194.0/255.0 blue:184.0/255.0 alpha:1.0].CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.startLocationField) {
        [self.endLocationField becomeFirstResponder];
    }
    else if (textField == self.endLocationField) {
        [self requestDirection];
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)requestDirection {
    
    if (![self isValidateForm]) {
        return;
    }
    
    if (self.panoView != nil) {
        [self hidePanoramaView];
    }
    
    NSString *startLocation = self.startLocationField.text;
    NSString *endLocation = self.endLocationField.text;
    
    
    [[Service sharedInstance] requestDirectionFrom: startLocation to: endLocation withCompletition:^(BOOL success, Directions *object, NSError *error) {
        
        if (success) {
            
            if (object.routes.count > 0) {
                [self displayRoute: [object.routes objectAtIndex:0] onMap:self.mapView];
            }
        }
        else {
            [[[UIAlertView alloc] initWithTitle:nil message:@"Route not found." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
        }
    }];
}

- (void)displayRoute:(Route*)route onMap:(GMSMapView*)mapView {
    
    [mapView clear];
    
    GMSPath *path = [route overviewPath];
    
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeColor = [UIColor blueColor];
    polyline.strokeWidth = 5.f;
    polyline.map = mapView;

    GMSMarker *markerStart = [[GMSMarker alloc] init];
    Location *start = route.firstLeg.startLocation;
    markerStart.position = CLLocationCoordinate2DMake(start.lat.doubleValue, start.lng.doubleValue);
    markerStart.groundAnchor = CGPointMake(0.5, 0.5);
    markerStart.appearAnimation = kGMSMarkerAnimationPop;
    markerStart.icon = [UIImage imageNamed:@"startFlag"];
    markerStart.map = mapView;
    
    
    GMSMarker *markerEnd = [[GMSMarker alloc] init];
    Location *end = route.lastLeg.endLocation;
    markerEnd.position = CLLocationCoordinate2DMake(end.lat.doubleValue, end.lng.doubleValue);
    markerEnd.groundAnchor = CGPointMake(0.5, 0.5);
    markerEnd.appearAnimation = kGMSMarkerAnimationPop;
    markerEnd.icon = [UIImage imageNamed:@"endFlag"];
    markerEnd.map = mapView;
    
    GMSCoordinateBounds *allBounds = [[GMSCoordinateBounds alloc] initWithPath:[polyline path]];
    
    [mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:allBounds withPadding:50.0f]];
    
    GMSAnimateMarker *car = [[GMSAnimateMarker alloc] initWithPath:path];
    car.icon = [UIImage imageNamed:@"car"];
    car.groundAnchor = CGPointMake(0.5f, 0.5f);
    car.flat = YES;
    car.map = mapView;
    [car setVelocityKmH:90.0]; // 70 Km/h
    
    self.playPauseButton.enabled = YES;
    [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    self.car = car;
}

- (BOOL)isValidateForm {
    
    NSString *errorMessage;
    BOOL valid = YES;
    
    if ([self.startLocationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        errorMessage = @"Please enter a start location";
        valid = NO;
    } else if ([self.endLocationField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0){
        errorMessage = @"Please enter a destination location";
        valid = NO;
    }
    
    if (!valid) {
        [[[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];
    }
    
    return valid;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [AppData sharedInstance].directions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    Directions *directions = [[AppData sharedInstance].directions objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Start: %@  -> End: %@",directions.startLocation, directions.endLocation];
    
    return cell;
}

- (void)reloadTable {
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Directions *directions = [[AppData sharedInstance].directions objectAtIndex:indexPath.row];
    
    self.startLocationField.text = directions.startLocation;
    self.endLocationField.text = directions.endLocation;
    
    [self requestDirection];
}

- (IBAction)streetMapAction:(UIButton *)sender {
    
    if (self.panoView == nil) {
        [self showPanoramaView];
    }
    else {
        [self hidePanoramaView];
    }
}

- (void)showPanoramaView {
    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:self.mapView.frame];
    panoView.delegate = self;
    self.panoView = panoView;
    
    if (self.car) {
        [self.panoView moveNearCoordinate: self.car.position];
    } else {
        [self.panoView moveNearCoordinate: self.mapView.camera.target];
    }
    
    [self.view insertSubview:self.panoView aboveSubview:self.mapView];
    //self.playPauseButton.enabled = NO;
    [self.streetMapButton setTitle:@"Map" forState:UIControlStateNormal];
}

- (void)hidePanoramaView {
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.panoView.panorama.coordinate.latitude
                                                            longitude:self.panoView.panorama.coordinate.longitude
                                                                 zoom:self.mapView.camera.zoom];
    
    [self.mapView setCamera:camera];
    
    [self.panoView removeFromSuperview];
    
    //self.playPauseButton.enabled = YES;
    [self.streetMapButton setTitle:@"Street" forState:UIControlStateNormal];
}

- (IBAction)playPauseAction:(UIButton *)sender {
    
    if (self.car.isAnimated) {
        [self.car pause];
        [sender setTitle:@"Play" forState:UIControlStateNormal];
    }
    else {
        [self.car play];
        [sender setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

#pragma mark - GMSPanoramaViewDelegate

- (void)panoramaView:(GMSPanoramaView *)view error:(NSError *)error onMoveNearCoordinate:(CLLocationCoordinate2D)coordinate {
    
    [self.panoView removeFromSuperview];
    
    [self.streetMapButton setTitle:@"Street" forState:UIControlStateNormal];
    
    [[[UIAlertView alloc] initWithTitle:nil message:@"Near coordinates for panorama view not found." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil] show];

}

@end
