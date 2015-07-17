# User Guide

1. NASA_Droplet_Image_Analysis.m  
This program prompts the user for the directory where the image sequence is located and which image in the sequence to start the
analysis at. It then opens the specified image and prompts the user to draw a circle around the droplet. Once the user has drawn a circle as accurately as possible, the program searches for a circle of best fit by using a Circular Hough Transform (imfindcircle()) on the subsequent image and the subsequent image under a binary gradient mask. The program then chooses the circle of best fit based on which of the two possible circles is closest to the preceding circle of best fit. If it is unable to detect any circles in an image, it will move to the next image. The program will continue until all the images in the sequence have been processed.

2. CSV_Saver.m  
This program takes the results from NASA_Droplet_Image_Analysis and saves them to a CSV file.

3. Save_Images.m  
This program takes the results from NASA_Droplet_Image_Analysis, draws the detected circles onto the original image, and saves the picture as a new image.

4. MSE.m  
This program compares the results from NASA_Droplet_Image_Analysis with human measured data and calculates the mean squared error.

5. Make_Video.m  
This program makes a grayscale video clip (.avi) from a sequence of images (.tiff). Color images will be converted to grayscale. Program assumes that images are ordered by filename.

6. Measure_Circle.m  
This program allows you to measure an image sequence manually by drawing a circle around the droplet in each image and obtaining the measurements.