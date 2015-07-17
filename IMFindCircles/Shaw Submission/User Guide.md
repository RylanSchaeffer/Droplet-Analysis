# User Guide

1. NASA_Droplet_Image_Analysis.m

This program prompts the user for the directory where the image sequence is located and which image in the sequence to start
analysis at. It then opens the specified image and prompts the user to draw a circle around the droplet. Once the user has drawn a circle as accurate as possible, the program will start processing the image sequence. The program searches for a circle of best fit by using a Circular Hough Transform (imfindcircle()) on the original image and the original image with a binary gradient mask, resulting in two possible detected circles. The program then chooses the circle of best fit based on which of the two circles is closest to the preceding circle of best-fit. If it is unable to detect any circles in an image, it will move to the next image. The program will continue until all the images in the sequence have been processed.