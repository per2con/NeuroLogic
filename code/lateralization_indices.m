%% LATERALIZATION INDICES ANALYSIS

clear; clc

dataFile = 'lateralization_indices.csv';
alpha = 0.05;

data = readtable(dataFile);

data.condition = categorical(data.condition);
conds = categories(data.condition);

% Group stats
group_stats = grpstats(data, {'condition'}, {'mean','sem'}, 'DataVars', 'LI_wm');
disp(group_stats)

% Subject-aligned matrix (rows = subjects, NaN where missing)
% since one subject did not do the localizer

W  = unstack(data(:,{'subject_id','condition','LI_wm'}), 'LI_wm', 'condition');
LI = W{:, conds};
Z  = atanh(LI);
pick = @(c) Z(:, strcmp(conds, c));
 
data_logic = pick('logic');
data_gk = pick('gk');
data_calculation = pick('calculation');
 

% T-test vs 0 (i.e., bilaterality)
stats_bil = table();
for i = 1:numel(conds)
    stats_bil(i,:) = oneSampleT(conds{i}, Z(:,i), 0);
end
disp(stats_bil)

% Paired t-tests
[h,p,ci,st] = ttest(data_gk, data_logic, 'Alpha', alpha);
fprintf('gk vs logic, t(%d) =%5.2f, p = %.4f\n', st.df, st.tstat, p);
fprintf('\n')

%%
function row = oneSampleT(label, x, mu)
[h, p, ci, stats] = ttest(x, mu);
row = table(string(sprintf('%s_vs_bilateral', label)), h, stats.tstat, stats.df, p, ci(:)', ...
           'VariableNames', {'Test', 'Reject', 't', 'df', 'p', 'ci'});
end