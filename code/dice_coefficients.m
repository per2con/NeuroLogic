%% DICE COEFFICIENTS ANALYSIS

clear; clc

dataFile = 'dice_coefficients.csv';
alpha = 0.05;

data = readtable(dataFile);

data.hemisphere = categorical(data.hemisphere);
data.maps = categorical(data.maps);

% Group stats
group_stats = grpstats(data, {'maps','hemisphere'}, ...
                       {'mean','sem'}, 'DataVars', 'dice');

% Statistical analyses

pick = @(m,h) data.dice(data.maps == m & data.hemisphere == h);
logit = @(d) fixInf(log(d./(1-d)));

X = [logit(pick("logic_calculation","LH")),... 
     logit(pick("logic_calculation","RH")), ...
     logit(pick("logic_calculation","bilateral")),...
     logit(pick("logic_language","bilateral")), ...
     logit(pick("gk_language","bilateral"))];

[h1,p1,ci1,s1] = ttest(X(:,4), X(:,5), alpha);
[h2,p2,ci2,s2] = ttest(X(:,1), X(:,2), alpha);

fprintf('logic_lang vs gk_lang: t(%d) = %.3f  p = %.4f\n', s1.df, s1.tstat, p1);
fprintf('\n')
fprintf('logic_calc LH vs RH: t(%d) = %.3f  p = %.4f\n', s2.df, s2.tstat, p2);

function a = fixInf(a)
a(a == -Inf) = -0.001;
a(a ==  Inf) =  1;
end
