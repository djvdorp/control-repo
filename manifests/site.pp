# Include all classes from (hiera)data and put them in a merged, flattened array with all duplicate values removed.
include(lookup('classes', { 'merge' => 'unique' }))
