# Improved weight assignment of four-direction smoothing

## Introduction
This code is used to construct a four-direction smoothing matrix based on the guide image and its structural tensor field and semblance field. The structure orientation is unvarying within an inversion element and is only evaluated at the center of the element. We choose the direction in which the semi-axis length of the diffusion tensor ellipse is the largest in the four smoothing directions as the preferred smoothing direction in an element. For the four different preferential smoothing directions (horizontal, vertical and two types of inclined structural), we adopt four different weight configurations. For 2D models, each element is smoothed between its neighbors (eight elements around it) and we configure special smoothing weights only for elements on structural boundaries, which we call boundary elements. We assign large values (w_max) for smoothing weights between boundary elements on the same side of the structure, enhancing the smoothness along the structure direction, and small values (w_min) for smoothing weights between boundary elements across structures, reducing the cross-boundary smoothness.

## Usage

Here are step-by-step instructions for running this program locally on your machine:

1. Install Matlab R2019 or above.

2. 

3. Input the guide image (Note that it is a grayscale image) and its structural tensor field and semblance field. The above data is obtained by referring to Hale (2009) and Zhou et al. (2014). Note that  put the above files in a folder with the code. (Reference: Hale, D., 2009. Structure-oriented smoothing and semblance. CWP Report 635; Zhou, J., Revil, A., Karaoulis, M., Hale, D., Doetsch, J., Cuttler, S., 2014. Image-guided inversion of electrical resistivity data. Geophysical Journal International 197, 292-309)

4. Define the inversion mesh parameters.

5. Set the calculation parameters.

6. Set drawing parameters.

7. Run the program in the MATLAB editor

8. Export four-direction smoothing matrix

### Example Demonstration

1. Calculate the four-direction smoothing matrix of the guide image 'gui_img.jpg'. Put the file 'gui_img.jpg'  in a folder with the code 'structural_weighting_four.m'. The program run will call the above files.  

2. 's1.mat' and 's2.mat' in the interfile are  two semblance matrices of guided image.  'v.mat' is the eigenvector sequence of the guide image pixels.  'ev.mat' is the eigenvalue sequence of the guide image pixels.  Put the above files in a folder with the code . The program run will call the above files.

3.  'inv_mesh_coords.mat' and 'Coord_y.mat' are setting files of inversion mesh parameters. Put the above files in a folder with the code and the program run will call the above files.

4. Setting input calculation parameters 
    we consider the cases when s2 is less than 0.93 as a continuous structure, and pass 'threshold_discontinuity=0.93' to achieve it.
    We assign large values (w_max) for smoothing weights between boundary elements on the same side of the structure, enhancing the smoothness along the structure direction, and small values (w_min) for smoothing weights between boundary elements across structures, reducing the cross-boundary smoothness. The w_max and w_min are 10 and 0.1 and the value of other weights (w_con) is still 1. The parameters are set as follows: 'w_max=10', 'w_con=1','w_min=0.1'.

5. Set tensor ellipse control parameters to protect the reasonable display of tensor ellipse as follows 'r =0.3', 'nt =100', 'usamp=1', 'marker_size=5', 'dt = 2.0*pi/(nt-1)', 'ft = 0', 'hstep=0.03', 'plot_ellipses=1'.

6. Run the program in the MATLAB editor to calculate the four-direction smoothing matrix (w1, w2, w3, w4). The  w1, w2, w3 and w4 are smoothing matrices in the x, z, d1 and d2 (two diagonal directions of mesh) directions, respectively.

7. The files 'w1.mat', 'w2.mat', 'w3.mat' and 'w4.mat' generated in the main folder are the four-direction smoothing  matrices in the x, z, d1 and d2 directions, respectively.

## Issues
Please contact me (E-mail: maxmkzx@mail.sdu.edu.cn) if you encounter any problems while trying to run the program.

## License
The codes allows academic and commercial re-use and adaptation of this work.

