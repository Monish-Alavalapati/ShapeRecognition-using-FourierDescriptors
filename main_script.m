clc;
clear;
close all;
image = imread('image_input.png');
image = imbinarize(image, 0.5);

boundaries = bwboundaries(image);
for k = 1:length(boundaries)
    boundary = boundaries{k};
    
    %Computing fourier descriptors
    complex_descriptor = complex(boundary(:, 2), boundary(:, 1));
    fourier_descriptor = fft(complex_descriptor);
    
    %Removing low frequency components
    num_coefficients = 20;
    fourier_descriptor(num_coefficients+1:end-num_coefficients) = 0;

    %Reconstruction shape from Fourier descriptors
    reconstructed_descriptor = ifft(fourier_descriptor);
    reconstructed_boundary = [real(reconstructed_descriptor), imag(reconstructed_descriptor)];

    %Plotting original v/s reconstructed shapes
    figure;
    subplot(1,2,1);
    imshow(image);
    hold on;
    plot(boundary(:, 2), boundary(:, 1), 'r', 'LineWidth', 2);
    title('Original Shape');
    subplot(1,2,2);
    imshow(image);
    hold on;
    plot(reconstructed_boundary(:, 1), reconstructed_boundary(:, 2), 'g', 'LineWidth', 2);
    title('Reconstructed Shape');

end