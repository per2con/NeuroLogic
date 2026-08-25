%% DICE ANALYSIS
T = readtable('dice_raw.csv');

% Dice
dice_log = (2 * T.V_int) ./ (T.V_logic + T.V_form);
dice_log(T.V_logic + T.V_form == 0) = NaN;

% Hypergeometric p-values
p_log = ones(height(T), 1);
for i = 1:height(T)
    if T.V_total(i) > 0 && T.V_logic(i) > 0 && T.V_form(i) > 0 && T.V_int(i) > 0
        p_log(i) = hygecdf(T.V_int(i)-1, T.V_total(i), T.V_logic(i), T.V_form(i), 'upper');
    end
end
p_log(p_log < 1e-16) = 1e-16;

% Stouffer
[pS_log, Z_log, z_log] = stouffer_combine_pvalues(p_log)

% Descriptives
mean_dice = mean(dice_log, 'omitnan')
sem_dice  = std(dice_log, 'omitnan') / sqrt(sum(~isnan(dice_log)))
sum(p_log < 0.01)

function [p_global, Z_global, zvals] = stouffer_combine_pvalues(pvals)

    pvals = pvals(~isnan(pvals));

    if isempty(pvals)
        p_global = NaN;
        Z_global = NaN;
        zvals    = NaN;
        return
    end

    pvals(pvals < 1e-16) = 1e-16;
    pvals(pvals >= 1)    = 1 - eps;

    % One-sided z-scores: small p -> large positive z
    zvals = -norminv(pvals);

    % Stouffer unweighted
    Z_global = sum(zvals) / sqrt(numel(zvals));

    % One-sided global p-value (numerically stable upper tail)
    p_global = normcdf(Z_global, 'upper');
end
