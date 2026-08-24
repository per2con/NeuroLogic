clc
clear

%% =========================================================
%  DICE COEFFICIENT + HYPERGEOMETRIC TEST
%  ONLY LOGICIANS
%  UNION ROI = LEFT ventral | RIGHT ventral
%
%  Logic mask:
%    (spmT_0019 > 3.1) AND (spmT_0015 > 1.6)
%
%  Formulas mask:
%    spmT_0008 > 3.1
%
%  ROI masks are resampled to each subject map grid
%  using nearest-neighbour interpolation (SPM masking).
%% =========================================================

%% SUBJECTS
logicians = [3 6 7 8 9 10 14 16 18 19 21];

%% PATHS
logic_root    = 'D:\Internship\Models_vs_Rest\First_Level_GLMs\Logicians\';
formulas_root = 'C:\Users\michela.terzani\Desktop\analisi paper\';

leftMask  = 'C:\Users\michela.terzani\Desktop\analisi paper\ROI\ROI per dice\LEFT ventral mask.nii';
rightMask = 'C:\Users\michela.terzani\Desktop\analisi paper\ROI\ROI per dice\RIGHT ventral mask.nii';

%% THRESHOLDS
t_thresh_mask = 1.6;
t_thresh      = 3.1;

%% INIT SPM
spm('Defaults','fMRI');

%% READ ROI HEADERS
V_left  = spm_vol(leftMask);
V_right = spm_vol(rightMask);

%% =========================================================
%  COMPUTE OVERLAP IN UNION ROI
%% =========================================================
res_log = compute_overlap_group_unionROI( ...
    logicians, logic_root, formulas_root, ...
    t_thresh_mask, t_thresh, V_left, V_right);

dice_log = res_log.dice;
p_log    = res_log.p_hyg;

% Lower bound for numerical stability
p_log(p_log < 1e-16) = 1e-16;

%% =========================================================
%  SUMMARY
%% =========================================================
fprintf('\n');
fprintf('============================================================\n');
fprintf('DICE + HYPERGEOMETRIC TEST - LOGICIANS - UNION ROI\n');
fprintf('============================================================\n');

fprintf('N subjects              = %d\n', sum(~isnan(dice_log)));
fprintf('Mean Dice               = %.6f\n', mean(dice_log, 'omitnan'));
fprintf('SD Dice                 = %.6f\n', std(dice_log, 'omitnan'));
fprintf('Median Dice             = %.6f\n', median(dice_log, 'omitnan'));

fprintf('\nDice values:\n');
fprintf('%.6f ', dice_log);
fprintf('\n');

fprintf('\nHypergeometric p-values:\n');
fprintf('%.6g ', p_log);
fprintf('\n');

fprintf('\nSubjects with p < 0.05  = %d / %d\n', sum(p_log < 0.05), numel(p_log));
fprintf('\nSubjects with p < 0.01  = %d / %d\n', sum(p_log < 0.01), numel(p_log));

N = sum(~isnan(dice_log));
mean_dice = mean(dice_log, 'omitnan');
sd_dice   = std(dice_log, 'omitnan');
sem_dice  = sd_dice / sqrt(N);

fprintf('Mean Dice               = %.6f\n', mean_dice);
fprintf('SD Dice                 = %.6f\n', sd_dice);
fprintf('SEM Dice                = %.6f\n', sem_dice);

%% =========================================================
%  STOUFFER COMBINATION TEST
%% =========================================================
[pS_log, Z_log, z_log] = stouffer_combine_pvalues(p_log);

fprintf('\n');
fprintf('============================================================\n');
fprintf('STOUFFER COMBINATION TEST - LOGICIANS - UNION ROI\n');
fprintf('============================================================\n');
fprintf('Z = %.6f\n', Z_log);
fprintf('p_global = %.6g\n', pS_log);

fprintf('\nSubject-wise Z values:\n');
fprintf('%.6f ', z_log);
fprintf('\n');

%% =========================================================
%  SAVE TO WORKSPACE
%% =========================================================
assignin('base','res_log',res_log);
assignin('base','dice_log',dice_log);
assignin('base','p_log',p_log);
assignin('base','pS_log',pS_log);
assignin('base','Z_log',Z_log);
assignin('base','z_log',z_log);

fprintf('\nDone. Variables saved in workspace.\n');

%% =========================================================
%  FUNCTIONS
%% =========================================================

function res = compute_overlap_group_unionROI(subj, glm_root, formulas_root, ...
    t_thresh_mask, t_thresh, V_leftROI, V_rightROI)

    nSub = length(subj);

    res.dice    = nan(1, nSub);
    res.p_hyg   = nan(1, nSub);

    res.Vtotal  = nan(1, nSub);
    res.Vlogic  = nan(1, nSub);
    res.Vform   = nan(1, nSub);
    res.Vint    = nan(1, nSub);

    for iSub = 1:nSub
        s = subj(iSub);

        fprintf('Processing sub-%02d...\n', s);

        % -------------------------------------------------
        % LOGIC FILES
        % -------------------------------------------------
        logic_file_rest  = sprintf('%ssub-%02d/spmT_0015.nii', glm_root, s);
        logic_file_vs_gk = sprintf('%ssub-%02d/spmT_0019.nii', glm_root, s);

        % -------------------------------------------------
        % FORMULAS FILE
        % -------------------------------------------------
        if s == 25
            formulas_file = sprintf('%ssub-%02d/analyses/VisualLocalizer/spmT_0015.nii', formulas_root, s);
        else
            formulas_file = sprintf('%ssub-%02d/analyses/VisualLocalizer/spmT_0008.nii', formulas_root, s);
        end

        % -------------------------------------------------
        % READ IMAGES
        % -------------------------------------------------
        V_logic_vs_gk = spm_vol(logic_file_vs_gk);
        Y_logic_vs_gk = spm_read_vols(V_logic_vs_gk);

        V_logic_rest = spm_vol(logic_file_rest);
        Y_logic_rest = spm_read_vols(V_logic_rest);

        V_formulas = spm_vol(formulas_file);
        Y_formulas = spm_read_vols(V_formulas);

        % -------------------------------------------------
        % GEOMETRY CHECK
        % -------------------------------------------------
        if ~isequal(V_logic_vs_gk.dim, V_logic_rest.dim, V_formulas.dim)
            error('Dimension mismatch for sub-%02d: logic/formulas maps do not have the same dim.', s);
        end

        if ~isequal(V_logic_vs_gk.mat, V_logic_rest.mat) || ~isequal(V_logic_vs_gk.mat, V_formulas.mat)
            error('Affine mismatch for sub-%02d: logic/formulas maps do not have the same mat.', s);
        end

        % -------------------------------------------------
        % BINARIZE MAPS
        % -------------------------------------------------
        logic_bin      = Y_logic_vs_gk > t_thresh;
        logic_mask_bin = Y_logic_rest  > t_thresh_mask;
        logic_final    = logic_bin & logic_mask_bin;

        formulas_bin   = Y_formulas > t_thresh;

        % -------------------------------------------------
        % UNION ROI = LEFT OR RIGHT
        % -------------------------------------------------
        M_left  = resample_mask_to_target(V_leftROI,  V_logic_vs_gk);
        M_right = resample_mask_to_target(V_rightROI, V_logic_vs_gk);
        M_roi   = M_left | M_right;

        % -------------------------------------------------
        % RESTRICT MAPS TO UNION ROI
        % -------------------------------------------------
        logic_roi    = logic_final  & M_roi;
        formulas_roi = formulas_bin & M_roi;

        V_total = nnz(M_roi);
        V_A     = nnz(logic_roi);
        V_B     = nnz(formulas_roi);
        V_AB    = nnz(logic_roi & formulas_roi);

        res.Vtotal(iSub) = V_total;
        res.Vlogic(iSub) = V_A;
        res.Vform(iSub)  = V_B;
        res.Vint(iSub)   = V_AB;

        % -------------------------------------------------
        % DICE
        % -------------------------------------------------
        if (V_A + V_B) > 0
            res.dice(iSub) = (2 * V_AB) / (V_A + V_B);
        else
            res.dice(iSub) = NaN;
        end

        % -------------------------------------------------
        % HYPERGEOMETRIC P-VALUE
        % -------------------------------------------------
        if V_total > 0 && V_A > 0 && V_B > 0 && V_AB > 0
            res.p_hyg(iSub) = hygecdf(V_AB - 1, V_total, V_A, V_B, 'upper');
        else
            res.p_hyg(iSub) = 1.0;
        end

        fprintf(' sub-%02d | Dice = %.4f | p_hyg = %.4g | Vroi=%d Vlogic=%d Vform=%d Vint=%d\n', ...
            s, res.dice(iSub), res.p_hyg(iSub), V_total, V_A, V_B, V_AB);
    end
end

function M = resample_mask_to_target(Vmask, Vtarget)
    [X,Y,Z] = ndgrid(1:Vtarget.dim(1), 1:Vtarget.dim(2), 1:Vtarget.dim(3));
    XYZt  = [X(:)'; Y(:)'; Z(:)'; ones(1,numel(X))];
    XYZmm = Vtarget.mat * XYZt;
    XYZm  = Vmask.mat \ XYZmm;

    M = reshape(spm_sample_vol(Vmask, XYZm(1,:), XYZm(2,:), XYZm(3,:), 0) > 0, Vtarget.dim);
end

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