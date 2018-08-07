NERDS
---------
**Neural Event Reconstruction and Detection via Sparsity**

`version 0.1` - this is first repository of NERDS (published on Nov 13, 2014)


Related Publication
---------
* Dyer, E.L.; Studer, C.; Robinson, J.T.; Baraniuk, R.G., "A robust and efficient method to recover neural events from noisy and corrupted data," Neural Engineering (NER), 6th International IEEE/EMBS Conference, pp.593-596, 2013 [[Paper]](http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=6696004)

Description
---------
Matlab package implementing blind deconvolution method for neural spike recovery from either calcium traces or intracellular recordings of post-synaptic potentials.

Requirements
---------
* Matlab version >= 2007
* [SPGL1](https://www.math.ucdavis.edu/~mpf/spgl1/) (Solver for large-scale sparse reconstruction) see also at git [link](https://github.com/mpf/spgl1) (note that we did not include `SPGL1` in NERDS project) so make sure that you install `SPGL1` and include in MATLAB path.

Installation
---------

In order to download NERDS folder, either download `zip file` from the git repository directly or use `git` to clone the
repository using the command:
`git clone https://github.com/nerdslab/nerds`

You also need to install `SPGL1`, run `spgsetup.m`, and then add to MATLAB path. After that, hover to the folder and run `setup_nerds.m` code.

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

<img align="center" src="https://github.com/nerdslab/nerds/blob/master/nerds_figures/nerd_example.png" width="500px"/>

Example Code
------------

See the `example_synth.m` file for an example from the paper on synthetic data. 
See the `example_nerds.m` file for an example where we apply NERDS algorithm to real calcium data.

For synthetic example, the code will produce the graphs below. Note that after computing the sparse coefficients, we post-process the coefficients by thresholding the spike train and combining peaks that are close together.

### Baseline drift and reconstructed spikes for synthetic data
<img align="center" src="https://github.com/nerdslab/nerds/blob/master/nerds_figures/nerd_synth_result1.png" width="500px"/>

### Estimated spikes for synthetic data
<img align="center" src="https://github.com/nerdslab/nerds/blob/master/nerds_figures/nerd_synth_result2.png" width="500px"/>

### Result of NERDS applied to real data
<img align="center" src="https://github.com/nerdslab/nerds/blob/master/nerds_figures/nerds_realdata.png" width="500px"/>

Team members
----------
* [Eva Dyer](http://dyerlab.gatech.edu/)
* [Christoph Studer](http://www.csl.cornell.edu/~studer/)

Acknowledgement
----------
* The calcium and electrophysiology data included in `example_real_data.mat` was collected in [Jason MacLean's Lab](http://www.macleanlab.com) at the University of Chicago. Check out the following two papers: [Runfeldt  et. al.](http://jn.physiology.org/content/early/2014/05/23/jn.00071.2014) and [Sadovsky AJ et. al.](http://www.ncbi.nlm.nih.gov/pubmed/21715667) for more details regarding the experimental methods utilized to acquire these simultaneous recordings. 

License
-----------
* The MIT License (MIT)
Copyright (c) 2014 Eva Dyer and Christoph Studer
