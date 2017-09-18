# Object-Recognition-and-Curvature-Histograms
# Description 
This perl script compares partial 3 dimensional pieces with 2 dimensional prototypes. Once it has completed its analysis a particular prototype is chosen and a confidence. I completed this project in 2008, and I realize that it requires some cleaning and improving. There is additional information in the Object Recognition and Curvature Histograms doc file.
# Install
This script requires Perl. I used perl 
All that is needed 
# Usage Example
There are two steps in using the 3D compare script
1. Creating prototypes
2. Running script on partial 3 dimensional pieces
*these can actually be combined, but I will explain them separately*

1. Creating Prototypes
.obj to .prt 
The prototype files (.prt) are the curvature histograms to be used in comparison. When going from .obj to histograms the file is projected onto the x-y plane. The curvature of each point will be calulated from this profile. A 3D viewer will be useful at this point to save the desired orientation. Look at profile looking at the x-y plane before saving. Use 3DCompare.pl is the prototype creation mode:

3DCompare.pl desired_object-1.obj desired_object-1.obj ... desired_object-n.obj
with: @parts = (1,0,0,0)

2. Running 3Dcompare.pl to compare pieces and Prototype files
There are two run modes that will be used. 3DCompare.pl 0 1 1 1 and 3DCompare.pl 0 0 0 1

3DCompare.pl 0 1 1 1
Should be used the first time. The script will create the curvature histograms for 

 3DCompare.pl 0 0 0 1
Will just perform the last step. This is useful when fine tuning parameters. They can be edited infaf

# Issues
I have not tested these scripts on other machines or other methods. I anticipate that one may have resolution issues if the prototype and partial 3 dimensional part comes from different sources. The 3Dcompare.pl has multiple switches to deal with this, however some drastically increase runtime (multiple hours!) 
dfsaf
# License
This code is free to use. Please fork, if you plan to make changes. 
