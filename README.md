# Description 
This Perl script compares partial 3 dimensional pieces with 2 dimensional prototypes. Once it has completed its analysis a particular prototype is chosen and a confidence interval given. I completed this project in 2008. There is additional information in the Object Recognition and Curvature Histograms docx file.

# Install
This script requires Perl. I used ActivePerl 5.10 Build 1001 on a windows machine, but the script should still be usable on any platform, and more current versions. Once the Perl script is downloaded everything can run from that folder. Only 3Dcompare.pl is needed. The other files can be used to understand how the script works, but are not necessary.

# Usage Example
There are two steps in using the 3D compare script. Inside the Perl script there is an array that controls the run mode near the top `@parts = (0,0,0,1)` This array will need to be edited to suit the user's goals. 

### Steps:
### 1. Creating prototypes
### 2. Running script on partial 3 dimensional pieces

### 1. Creating Prototypes
##### .obj to .prt 
The prototype files (.prt) are the curvature histograms to be used in comparison. When going from .obj to histograms the file is projected onto the x-y plane. The curvature of each point will be calculated from this profile. A 3D viewer will be useful at this point to save the desired orientation. Look at profile looking at the x-y plane before saving. Use 3DCompare.pl is the prototype creation mode (`@parts = (1,0,0,0)`):

On the command run the script with all the prototype .obj files as arguments.
*Example:* `3DCompare.pl prototype_object-1.obj prototype_object-2.obj ... prototype_object-n.obj`

### 2. Running 3Dcompare.pl to compare pieces and Prototype files
There are two run modes that will be used. 3DCompare.pl mode: 0 1 1 1 and 3DCompare.pl mode: 0 0 0 1

3DCompare.pl with `@parts = (0,1,1,1)`
Should be used the first time. The script will create the curvature histograms for comparison, interpolates histogram files, and then runs comparison.
*Example:* `3DCompare.pl partial_object-1.obj partial_object-1.obj ... partial_object-n.obj`

3DCompare.pl with `@parts = (0,0,0,1)`
Will just perform the last step. This is useful when fine tuning parameters. They can be edited in Perl script. Look near the top for:

```
use constant TOLERANCE => 0.00;#percent match before histogram sequence is compared
use constant OFFSET_SWITCH => 0;#turns offset on or off
use constant CURVATURE_CEILING => 1;#limits offset search to reasonable numbers 
use constant BESTFIT_AVERAGING => 20;#Averages the top 1 / (BF_A) Best fit numbers. 0 is off
use constant WORSTFIT_AVERAGING => 0;#Averages the bottom 1  / (WF_A) Worst fit numbers. 0 is off
use constant RESOLUTION => 10; #set the resolution of the program here. 100 is the maximum from the obj files
use constant CURVATURE_BAIS => 1;#Sets the strength (exponent) of histogram height weighting
use constant REMOVE_NEG => 0;#Removes negative numbers from the worst fits WORSTRUN_WEIGHTING should be neg if set
use constant WORSTRUN_WEIGHTING => 0.5;#Sets the weight of the worst run calculated to confidence
```
Note: If RESOLUTION is changed, the first steps will need to be repeated to reflect changes in the files created previously before the last step. ie. `@parts = (1,1,1,0)`.

# Issues
I have not tested these scripts on other machines or 3D sources. I anticipate that one may have resolution issues if the prototype and partial 3 dimensional part comes from different sources. The 3Dcompare.pl has multiple switches to deal with this, however some drastically increase run-time (several hours!).  

# License
This code is free to use for non-commercial use. Please fork, if you plan to make changes. 
