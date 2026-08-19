%% BEHAVIOURAL ANALYSIS: Logicians vs Controls, Logic vs Non-Logic Conditions
% Accuracy (3-way forced choice) and d-prime (meaningful vs meaningless)

clear; clc

%% --- Configuration ---

dataFile = 'behavioural_data.csv';
chanceLevel = 33.3; % chance performance (%) for 3-way forced choice
alpha = 0.05;

% Response codes:
% 1 = sentence judged as true
% 2 = sentence judged as false
% 3 = sentence judged as meaningless

endorseResp = [1 2]; % responses counted as "meaningful" endorsement
noResponse = [0 -3]; % responses excluded from trial totals

%% --- Load & label data ---

% Conditions codes:
% [1:4] = meaningful logic
% [5:6] = meaningless logic
% [7:10] = meaningful general knowledge
% [11:12] = meaningless general knowledge

data = readtable(dataFile);
data.group = categorical(data.group);

blockPos = mod(data.category_id - 1, 6) + 1;
data.stimType = categorical(data.category_id <= 6, [true false], {'Logic', 'NonLogic'});
data.trialType = categorical(blockPos <= 4, [true false], {'meaningful', 'meaningless'});

data.isEndorsed = double(ismember(data.response, endorseResp));
data.isValid = double(~ismember(data.response, noResponse));

nLogicians = numel(unique(data.subject_id(data.group == 'logicians')));
nControls = numel(unique(data.subject_id(data.group == 'controls')));


%% ===== ACCURACY ANALYSIS ======

subjAcc = grpstats(data, {'subject_id', 'group', 'stimType'}, 'mean', 'DataVars', 'accuracy');
subjAcc.accuracy = subjAcc.mean_accuracy * 100;

accWide = unstack(subjAcc(:, {'subject_id', 'group', 'stimType', 'accuracy'}), 'accuracy', 'stimType');

acc_logic_logicians = accWide.Logic(accWide.group == 'logicians')';
acc_gk_logicians = accWide.NonLogic(accWide.group == 'logicians')';
acc_logic_controls = accWide.Logic(accWide.group == 'controls')';
acc_gk_controls = accWide.NonLogic(accWide.group == 'controls')';

accSummary = grpstats(subjAcc(:, {'stimType', 'group', 'accuracy'}), {'stimType', 'group'}, {'mean', 'sem'});
disp(accSummary)

% Stats:
% One-sample t-test against chanche (i.e., 33%)
% Paired-sample t-test
% Mixed ANOVA
% Post-hoc two-samples t-test

accStats = [oneSampleT('Logicians, Logic vs chance', acc_logic_logicians, chanceLevel, 'right'); ...
               oneSampleT('Logicians, Non-Logic vs chance', acc_gk_logicians, chanceLevel, 'right'); ...
               oneSampleT('Controls, Logic vs chance', acc_logic_controls, chanceLevel, 'right'); ...
               oneSampleT('Controls, Non-Logic vs chance', acc_gk_controls, chanceLevel, 'right'); ...
       
               pairedT('Logicians, Logic vs Non-Logic', acc_logic_logicians, acc_gk_logicians); ...
               pairedT('Controls, Logic vs Non-Logic', acc_logic_controls, acc_gk_controls)];

runMixedAnova(acc_logic_logicians, acc_gk_logicians, acc_logic_controls, ...
              acc_gk_controls, nLogicians, nControls);

accStats = [accStats;...
            twoSampleT('Logic, Logicians vs Controls', acc_logic_logicians, acc_logic_controls); ...
            twoSampleT('Non-Logic, Logicians vs Controls', acc_gk_logicians, acc_gk_controls)];

disp(accStats)

%% ==== D-PRIME =====

% Hits = response is [1,2] to either true or false statements
% False alarms = response is [1,2] to meaningless statements

rates = grpstats(data, {'subject_id', 'group', 'stimType', 'trialType'}, 'sum', {'isEndorsed', 'isValid'});
rates.rate = rates.sum_isEndorsed ./ rates.sum_isValid;

isZero = rates.rate == 0;
isOne = rates.rate == 1;

% Vectorized log-linear-style correction for rates of
% exactly 0 or 1 (which would otherwise give +/-Inf under norminv)

rates.rate(isZero) = 0.5 ./ rates.sum_isValid(isZero);
rates.rate(isOne) = 1 - 0.5 ./ rates.sum_isValid(isOne);

rateWide = unstack(rates(:, {'subject_id', 'group', 'stimType', 'trialType', 'rate'}), 'rate', 'trialType');
rateWide.dprime = norminv(rateWide.meaningful) - norminv(rateWide.meaningless);

dprimeWide = unstack(rateWide(:, {'subject_id', 'group', 'stimType', 'dprime'}), 'dprime', 'stimType');

dprime_logic_logicians = dprimeWide.Logic(dprimeWide.group == 'logicians')';
dprime_gk_logicians = dprimeWide.NonLogic(dprimeWide.group == 'logicians')';
dprime_logic_controls = dprimeWide.Logic(dprimeWide.group == 'controls')';
dprime_gk_controls = dprimeWide.NonLogic(dprimeWide.group == 'controls')';

dprimeSummary = grpstats(rateWide(:, {'stimType', 'group', 'dprime'}), {'stimType', 'group'}, {'mean', 'sem'});
disp(dprimeSummary)

% Stats:
% One-sample t-test against chanche (i.e., 0 -> HIT rate == FA rate)
% Paired-sample t-test
% Mixed ANOVA
% Post-hoc two-samples t-test

dprimeStats = [oneSampleT('Logicians, Logic vs chance', dprime_logic_logicians, 0, 'right'); ...
               oneSampleT('Logicians, Non-Logic vs chance', dprime_gk_logicians, 0, 'right'); ...
               oneSampleT('Controls, Logic vs chance', dprime_logic_controls, 0, 'right'); ...
               oneSampleT('Controls, Non-Logic vs chance', dprime_gk_controls, 0, 'right'); ...

               pairedT('Logicians, Logic vs Non-Logic', dprime_logic_logicians, dprime_gk_logicians); ...
               pairedT('Controls, Logic vs Non-Logic', dprime_logic_controls, dprime_gk_controls)];

runMixedAnova(dprime_logic_logicians, dprime_gk_logicians, dprime_logic_controls, ...
              dprime_gk_controls, nLogicians, nControls);

dprimeStats = [dprimeStats;...
               twoSampleT('Logic, Logicians vs Controls', dprime_logic_logicians, dprime_logic_controls); ...
               twoSampleT('Non-Logic, Logicians vs Controls', dprime_gk_logicians, dprime_gk_controls)];

disp(dprimeStats)



%% === FUNCTIONS: t-TESTS, REPORTED AS TABLE ROWS ===
% Each helper returns a one-row table with a consistent {Test, t, df, p,
% Estimate} layout so results can be stacked into a single readable table.

function row = oneSampleT(label, x, mu, tail)
[~, p, ~, stats] = ttest(x, mu, 'Tail', tail);
row = table(string(label), stats.tstat, stats.df, p, mean(x), ...
           'VariableNames', {'Test', 't', 'df', 'p', 'Estimate'});
end

function row = pairedT(label, x, y)
[~, p, ~, stats] = ttest(x, y);
row = table(string(label), stats.tstat, stats.df, p, mean(x - y), ...
            'VariableNames', {'Test', 't', 'df', 'p', 'Estimate'});
end

function row = twoSampleT(label, x, y)
[~, p, ~, stats] = ttest2(x, y);
row = table(string(label), stats.tstat, stats.df, p, mean(x) - mean(y), ...
            'VariableNames', {'Test', 't', 'df', 'p', 'Estimate'});
end

%% === FUNCTION: MIXED ANOVA (group x condition, subjects nested) ===

function runMixedAnova(condA_group1, condB_group1, condA_group2, condB_group2, nGroup1, nGroup2)

y = [condA_group1(:); condB_group1(:); condA_group2(:); condB_group2(:)];

withinCondition = [ones(nGroup1,1); 2*ones(nGroup1,1); ones(nGroup2,1); 2*ones(nGroup2,1)];
betweenGroup = [ones(2*nGroup1,1); 2*ones(2*nGroup2,1)];
subjects = [1:nGroup1, 1:nGroup1, (1:nGroup2)+nGroup1, (1:nGroup2)+nGroup1]';

anovan(y, {betweenGroup, withinCondition, subjects}, ...
       'model', 'full', ...
       'random', 3, ...
       'nested', [0 0 0; 0 0 0; 1 0 0], ...
       'varnames', {'group', 'condition', 'subjects'}, ...
       'display', 'on');
end