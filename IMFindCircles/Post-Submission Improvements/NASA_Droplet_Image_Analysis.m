%STEP 1:
%Have the user select the complete file path and the first image number in
%the sequence and the last image number in the sequence. This is in case the
%image sequence has irrelevant images at the beginning or end i.e. fuel injection.

%Prompt user for directory
directory = '/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5';
%directory = uigetdir;

%Prompt user for first image to start the analysis
first_image = input('Would you kindly enter the image number to start at? ');

%Prompt user for last image to end the analysis
last_image = input('Would you kindly enter the image number to end at? ');

file_extension = '.tif';



%STEP 2:
%Open the directory containing all the image files
files = dir(strcat(directory,'//','*',file_extension));




%STEP 3:
%Create a (number-of-images) by 3 matrix. For each image, this matrix
%will store the following:
%   All values will be initialized to NaN (Not a Number).
%   Column 1 will be the x-coordinate of the estimated circle.
%   Column 2 will be the y-coordinate of the estimated circle.
%   Column 3 will be the radius of the estimated circle.
Circle_Estimation = nan(length(files),3);




%THIS PART IS BEING WORKED ON

%STEP 4:
%To find potential circles, the Circular Hough Transform requires a lower bound
%and an upper bound to limit the number of possible circles. Since the
%images early in the sequence have comparatively more noise (in the form of
%soot), our algorithm starts with the final image in the sequence and
%proceeds towards the first image in the sequence.

%Because there is little change between two consecutive images, we choose
%the circle of best fit based on on the circle closest (with respect to position
%and size) to the prior image's circle of best fit. This means that finding
%a good initial value is incredibly important. Because we want the analysis 
%to be as automated as possible, we ask the user to create a circle of best
%fit.

%Show user the first image in the sequence. Prompt the user to inscribe the
%droplet in a circle.
disp('Please draw and position a circle around the droplet.');
disp('You may need to zoom in using the magnifying glass tool.');
disp('Once the circle has been drawn, please right click and select Copy Position');
final_image = strcat(directory,'//',files(last_image).name);
imshow(final_image);
h = imellipse;
pos = input('Please paste the copied data here: ');
position_i = getPosition(h);
width_i = position_i(3);
height_i = position_i(4);
centerx_i = position_i(1) + position_i(3)/2;
centery_i = position_i(2) + position_i(4)/2;
finalRadiusLowerBound = width_i/2;
close all;

%To do so, we calculate the radius of five circles towards the end of the 
%sequence. If the calculated circles' centers and radii differ substantially, 
%we prompt the user to select the circle manually. Otherwise, we display
%the circle of best fit and ask the user to verify that the circle of best
%fit is approximately correct.

%Given no a priori knowledge of the droplet's radius, we initialize the lower 
%bound to a high value and iteratively decrease the bound until we catch a 
%good initial value.

% images = {rgb2gray(imread('/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5/frame-0348.tif')), ...
% rgb2gray(imread('/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5/frame-0340.tif')), ...
% rgb2gray(imread('/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5/frame-0332.tif')), ...
% rgb2gray(imread('/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5/frame-0324.tif')), ...
% rgb2gray(imread('/media/rylan/Windows8_OS/Users/Rylan/Documents/193/simulated images/Image Sequence 5/frame-0316.tif'))};
% 
% imageResults = [];
% 
% for iter = 1:5
%     imageCell = images(iter);
%     image = imageCell{1};
%     
%     finalRadiusLowerBound = 60;
%     centersDark = [];
%     
%     while (isempty(centersDark))
%         finalRadiusLowerBound = finalRadiusLowerBound - 10;
% 
%         if (finalRadiusLowerBound <= 5)
%             break;
%         end
% 
%         [centersDark, radiiDark, metric] = imfindcircles(image,...,
%             [finalRadiusLowerBound (finalRadiusLowerBound+20)],'ObjectPolarity','dark','Sensitivity',0.95);
% 
%         if(~isempty(radiiDark))
%             imageResults(iter,1:2) = centersDark(1,1:2);
%         end
%     end
% end
% 
% clear iter
% 
% %Having estimated circles for five images, determine whether the estimated
% %circles' centers substantially differ.  If yes, prompt the user to
% %manually select the circle.  If not, proceed.
% meanX = mean(imageResults(:,1));
% meanY = mean(imageResults(:,2));
% 
% %Calculate mean squared error of the estimated circles from the five
% %circles' means
% mse = (sum((imageResults(:,1)-meanX).^2) + sum((imageResults(:,2)-meanY).^2))/5;
% 
% %If mean squared error is larger than five percent of the circle's center,
% %request that the user manually highlight the circle.
% if ((mse > 0.05 * meanX) || (mse > 0.05 * meanY))
%     
%     user_input = 0;
%     iter = 1;
%     
%     while (user_input == 0)
%         disp('The circle of interest is unclear.  We need you to select it for us.');
%         imshow(images{iter});
%         disp('If the image has a circle that you can identify, please type "1" and press Enter.');
%         user_input = input('If circle is not clear to you, please type "0" and press Enter: ');
%     
%         iter = iter + 1;
%         
%     end
%     
%     
%     
%     disp('Please draw and position a circle around the droplet.');
%     disp('You may need to zoom in using the magnifying glass tool.');
%     disp('Once the circle has been drawn, please right click and select Copy Position');
%     circle = imellipse;
%     pos = input('Please paste the copied data here: ');
%     
%     finalRadiusLowerBound = min(pos(3),pos(4)) - 5;
%     
%     close figure 1
% %If the mean squared error is less than five percent of the circle's
% %center, the algorithm has likely identified the correct circle. Display
% %the circle and ask the user to approve it, or adjust it if necessary.
% else
%     
% end
% 
% 
% %working through here


%Step 5:
%Iterate through each image in the directory, starting with the final image.
%For each image, we apply a Canny edge detection algorithm. This calculates 
%a gradient of the image, which accentuates pixels that differ substantially
%from their neighboring pixels. This produces a second image that we can
%search for circles in.

count = last_image;
estimatedRadiusLowerBound = finalRadiusLowerBound;
for file = flipud(files)'

    disp(strcat('Working on  ',file.name));
    
    try
        image = rgb2gray(imread(strcat(directory,'//',file.name)));
    catch
        image = mat2gray(imread(strcat(directory,'//',file.name)));
    end
    
    %Perform edge detection using the Canny method. 
    [temp, threshold1] = edge(image, 'Sobel');
    fudgeFactor = .1;
    canny = edge(image,'Canny', threshold1 * fudgeFactor);

    %Use imfindcircles to find potential circles in the original image
    try
        [centersDark, radiiDark, metric] = imfindcircles(image,...
             [floor(estimatedRadiusLowerBound) (floor(estimatedRadiusLowerBound)+10)],...
             'ObjectPolarity','dark','Sensitivity',0.99);
    catch
    end
    
    %Use imfindcircles to find potential circles in the gradient image
    try
        [centersDark2, radiiDark2, metric2] = imfindcircles(canny,...
             [floor(estimatedRadiusLowerBound) (floor(estimatedRadiusLowerBound)+10)],...
             'ObjectPolarity','dark','Sensitivity',0.99);
    catch
    end
    
    %Determine which circle found by imfindcircles is most similar to the
    %previous image's circle of best fit.
    
%      if(count == last_image)
%          xhat = centerx_i; %get the x-coord of drawn image
%          yhat = centery_i; %get the y-coord of drawn image
%          rhat = initial_radius; %get the radius of the drawn image
%          try%try to see if you can calculate a best fit circle on original image
%          [min1, pos] = min(abs(centersDark(:,1)-xhat) + ...
%             abs(centersDark(:,2)-yhat) + abs(radiiDark(:)-rhat));
%          catch%can't calculate a circle of best fit on the original image
%              pos = 100000;
%          end
%          %Calculate circle of best fit of the binary gradient image
%          [min2, pos2] = min(abs(centersDark2(:,1)-xhat) + ...
%             abs(centersDark2(:,2)-yhat) + abs(radiiDark2(:)-rhat));
%         if( pos == 100000)%Can't detect a circle in original image
%             Circle_Estimation(count,:) = [centersDark2(pos2,1:2) radiiDark2(pos2,1)];
%         else
%         %Can detect a circle in original image. So determine whether circle 
%         %of best fit is original image or binary gradient mask of oringal image
%             if(min1 < min2)
%                 Circle_Estimation(count,:) = [centersDark(pos,1:2) radiiDark(pos,1)];
%             else
%                 Circle_Estimation(count,:) = [centersDark2(pos2,1:2) radiiDark2(pos2,1)];
%             end            
%         end              
%      end
%     
%     %If the current image is subsequent to the first image in the sequence,
%     %assume that the correct circle is the circle with center closest to
%     %the previous circle's center.
%     if(count > first_image)
%         xhat = Circle_Estimation(count-1,1);
%         yhat = Circle_Estimation(count-1,2);
%         rhat = Circle_Estimation(count-1,3);
%         
%         try
%         [min1, pos] = min(abs(centersDark(:,1)-xhat) + ...
%             abs(centersDark(:,2)-yhat) + abs(radiiDark(:)-rhat));
%         catch
%             pos = 100000;
%         end
%         [min2, pos2] = min(abs(centersDark2(:,1)-xhat) + ...
%             abs(centersDark2(:,2)-yhat) + abs(radiiDark2(:)-rhat));
%         if(pos == 100000)
%             Circle_Estimation(count,:) = [centersDark2(pos2,1:2) radiiDark2(pos2,1)];
%         else
%             if(min1 < min2)
%                 try
%                     Circle_Estimation(count,:) = [centersDark(pos,1:2) radiiDark(pos,1)];
%                 catch
%                     Circle_Estimation(count,:) = [centersDark2(pos2,1:2) radiiDark2(pos2,1)];
%                 end
%             else
%                 Circle_Estimation(count,:) = [centersDark2(pos2,1:2) radiiDark2(pos2,1)];
%             end            
%         end
%     end
    
    
    estimatedRadiusLowerBound = mean([radiiDark(1) radiiDark2(1)]);
    Circle_Estimation(count, 3) = estimatedRadiusLowerBound;
    count = count - 1;
end
