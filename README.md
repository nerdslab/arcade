ArCaDe
---------
**Approximating Cellular Densities**

`version 0.1` - this repository was last updated on 09/10/2018


Related Publication
---------

You can find further details about how we apply the methods in this repo to quantify neocortical layers of mouse brains in the following papers. If you use any part of the code or data in this repo, please cite the first paper. Please direct any questions to Theodore J. LaGrow at tlagrow(at)gatech(dot)edu or Eva Dyer at evadyer{at}gatech{dot}edu.

* T.J. LaGrow, M. Moore, J.A. Prasad, A. Webber, M.A. Davenport, E.L. Dyer, "Cytoarchitecture and Layer Estimation in High-Resolution Neuroanatomical Images," in review, July 2018.

* T. J. LaGrow, M. G. Moore, J. A. Prasad, M. A. Davenport, and E. L. Dyer, “Approximating cellular densities from high-resolution neuroanatomical imaging data,” IEEE Engineering in Medicine and Biology Society Annual Conference (EMBC), July 2018. [[Paper]](http://mdav.ece.gatech.edu/publications/lmpdd-embc-2018.pdf)


Description
---------
Matlab package _____

Requirements
---------
* Matlab version >= 2007

Installation
---------

In order to download ArCaDe folder, either download `zip file` from the git repository directly or use `git` to clone the
repository using the command:

`git clone https://github.com/nerdslab/arcade`

Usage
---------
You can run NERDS algorithm by using the function `compute_nerds` in main folder

```go
[gen_atom_out, spike_idx, x_hat_out, e_hat_out] = compute_nerds(y, opts)
```

The input has two arguments:
* `y` is 1-D calcium signal (either row or column format)
* `opts` is a matlab structure containing parameters described in MATLAB code (if it isn't specified, we will assign default parameters)
  * `opts.numTrials` - number of iteration, default `numTrials = 10`
  * `opts.L` - length of template that we want to estimate, default `ask user`
  * `opts.thresh` - thresholding parameter, default `thresh = 0.1` i.e. we threshold spikes whose amplitude less than 10 % of the maximum coefficient amplitude
  * `opts.wsize` - window size where we apply summation of spikes (`peak_sum`) in order to remove small group of low magnitude splikes output from algorithm
  * `opts.verbose` - verbose parameter for SPGL1, default `verbose = false`

The output has four arguments:
* `gen_atom_out` is estimated template where each column contains estimated template of each iteration
* `spike_idx` is cell that contain index that spikes occur
* `x_hat_out` is matrix where each column contains estimated spikes train produced in each iteration (we'll fix amplitude problem soon)
* `e_hat_out` is matrix contains DCT coefficient which can transform back to base-line drift in calcium signal

`opts.L` is estimated length of template (called `gen_atom`) where you can estimate the length by the following figure:

img...


Example Code
------------

See the `example_synth.m` file for an example from the paper on synthetic data. 
See the `example_nerds.m` file for an example where we apply NERDS algorithm to real calcium data.

Team members
----------
* [Theodore J. LaGrow](http://www.bioengineering.gatech.edu/people/theodore-lagrow)
* [Michael G. Moore](https://www.linkedin.com/in/michael-moore-87371725/)
* [Alexis Webber)[https://www.linkedin.com/in/alexis-webber-gatechbme/]
* [Judy A. Prasad](https://neurobiology.uchicago.edu/page/judy-prasad)
* [Mark A. Davenport](http://mdav.ece.gatech.edu/index.html)
* [Eva L. Dyer](http://dyerlab.gatech.edu/)

Acknowledgement
----------



License
-----------
* The MIT License (MIT)
Copyright (c) 2018 Theodore J. LaGrow, Michael G. Moore, Judy A. Prasad, Mark A. Davenport, and Eva L. Dyer
