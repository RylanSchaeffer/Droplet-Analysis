# Droplet-Analysis

For ECS193 (Senior Design), Ramya Bhaskar, Amanda Ho, Willie Huey and I completed a project for Professor Benjamin Shaw (http://faculty.engineering.ucdavis.edu/shaw/). The project was to design and implement an algorithm that can (with relative accuracy) predict the diameter of a fuel droplet combusting in a zero-gravity environment. Although the droplets are roughly circular, the problem is compounded by the presence of "soot," which adds noise to the image.

Amanda, Willie and I worked on a MATLAB implementation, while Ramya explored OpenCV. Our first approach was to use built in MATLAB functions and basic statistical techniques to predict "circles of best fit" for each image. Simulated images are publicly available on one of my Google Drive accounts(https://drive.google.com/folderview?id=0BxVyAsYY7QlqfjhJaWcwMVRaUHhvOWNvX3pfa0Q0VTgwRmg2MWQ2M3l0UUw1cU0xdGFiMms&usp=sharing).

Hopefully, I'll have time to explore a convolution neural net to see what improvements it might offer over the first approach.