# HOG

### PEDESTRIAN DETECTION BY IMPLEMENTING HOG (HISTOGRAM OF ORIENTED GRADIENTS)

![fpdw_detection_example3.png](https://lh6.googleusercontent.com/17JvaqGJcq0AB1UzjqtQ2h2XMJFGaH8cB4OYlWeisIFT-l5BYgEcjSQX9agRTAko7OQ085H2ll912rmV6FWugZBYH9pA9WqZjO6k_kgaYxWTc7fOqCWHTw_vuzVZZ7MVKZzJiOuNy2YodnkieA)

Detecting and extracting humans in images is a difficult task and has been the subject of intense research work for the past few years. In this note we address the problem of pedestrian extraction from Images using the Histogram of Oriented Gradients (HOG), this implementation closely follows the one by “Triggs and Dalal”.The goal of the study is to analyze the performance of different techniques of pedestrian detection with HOG. Experiments are done on image available in MIT and INRIA dataset. The HOG vector compresses the image while keeping the key information intact.

The images are isolated into 64 x 128 grids and calculated the gradients using these results the magnitude and direction of the change in intensity of the image pixels have been determined. These are tabulated in a histogram of oriented gradients thereby reducing the total features required for an image. The proposed algorithm gives positive results and extracts the pedestrian completely from the image datasets. It also overcomes the problems of edge detection in many cases. It may be noted that the algorithm fails partially for cases where the value of the gradient is vanishing, where the pedestrian is not completely visible.

##  

## What is a Feature Descriptor?

A feature descriptor is a representation of an image or an image patch that simplifies the image by extracting useful information and throwing away extraneous information.

Typically, a feature descriptor converts an image of size width x height to a feature vector / array of length n. In the case of the HOG feature descriptor, the input image is of size 256 x 256 and the output feature vector is of length 3780.

It is very useful for tasks like image recognition and object detection. The feature vector produced by these algorithms when fed into an image classification algorithm like Support Vector Machine (SVM) produces good results.

In the HOG feature descriptor, the distribution ( histograms ) of directions of gradients ( oriented gradients ) are used as features. Gradients ( x and y derivatives ) of an image are useful because the magnitude of gradients is large around edges and corners ( regions of abrupt intensity changes ) and we know that edges and corners pack in a lot more information about object shape than flat regions.

METHODOLOGY

1. #### Calculation of Gradients

Gradients can be computed using several schemes. The way in which gradient is computed affects the performance of detector. We have tested on several masks including [-1,0,1] ,[1,-8,0,8,-1] as well as on [-1,1], but simple 1-D center  mask works best, while other masks reduces the performance. The results obtained on applying different masks on image are shown in fig (1).

![img](https://lh6.googleusercontent.com/oVU9vqBtcFDr7ehW44ddQLyoSdWz0dVKBJi5V11zhum_gvR2rCprlcK_oQVeTp9lVznCPS-xBsYNkeFnYW5XZ_kjhpP63BzNpE0Rbuknmi5Ar-D-Mm5R1jw-YZ9LlVnSxasr_FWzbltUR4ZacQ)              ![img](https://lh6.googleusercontent.com/DucixPmi_rdgVjJ_kYt6hY_7p-NOHcaeTVQsKDJxk8ty-KZ_8e79TLi4yGwf1ZPXnzaP709DTrAdC9bdzprgHngsHJyJXm8KH0D_cbzbSP6ZLmL8XRuEBCVKfaBYalwhonK4uTDBSLZc0b7how)

​                              (a)                                                                       (b)

Fig (1):  (a) original image    (b) using [-1, 1] mask on  

image original image

![img](https://lh6.googleusercontent.com/2ePA3DHIxJvTi9EQCgxeV7oqEGsBG0cvEhH-16M3Rxytgavw6xwU_vZ4DhQNqKgueip-X9fmg0Hq6Hvyqt8t2ZRkrf8PUW5nonVc5eDIQ3mwL7MQghR-v_w-pgTVKRqTlleCR-powD4Up_FZIg)                              ![img](https://lh3.googleusercontent.com/fLFr5EbHD3GFwdXjG6TDrtreiZo8_Xh5Fid7nf1YrwaBY8aP8L7ZthzzkjFmBVbnDoKSCyuUgqDSHV4E8UC6jnzIXIvt8AfV997QVvZy3aOxkp5QFF46S8NTHce63ddDxH4uWvs1c2a_GUluSg)  

​                               (c)                                                                                         (d)

​                        

(c) Using [1, -8, 0, 8, -1] mask    (d) using [-1, 0, 1] mask

The gradients computed from the row and column vectors formed by -1, 0 and 1 are the magnitudes of derivatives in horizontal and vertical direction. The magnitude of gradient vector is calculated taking root of sum of squares of gradients in horizontal and vertical direction.

dx=Ij+1-Ij-1    and    dy=Ik+1-Ik-1

where, Ij+1=Intensity of pixel next to interested pixel in horizontal direction.

​                Ij-1= Intensity of pixel previous to interested pixel in horizontal direction.

​                Ik+1=Intensity of pixel next to interested pixel in vertical direction.

​           

​          Ik+1=Intensity of pixel previous to interested pixel in vertical direction.

Magnitude=√ (dx2+dy2)

​                                             Direction=tan-1(dy/dx)

The angle of gradient is calculated taking the tangent inverse of vertical component to horizontal component at every pixel in image. At some points in image the angle will comes out to be not defined. These are the points where intensity change in intensity in horizontal and vertical direction is zero so, these points do not contribute to any feature of image i.e. they represent plain area in image with same color and hence these valves are replaced with 0 in our implementation for ease. For colored image, gradients of all 3 planes are calculated and one with largest normalized gradient is selected for further processing.

​           

2. #### Orientation Binning

Next step is to accumulate the gradient magnitude into 1-d histogram. Since directions are distributed evenly from 0-180o, so they are accumulated in a reasonable no. of bins .The selection of no. of bins also affect the performance of descriptor. Increasing no. of bins up to 9 increases the performance significantly but after that performance decreases.

The binning process is shown in fig (2)

![img](https://lh6.googleusercontent.com/eV0bB5lsoi_fDZdwqDTz_vBwTFkefgKmiH2FnHO-uQWYV2kZ15x9Y2fwCmzJ0oTimcVcHkJoWDLzQGLUL8KgTlXxjhkqZcyPgsjYZFNsXM7NFIlYZPoPGVRbDblLimKcC1LG34RpfHLSGH7Kwg)

The contributions of all the pixels in the 8×8 cells are added up to create the 9-bin histogram. For the patch above, it looks like this

![https://www.learnopencv.com/wp-content/uploads/2016/12/histogram-8x8-cell.png](https://lh4.googleusercontent.com/3hir0DbyLSGWZY_PIJvpUyundOxIXoRXbayvajPpWIcGY9ZaFnTAPrpOum_Ei1Ip7ys8m88j8VVx9KfznzESjLuLYAMQrhjDDdPWRbSoW5himBiiW1fvpn-0vmUtyJuqH7qwD3F3SxtUS0sR9g)

3. #### Vector Formulation and SVM

For eliminating the effect of foreground and background contrast, spatial vector is normalized forming groups of cells. A large vector is formed of these accumulating features of these blocks together. After forming the vectors of all the training images, all vectors are fed into linear Support Vector Machine (SVM) along with a group vector storing 1 and 0 corresponding to the image having pedestrian(s) and the image having no pedestrian respectively in the training dataset. Then all the feature vectors corresponding to test dataset are fed into SVM Classifier which gives output in the form of a vector having 1 and 0 corresponding to the image having pedestrian(s) and image having no pedestrian respectively.