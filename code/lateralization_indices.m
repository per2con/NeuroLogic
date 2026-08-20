%% LATERALIZATION INDICES ANALYSIS

clear; clc

dataFile = 'lateralization_indices.csv';
alpha = 0.05;

data = readtable(dataFile);

data.condition = categorical(data.condition);
conds = categories(data.condition);
pairs = {'logic','gk'; 'logic','calculation'; 'calculation','gk'};

% Group stats
group_stats = grpstats(data, {'condition'}, {'mean','sem'}, 'DataVars', 'LI_wm');
disp(group_stats)

%% Subject-aligned matrix (rows = subjects, NaN where missing)
W  = unstack(data(:,{'subject_id','condition','LI_wm'}), 'LI_wm', 'condition');
LI = W{:, conds};
Z  = atanh(LI);
pick = @(c) Z(:, strcmp(conds, c));
 
data_logic = pick('logic');
data_gk = pick('gk');
data_calculation = pick('calculation');
 
%% T-test vs 0 (i.e., bilaterality)

for i = 1:numel(conds)
    [~,p,~,st] = ttest(Z(:,i), 0, alpha);
    fprintf('%s vs 0, t(%d) =%5.2f, p = %.4f\n', conds{i}, st.df, st.tstat, p);
    fprintf('\n')
end
 
%% Paired t-tests

for k = 1:size(pairs,1)
    a = pick(pairs{k,1});
    b = pick(pairs{k,2});
    [~,p,~,st] = ttest(a, b, 'Alpha', alpha);
    fprintf('%s vs %s, t(%d) =%5.2f, p = %.4f\n', pairs{k,:}, st.df, st.tstat, p);
    fprintf('\n')
end

