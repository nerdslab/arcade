ArCaDe
---------
**Approximating Cellular Densities**

`version 0.1` - this is first repository of ArCaDe (published on MMMM DD, YYYY)


Related Publication
---------
* T. J. LaGrow, M. G. Moore, J. A. Prasad, M. A. Davenport, and E. L. Dyer, “Approximating cellular densities from high-resolution neuroanatomical imaging data,” to appear in Proc. IEEE Int. Engineering in Medicine and Biology Conf. (EMBC), Honolulu, Hawaii, July 2018 [[Paper]](http://mdav.ece.gatech.edu/publications/lmpdd-embc-2018.pdf)

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

For synthetic example, the code will produce the graphs below. Note that after computing the sparse coefficients, we post-process the coefficients by thresholding the spike train and combining peaks that are close together.

### Baseline drift and reconstructed spikes for synthetic data
img....

### Estimated spikes for synthetic data
img...


### Result of NERDS applied to real data
img...


Team members
----------
* Theodore J. LaGrow
* Michael G. Moore
* [Judy A. Prasad](https://neurobiology.uchicago.edu/page/judy-prasad)
* [Mark A. Davenport](http://mdav.ece.gatech.edu/index.html)
* [Eva L. Dyer](http://dyerlab.gatech.edu/)

Acknowledgement
----------
* The calcium and electrophysiology data included in `example_real_data.mat` was collected in [Jason MacLean's Lab](http://www.macleanlab.com) at the University of Chicago. Check out the following two papers: [Runfeldt  et. al.](http://jn.physiology.org/content/early/2014/05/23/jn.00071.2014) and [Sadovsky AJ et. al.](http://www.ncbi.nlm.nih.gov/pubmed/21715667) for more details regarding the experimental methods utilized to acquire these simultaneous recordings. 

License
-----------
* The MIT License (MIT)
Copyright (c) 2018 Theodore J. LaGrow, Michael G. Moore, Judy A. Prasad, Mark A. Davenport, and Eva L. Dyer
