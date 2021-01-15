function launchtests
% Entry point for running tests etc in CI

rootdir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(rootdir, 'Mcode'))

mailspoon.test.run_all_tests
