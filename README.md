ArCaDe
---------
**Approximating Cellular Densities**

`version 0.1` - this repository was last updated on 09/16/2018


Related Publication
---------

You can find further details about how we apply the methods in this repo to quantify neocortical layers of mouse brains in the following papers. If you use any part of the code or data in this repo, please cite the first paper. Please direct any questions to Theodore J. LaGrow at tlagrow(at)gatech(dot)edu or Eva Dyer at evadyer{at}gatech{dot}edu.

* T.J. LaGrow, M. Moore, J.A. Prasad, A. Webber, M.A. Davenport, E.L. Dyer, "Cytoarchitecture and Layer Estimation in High-Resolution Neuroanatomical Images," in review, July 2018.

* T. J. LaGrow, M. G. Moore, J. A. Prasad, M. A. Davenport, and E. L. Dyer, “Approximating cellular densities from high-resolution neuroanatomical imaging data,” IEEE Engineering in Medicine and Biology Society Annual Conference (EMBC), July 2018. [[Paper]](http://mdav.ece.gatech.edu/publications/lmpdd-embc-2018.pdf)


Description
---------
This repository is designed to hold demonstration code for the ArCaDe pipeline.  The three main folders (patch_extraction/, cell_detection/, and rate_estimation/) hold the scripts needed to perform each step. Figures produced by the demo scripts are located in their respected folders.

The data utilized in this repo can be found at: https://drive.google.com/drive/folders/1p6NiX26l39gscg6nYFltlT1fZ7nwZqpG?usp=sharing.  The data needs to be included into the path of your working envirnment. 

Requirements
---------
* Matlab version >= 2007

Installation
---------

In order to download ArCaDe folder, either download `zip file` from the git repository directly or use `git` to clone the
repository using the command:

`git clone https://github.com/nerdslab/arcade`


Example Code
------------

You can run any demo of the three steps in the ArCaDe pipeline independently each in their designated folders with the following scripts: `script_patch_extraction.m`, `script_cell_detection.m`, and `script_rate_estimation.m`.

Team members
----------
* [Theodore J. LaGrow](http://www.bioengineering.gatech.edu/people/theodore-lagrow)
* [Michael G. Moore](https://www.linkedin.com/in/michael-moore-87371725/)
* [Alexis Webber](https://www.linkedin.com/in/alexis-webber-gatechbme/)
* [Judy A. Prasad](https://neurobiology.uchicago.edu/page/judy-prasad)
* [Mark A. Davenport](http://mdav.ece.gatech.edu/index.html)
* [Eva L. Dyer](http://dyerlab.gatech.edu/)



License
-----------
* The MIT License (MIT)
Copyright (c) 2018 Theodore J. LaGrow, Michael G. Moore, Judy A. Prasad, Mark A. Davenport, and Eva L. Dyer
