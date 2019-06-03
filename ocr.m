%% Read Image 
Inputimage=imread('mam.jpg'); 
%% Show image 
figure(1) 
imshow(Inputimage); 
title('INPUT IMAGE WITH NOISE') 
pkg load image 
%% Convert to gray scale 
if size(Inputimage,3)==3 % RGB image 
 Inputimage=rgb2gray(Inputimage); 
end  
%Given an image img finds the optimal threshold value level for 
%conversion to a binary image with im2bw. Color images are converted  
%to grayscale before level is computed 
%Default OTSU 
%Convert to binary image 
threshold = graythresh(Inputimage); 
%Convert image to binary, black and white, by threshold 
Inputimage =~im2bw(Inputimage,threshold); 
%Perform area opening. 
%bwareaopen (bw, lim) 
%Remove objects with less than lim elements from a binary image bw. 
%% Remove all object containing fewer than 30 pixels 
Inputimage = bwareaopen(Inputimage,30); 
pause(1);
% Label connected components 
%bwlabeln(BW) returns a label matrix, L, containing labels for the connected  
%components in BW. bwlabeln uses a default connectivity of 8 for two dimensions,  
%26 for three dimensions 
[L Ne]=bwlabel(Inputimage); 
%L is a matrix containing the pixel value as label_number 
%Ne is number of labels 
%regionprops(BW,properties) returns measurements for the set of  
%properties specified by properties for each 8-connected component 
%(object) in the binary image 
propied=regionprops(L,'BoundingBox'); 
imshow(~Inputimage); 
hold on 
%propied(1) gives 171.500    93.500    90.000   115.000 
%x y width height 
for n=1:size(propied,1) 
  rectangle('Position',propied(n).BoundingBox,'EdgeColor','g','LineWidth',2) 
end 
hold off 
pause (1); 
Resultados='C:\Users\Abhi Mahajan\Desktop\ocr\images'; 
%% Objects extraction 
figure 
for n=1:Ne 
  [r,c] = find(L==n); 
  %returns the row_number and column_number of all the cells in label n 
  n1=Inputimage(min(r):max(r),min(c):max(c)); 
%The Activity given at evaluation to resize the alternate 3-letters in the original image %and then apply OCR on that image 
  if mod(n,3)==0 
  [rows columns]=size(n1); 
  binaryImage = padarray(n1, 100); 
  binaryImage = imresize(binaryImage, [rows, columns]); 
  n1=binaryImage; 
  Inputimage(min(r):max(r),min(c):max(c))=n1; 
    end 
  imshow(~n1); 
 %Write the image scanned to a folder  
  baseFileName = sprintf('%d.png',n);  
  fullFileName = fullfile(Resultados, baseFileName); % No need to worry about slashes now! 
  imwrite(~n1, fullFileName); 
 %Write the image in text file 
  basefilename = sprintf('%d.txt',n); 
  fullfilename = fullfile(Resultados, basefilename); 
  imwrite(~n1,fullfilename); 
  pause(0.5) 
end 
%Image with alternate 3-letters resized 
imshow(~Inputimage);