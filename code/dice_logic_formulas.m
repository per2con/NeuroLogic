%% DICE ANALYSIS

clc
clear

%% =========================================================
% READ DATA
%% =========================================================

T = readtable('dice_raw.csv');

%% =========================================================
% DICE COEFFICIENT
%% =========================================================

dice_log = (2 * T.V_int) ./ (T.V_logic + T.V_form);

% Undefined Dice if both maps contain zero voxels
dice_log(T.V_logic + T.V_form == 0) = NaN;

%% =========================================================
% HYPERGEOMETRIC P-VALUES
%% =========================================================

p_log = nan(height(T), 1);

for i = 1:height(T)

    % Same logic as the other script:
    % the hypergeometric test is valid whenever
    % V_total, V_logic, and V_form are > 0.
    % V_int can also be zero.

    if T.V_total(i) > 0 && ...
       T.V_logic(i) > 0 && ...
       T.V_form(i) > 0

        p_log(i) = hygecdf( ...
            T.V_int(i) - 1, ...
            T.V_total(i), ...
            T.V_logic(i), ...
            T.V_form(i), ...
            'upper');

    else
        % Test not valid
        p_log(i) = NaN;
    end

end

% Lower bound for numerical stability
p_log(p_log < 1e-16) = 1e-16;

%% =========================================================
% STOUFFER COMBINATION TEST
%% =========================================================

[pS_log, Z_log, z_log] = stouffer_combine_pvalues(p_log);

%% =========================================================
% DESCRIPTIVES
%% =========================================================

% Number of subjects
n_total = height(T);

% Valid Dice values
n_valid_dice = sum(~isnan(dice_log));

% Dice statistics
mean_dice   = mean(dice_log, 'omitnan');
sd_dice     = std(dice_log, 'omitnan');
median_dice = median(dice_log, 'omitnan');
sem_dice    = sd_dice / sqrt(n_valid_dice);

% Hypergeometric statistics
n_hypergeom = sum(~isnan(p_log));

mean_p_hypergeom   = mean(p_log, 'omitnan');
median_p_hypergeom = median(p_log, 'omitnan');

n_sig_005 = sum(p_log < 0.05);
n_sig_001 = sum(p_log < 0.01);

prop_sig_005 = n_sig_005 / n_hypergeom;
prop_sig_001 = n_sig_001 / n_hypergeom;

%% =========================================================
% SUMMARY TABLE
%% =========================================================

Summary = table( ...
    n_total, ...
    mean_dice, ...
    sem_dice, ...
    median_dice, ...
    n_hypergeom, ...
    n_sig_001, ...
    prop_sig_001, ...
    Z_log, ...
    pS_log, ...
    'VariableNames', { ...
        'N', ...
        'Mean_Dice', ...
        'SEM_Dice', ...
        'Median_Dice', ...
        'N_Hypergeom', ...
        'N_p_lt_001', ...
        'Prop_p_lt_001', ...
        'Stouffer_Z', ...
        'Stouffer_p' ...
    });

disp(Summary)

%% =========================================================
% SUBJECT-WISE RESULTS TABLE
%% =========================================================

SubjectResults = table( ...
    T.V_total, ...
    T.V_logic, ...
    T.V_form, ...
    T.V_int, ...
    dice_log, ...
    p_log, ...
    'VariableNames', { ...
        'V_total', ...
        'V_logic', ...
        'V_form', ...
        'V_int', ...
        'Dice', ...
        'p_Hypergeom' ...
    });

disp(SubjectResults)

%% =========================================================
% STOUFFER DETAILS
%% =========================================================

fprintf('\n');
fprintf('============================================================\n');
fprintf('STOUFFER COMBINATION TEST\n');
fprintf('============================================================\n');

fprintf('Number of valid hypergeometric tests = %d\n', n_hypergeom);
fprintf('Z = %.6f\n', Z_log);
fprintf('p_global = %.6g\n', pS_log);

fprintf('\nP-values used for Stouffer:\n');
disp(p_log)

fprintf('Subject-wise Z values:\n');
disp(z_log)

%% =========================================================
% LOCAL FUNCTION
%% =========================================================

function [p_global, Z_global, zvals] = stouffer_combine_pvalues(pvals)

    % Remove invalid tests
    pvals = pvals(~isnan(pvals));

    if isempty(pvals)

        p_global = NaN;
        Z_global = NaN;
        zvals    = NaN;

        return

    end

    % Numerical stability
    pvals(pvals < 1e-16) = 1e-16;

    % Avoid exactly p = 1, which would give -Inf
    pvals(pvals >= 1) = 1 - eps;

    % One-sided z-scores
    % Small p -> large positive Z
    zvals = -norminv(pvals);

    % Unweighted Stouffer combination
    Z_global = sum(zvals) / sqrt(numel(zvals));

    % Global one-sided p-value
    p_global = normcdf(Z_global, 'upper');

end
