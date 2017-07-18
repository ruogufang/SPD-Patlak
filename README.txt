README for Sparse High-dose Induced Patlak (shd-Patlak) Package

Ruogu Fang
Advanced Multimedia Laboratory
Department of Electrical and Computer Engineering
Cornell University
July 12, 2014


Sparse High-dose Induced Patlak (shd-Patlak) package uses a sparse representation and maximum a posterior optimization to robustly estimate the blood-brain-barrier permeability in low-dose CT perfusion, as described in the following paper. We provide a MATLAB implementation of the Patlak model in the pct package included in the Utilities folder.

CITATION:
--------------
Please cite the following papers if you use code in this SPD package.

Ruogu Fang, Kolbeinn Karlsson, Tsuhan Chen, Pina C. Sanelli. Improving Low-Dose Blood-Brain Barrier Permeability Quantification Using Sparse High-Dose Induced Prior for Patlak Model. Medical Image Analysis, Volume 18, Issue 6, Pages 866-880, 2014.


BIBTEX:
-----------------
@incollection{fang2012dictionary
@article{fang2014improving,
  title={Improving low-dose blood--brain barrier permeability quantification using sparse high-dose induced prior for Patlak model},
  author={Fang, Ruogu and Karlsson, Kolbeinn and Chen, Tsuhan and Sanelli, Pina C},
  journal={Medical image analysis},
  volume={18},
  number={6},
  pages={866--880},
  year={2014},
  publisher={Elsevier}
}


FILES ORGANIZATION:
----------------------------------
Code:

Main_shdPatlak.m: main file to run the demo. It tests two algorithms: Patlak model and shd-Patlalk model.
bplasso_map: Maximum A Posterior algorithm calls bplasso_map_prior and bplasso_map_sd.
bplasso_map_prior: Estimate the prior image using the learned dictionary using omp solver.
bplasso_map_sd: Estimate the low-dose perfusion map image using steepest descent based on the prior image and temporal convolution model.
Exp_profile: Experiment code for showing the two vertical profiles of a BBBP map.
Exp_Zoomed: Experiment code for showing the zoomed-in regions of the BBBP map.
Exp_3ROI: Experiment code for showing the whole BBBP map with 3 ROIs and compute the corresponding metric values.
Exp_Corr_P15: Experiment code to show and compute the correlation between high-dose and low-dose BBBP maps using Patlak or shd-Patlak models.
Exp_ImageandROI: Experiment code for showing the BBBP map with ROI.

DATA: (in the Data folder, .mat files)

IRB_015: A subject's CTP data of spatial-temporal reconstructed CT images
P15_15mA: BBBP maps of high-dose (190 mA), low-dose using Patlak model and low-dose using shd-Patlak model (15mA).
BBBP_001, BBBP_002: Training CTP data for dictionary learning.
20ROI_15: 20 ROI locations with x and y position for subject 15


INSTALLATION: 
--------------------------
1.  Unzip the package. 
2.  Compile Utility packages. The binaries for Mac OS 10.9 is already included in the package. For different platforms, 
   a. Go to ompbox10 folder, follow the readme.txt file to make files in MATLAB.
   b. Go to spams-matlab folder and compile following the instructions in HOW_TO_INSTALL.txt. 
   * Note that for newer version of Mac OS (10.7+) or gcc (XCode), issues may arise when running compile.m. Please follow the notes at the end of this README file for possible solutions.
3. Run Main_shdPatlak.m for the demo.
4. You may change the noise level and other parameters at the beginning of Main_shdPatlak.m file. You may also use your own simulated or real low-dose image by loading different DICOM or MAT files as Vn (the low-dose CTP data [T x X x Y]). 


TOOLBOX INCLUDED:
-------------------------------
This package already includes the utility software packages downloaded from other website. Please properly cite the related papers if you use these packages.
a. metrix-mux    http://foulard.ece.cornell.edu/gaubatz/metrix_mux/
b. ompbox10    http://www.cs.technion.ac.il/~ronrubin/software.html
c. spams-matlab v2.3  http://spams-devel.gforge.inria.fr



=========================================================================================================
NOTES for Issues at Compilation of SPAMS-MATLAB package. 
-------------------
1. Issue may occur when compiling spams_matlab package.
When compile.m is run, the error occurs:
/Applications/MATLAB_R2013a.app/extern/include/tmwtypes.h:819:9: error: unknown
      type name 'char16_t'
typedef char16_t CHAR16_T;

Reason: The problem is due to the update of OS system and gcc (or XCode), which changes the version number and system parameters, but MATLAB does not know it.

Solution:  In /Applications/MATLAB_R2013a.app/bin/mexopts.sh
On Line 150: Add -std=c++11 to CXXFLAGS in your current mexopts.sh. 
Re-run mex -setup to have MATLAB reconfigure it for you and it works.

When it is not possible to use C++11 via CXXFLAGS, either due to compiler limitation or because the file must be C only, the possible workarounds:
Add before #include "mex.h" in .c file:
#include <stdint.h>
#define char16_t UINT16_T


2. Issue: mex: link of ' "./build//mexTrainDL.mexmaci64"' failed.

Solution: Change the use_multithread to false in compile.m file


Please contact rf294@cornell.edu or ruogu.fang@gmail.com if you have issues or suggestions for this shd-Patlak model package.
