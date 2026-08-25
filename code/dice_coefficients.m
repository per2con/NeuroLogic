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

X = [SVsqueeze(pick("logic_calculation","LH")),... 
     SVsqueeze(pick("logic_calculation","RH")), ...
     SVsqueeze(pick("logic_calculation","bilateral")),...
     SVsqueeze(pick("logic_language","bilateral")), ...
     SVsqueeze(pick("gk_language","bilateral"))];

disp(group_stats);

[h1,p1,ci1,s1] = ttest(X(:,4), X(:,5), alpha);
[h2,p2,ci2,s2] = ttest(X(:,1), X(:,2), alpha);

fprintf('logic_lang vs gk_lang: t(%d) = %.3f  p = %.4f\n', s1.df, s1.tstat, p1);
fprintf('\n')
fprintf('logic_calc LH vs RH: t(%d) = %.3f  p = %.4f\n', s2.df, s2.tstat, p2);

% Smithson–verkuilen transformation to avoid +/-Inf
function y = SVsqueeze(d)
    n = numel(d);
    s = (d .* (n - 1) + 0.5) ./ n;
    y = log(s ./ (1 - s));
end