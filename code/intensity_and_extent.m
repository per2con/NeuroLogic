%% LOAD CSV AND RECREATE WORKSPACE VARIABLES
% Run this to reload data from CSV and recreate all variables needed
% for the statistical analyses.

dataFile = 'formula_activation_results.csv';
T = readtable(dataFile);

% Split by group
idx_controls  = strcmp(T.Group, 'control');
idx_logicians = strcmp(T.Group, 'logician');

% ---- EXTENT ----
Formule_Left_Controlli  = T.Extent_Left(idx_controls);
Formule_Right_Controlli = T.Extent_Right(idx_controls);
Formule_Left_Logici     = T.Extent_Left(idx_logicians);
Formule_Right_Logici    = T.Extent_Right(idx_logicians);

% ---- PEAK T ----
PeakT_Left_Controlli  = T.PeakT_Left(idx_controls);
PeakT_Right_Controlli = T.PeakT_Right(idx_controls);
PeakT_Left_Logici     = T.PeakT_Left(idx_logicians);
PeakT_Right_Logici    = T.PeakT_Right(idx_logicians);

% ---- MEAN T ----
MeanT_Left_Controlli  = T.MeanT_Left(idx_controls);
MeanT_Right_Controlli = T.MeanT_Right(idx_controls);
MeanT_Left_Logici     = T.MeanT_Left(idx_logicians);
MeanT_Right_Logici    = T.MeanT_Right(idx_logicians);

fprintf('Done. All variables recreated in workspace.\n');

%% Statistical analyses

% %% EXTENT
y_an = [Formule_Left_Controlli(:); ...
        Formule_Right_Controlli(:); ...
        Formule_Left_Logici(:); ...
        Formule_Right_Logici(:)];

nControls  = numel(Formule_Left_Controlli);
nLogicians = numel(Formule_Left_Logici);

GROUP = [ones(1,2*nControls), 2*ones(1,2*nLogicians)];
HEMISPHERE = [ones(1,nControls), 2*ones(1,nControls), ...
              ones(1,nLogicians), 2*ones(1,nLogicians)];

SUB_controls  = repmat(1:nControls,1,2);
SUB_logicians = repmat((1:nLogicians)+nControls,1,2);
SUB = [SUB_controls, SUB_logicians];

factors = {GROUP HEMISPHERE SUB};

fprintf('\n============================================================\n');
fprintf('ANOVA - EXTENT\n');
fprintf('============================================================\n');
[p,tbl,stats] = anovan(y_an, factors, ...
    'varnames', {'GROUP','HEMISPHERE','SUB'}, ...
    'model', 'full', ...
    'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0]);
% 
% 
%% INTENSITY 
% PEAK T VALUE
y_an = [PeakT_Left_Controlli(:); ...
        PeakT_Right_Controlli(:); ...
        PeakT_Left_Logici(:); ...
        PeakT_Right_Logici(:)];

nControls  = numel(PeakT_Left_Controlli);
nLogicians = numel(PeakT_Left_Logici);

GROUP = [ones(1,2*nControls), 2*ones(1,2*nLogicians)];
HEMISPHERE = [ones(1,nControls), 2*ones(1,nControls), ...
              ones(1,nLogicians), 2*ones(1,nLogicians)];

SUB_controls  = repmat(1:nControls,1,2);
SUB_logicians = repmat((1:nLogicians)+nControls,1,2);
SUB = [SUB_controls, SUB_logicians];

factors = {GROUP HEMISPHERE SUB};

fprintf('\n============================================================\n');
fprintf('ANOVA - PEAK T VALUE\n');
fprintf('============================================================\n');
[p,tbl,stats] = anovan(y_an, factors, ...
    'varnames', {'GROUP','HEMISPHERE','SUB'}, ...
    'model', 'full', ...
    'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0]);

% 
% MEAN T VALUE IN PEAK CLUSTER
% 
y_an = [MeanT_Left_Controlli(:); ...
        MeanT_Right_Controlli(:); ...
        MeanT_Left_Logici(:); ...
        MeanT_Right_Logici(:)];

nControls  = numel(MeanT_Left_Controlli);
nLogicians = numel(MeanT_Left_Logici);

GROUP = [ones(1,2*nControls), 2*ones(1,2*nLogicians)];
HEMISPHERE = [ones(1,nControls), 2*ones(1,nControls), ...
              ones(1,nLogicians), 2*ones(1,nLogicians)];

SUB_controls  = repmat(1:nControls,1,2);
SUB_logicians = repmat((1:nLogicians)+nControls,1,2);
SUB = [SUB_controls, SUB_logicians];

factors = {GROUP HEMISPHERE SUB};

fprintf('\n============================================================\n');
fprintf('ANOVA - MEAN T VALUE IN PEAK CLUSTER\n');
fprintf('============================================================\n');
[p,tbl,stats] = anovan(y_an, factors, ...
    'varnames', {'GROUP','HEMISPHERE','SUB'}, ...
    'model', 'full', ...
    'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0]);


% % Post hoc t test per mean T
% [h_left,p_left,ci_left,stats_left]       = ttest2(MeanT_Left_Controlli,  MeanT_Left_Logici);
% [h_right,p_right,ci_right,stats_right]   = ttest2(MeanT_Right_Controlli, MeanT_Right_Logici);
% 
% [h_lr_log,p_lr_log,ci_lr_log,stats_lr_log]     = ttest(MeanT_Left_Logici,    MeanT_Right_Logici)
% [h_lr_ctrl,p_lr_ctrl,ci_lr_ctrl,stats_lr_ctrl] = ttest(MeanT_Left_Controlli, MeanT_Right_Controlli)

% Post hoc t test per extent
% 
% [h_left,p_left,ci_left,stats_left]       = ttest2(Formule_Left_Controlli,  Formule_Left_Logici);
% [h_right,p_right,ci_right,stats_right]   = ttest2(Formule_Right_Controlli, Formule_Right_Logici);
% 
% [h_lr_log,p_lr_log,ci_lr_log,stats_lr_log]    = ttest(Formule_Left_Logici,    Formule_Right_Logici)
% [h_lr_ctrl,p_lr_ctrl,ci_lr_ctrl,stats_lr_ctrl] = ttest(Formule_Left_Controlli, Formule_Right_Controlli)
