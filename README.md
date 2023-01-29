# BNLRD
This package contains our implementation for:
"Fabric Defect Detection based on Bayesian  Non-negative Low-rank Decomposition"
===========================================================================
*** The code is run on MATLAB R2014a-2018a on Windows 11 64 bit.

Usage:
>> run 'main_BNLRD_demo.m'
>> the output saliency maps and results are stored in the file '\results'
>> the evaluation results are stored in the file '\figure'


Notice:
The codes have not been optimized, and only used for demo. 
Parts of the codes are encrypted. Full codes will be released later.

If SLICEdemo.m for superpixels is not working, please try to re-compile the codes of SLICE_mex as,
>> cd ./utilities/SLIC_mex
mex slicomex.c  slicmex.c  slicsupervoxelmex.c

===========================================================================
Reference:
[1] Peng H, Li B, Ling H, et al. Salient object detection via structured matrix decomposition[J]. IEEE TPAMI, 2016, 39(4): 818-832.
[2] Radhakrishna Achanta, Appu Shaji, Kevin Smith, Aurelien Lucchi, Pascal Fua, and Sabine Süsstrunk, SLIC Superpixels Compared to State-of-the-art Superpixel Methods, IEEE TPAMI, vol. 34, num. 11, p. 2274 - 2282, May 2012.

          
