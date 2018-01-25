# postpan
Post-processing code for an experiment run in the Panoptes HT microscope.

The sole purpose of this project is to take a dataset-path outputted from PanopticNerve and convert its contents into a single file accessible by python or MATLAB. See 3dfmAnalysis and pypan projects for data analysis.

This single file should include:
- instrument metadata
- experiment metadata
- tracking metadata (tracking conditions, original tracking filenames/paths)
- video metadata (fid, path, filename, hostname, width, height, xloc, yloc, fps, umperpixel)
- first frame of each video
- the intensity projection(s) of each video (max, min, and/or mean)

The format of the output file has not yet been decided, but it could be hdf5, json, mat, sqlite, but cannot be straight-text.
