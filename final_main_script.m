clc;
clear;
close all;
% Load the image containing shapes and numbers
binaryImage = imread('shapes_and_numbers.png');
binaryImage = imbinarize(binaryImage);

% Apply operations to clean up the image
se = strel('disk', 2);
binaryImage = imopen(binaryImage, se);

% Detect connected components in the image
[labeledImage, numRegions] = bwlabel(binaryImage, 8);
regionProps = regionprops(labeledImage, 'centroid');
centroids = cat(1, regionProps.Centroid);

% Display the labeled image with centroids
figure;
imshow(binaryImage);
hold on;
plot(centroids(:, 1), centroids(:, 2), 'r*');
hold off;
title(['Detected objects: ', num2str(numRegions)]);

% Initialize arrays to store Fourier descriptors and labels
numDescriptors = 10; 
shapeDescriptors = zeros(numRegions, numDescriptors);
numberLabels = cell(numRegions, 1);

% Extract Fourier descriptors and label the regions
for i = 1:numRegions
    regionMask = labeledImage == i;
    boundary = bwboundaries(regionMask, 'noholes');
    x = boundary{1}(:, 2);
    y = boundary{1}(:, 1);
    
    % Compute Fourier descriptors using DFT
    complexDescriptors = fft(x + 1i * y);
    shapeDescriptors(i, :) = abs(complexDescriptors(1:numDescriptors));
    
    % Determine the label based on the number of corners
    numCorners = length(find(detectHarrisfeatures(regionMask)));
    if numCorners == 4
        numberLabels{i} = 'Rectangle';
    elseif numCorners == 3
        numberLabels{i} = 'Triangle';
    elseif numCorners == 0
        numberLabels{i} = 'Circle';
    else
        numberLabels{i} = 'Unknown';
    end
end

% Display the shape descriptors and labels
disp('Shape Descriptors:');
disp(shapeDescriptors);
disp('Number Labels:');
disp(numberLabels);
