%% PARAMETER ESTIMATES ANALYSIS

clear; clc

dataFile = 'logicians_betas_logic_main_task';
%dataFile = 'logicians_betas_gk_main_task';

switch dataFile
    case 'logicians_betas_logic_main_task'
        label = 'Logic';

    case 'logicians_betas_gk_main_task'
        label = 'NonLogic';

    otherwise
        error('Invalid data file')
end

data = readtable(dataFile);

data.group = categorical(data.group);
data.roi = categorical(data.roi);

data.stimType = categorical(data.category_id, 1:6, ...
    {'Logic','Logic','Logic','NonLogic','NonLogic','NonLogic'});

data.truthVal = categorical(data.category_id, 1:6, ...
    {'True','False','Meaningless','True','False','Meaningless'});

% Group stats for plotting
group_stats = grpstats(data, {'group','stimType','truthVal','roi'}, ...
                       {'mean','sem'}, 'DataVars', 'parameter_estimate');