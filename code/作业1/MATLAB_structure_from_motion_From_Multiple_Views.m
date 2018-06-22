%% Read the Input Image Sequence
% imageDir = fullfile(toolboxdir('vision'), 'visiondata', ...
%       'structureFromMotion');
imageDir = '.\data';
imds = imageDatastore(imageDir);

% Display the images.
figure
montage(imds.Files, 'Size', [3, 2]);

% Convert the images to grayscale.
images = cell(1, numel(imds.Files));
for i = 1:numel(imds.Files)
    I = readimage(imds, i);
    images{i} = rgb2gray(I);
end

title('Input Image Sequence');

%% Load Camera Parameters
cali = load('cali.mat');
cameraParams = cali.cameraParams_huawei;
%cameraParams=load('cameraParams.mat');

%% Create a View Set Containing the First View

I = images{1};

border = 50;
roi = [border, border, size(I, 2)- 2*border, size(I, 1)- 2*border];
prevPoints   = detectSURFFeatures(I, 'NumOctaves', 6, 'ROI', roi);

prevFeatures = extractFeatures(I, prevPoints, 'Upright', true);

vSet = viewSet;

viewId = 1;
vSet = addView(vSet, viewId, 'Points', prevPoints, 'Orientation', ...
    eye(3, 'like', prevPoints.Location), 'Location', ...
    zeros(1, 3, 'like', prevPoints.Location));

%% Add the Rest of the Views
for i = 2:numel(images)

    I = images{i};
    currPoints   = detectSURFFeatures(I, 'NumOctaves', 8, 'ROI', roi);
    currFeatures = extractFeatures(I, currPoints, 'Upright', true);
    indexPairs = matchFeatures(prevFeatures, currFeatures, ...
        'MaxRatio', .7, 'Unique',  true);

    matchedPoints1 = prevPoints(indexPairs(:, 1));
    matchedPoints2 = currPoints(indexPairs(:, 2));

    [relativeOrient, relativeLoc, inlierIdx] = helperEstimateRelativePose(...
        matchedPoints1, matchedPoints2, cameraParams);

    vSet = addView(vSet, i, 'Points', currPoints);

    vSet = addConnection(vSet, i-1, i, 'Matches', indexPairs(inlierIdx,:));

    prevPose = poses(vSet, i-1);
    prevOrientation = prevPose.Orientation{1};
    prevLocation    = prevPose.Location{1};

    orientation = relativeOrient * prevOrientation;
    location    = prevLocation + relativeLoc * prevOrientation;
    vSet = updateView(vSet, i, 'Orientation', orientation, ...
        'Location', location);

    tracks = findTracks(vSet);

    camPoses = poses(vSet);

    xyzPoints = triangulateMultiview(tracks, camPoses, cameraParams);

    [~, camPoses, ~] = bundleAdjustment(xyzPoints, ...
        tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
        'PointsUndistorted', true);

    vSet = updateView(vSet, camPoses);

    prevFeatures = currFeatures;
    prevPoints   = currPoints;
end

%% Display Camera Poses
% camPoses = poses(vSet);
% figure;
% plotCamera(camPoses, 'Size', 0.2);
% hold on
% 
% % Exclude noisy 3-D points.
% goodIdx = (reprojectionErrors < 5);
% xyzPoints = xyzPoints(goodIdx, :);
% 
% % Display the 3-D points.
% pcshow(xyzPoints, 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
%     'MarkerSize', 45);
% grid on
% hold off
% 
% % Specify the viewing volume.
% loc1 = camPoses.Location{1};
% xlim([loc1(1)-5, loc1(1)+4]);
% ylim([loc1(2)-5, loc1(2)+4]);
% zlim([loc1(3)-1, loc1(3)+20]);
% camorbit(0, -30);
% 
% title('Refined Camera Poses');

%% Compute Dense Reconstruction
% Read and undistort the first image
% I = undistortImage(images{1}, cameraParams);
I = images{1};

% Detect corners in the first image.
prevPoints = detectMinEigenFeatures(I, 'MinQuality', 0.001);

% Create the point tracker object to track the points across views.
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 6);

% Initialize the point tracker.
prevPoints = prevPoints.Location;
initialize(tracker, prevPoints, I);

% Store the dense points in the view set.
vSet = updateConnection(vSet, 1, 2, 'Matches', zeros(0, 2));
vSet = updateView(vSet, 1, 'Points', prevPoints);

% Track the points across all views.
for i = 2:numel(images)
    % Read and undistort the current image.
    I = undistortImage(images{i}, cameraParams);

    % Track the points.
    [currPoints, validIdx] = step(tracker, I);

    % Clear the old matches between the points.
    if i < numel(images)
        vSet = updateConnection(vSet, i, i+1, 'Matches', zeros(0, 2));
    end
    vSet = updateView(vSet, i, 'Points', currPoints);

    % Store the point matches in the view set.
    matches = repmat((1:size(prevPoints, 1))', [1, 2]);
    matches = matches(validIdx, :);
    vSet = updateConnection(vSet, i-1, i, 'Matches', matches);
end

% Find point tracks across all views.
tracks = findTracks(vSet);

% Find point tracks across all views.
camPoses = poses(vSet);

% Triangulate initial locations for the 3-D world points.
xyzPoints = triangulateMultiview(tracks, camPoses,...
    cameraParams);

% Refine the 3-D world points and camera poses.
[xyzPoints, camPoses, reprojectionErrors] = bundleAdjustment(...
    xyzPoints, tracks, camPoses, cameraParams, 'FixedViewId', 1, ...
    'PointsUndistorted', true);

%% Display Dense Reconstruction
% Display the refined camera poses.
figure;
plotCamera(camPoses, 'Size', 0.2);
hold on

% Exclude noisy 3-D world points.
goodIdx = (reprojectionErrors < 5);

% Display the dense 3-D world points.
pcshow(xyzPoints(goodIdx, :), 'VerticalAxis', 'y', 'VerticalAxisDir', 'down', ...
    'MarkerSize', 45);
grid on
hold off

% Specify the viewing volume.
loc1 = camPoses.Location{1};
xlim([loc1(1)-50, loc1(1)+50]);
ylim([loc1(2)-50, loc1(2)+50]);
zlim([loc1(3)-50, loc1(3)+50]);
camorbit(0, -30);

title('Dense Reconstruction');