%% EXTENT AND INTENSITY ANALYSES

dataFile = 'formula_activation_results.csv';
T = readtable(dataFile);

idx_con = strcmp(T.Group, 'control');
idx_log = strcmp(T.Group, 'logician');

Formule_Left_Controlli  = T.Extent_Left(idx_con);
Formule_Right_Controlli = T.Extent_Right(idx_con);
Formule_Left_Logici     = T.Extent_Left(idx_log);
Formule_Right_Logici    = T.Extent_Right(idx_log);

PeakT_Left_Controlli  = T.PeakT_Left(idx_con);
PeakT_Right_Controlli = T.PeakT_Right(idx_con);
PeakT_Left_Logici     = T.PeakT_Left(idx_log);
PeakT_Right_Logici    = T.PeakT_Right(idx_log);

MeanT_Left_Controlli  = T.MeanT_Left(idx_con);
MeanT_Right_Controlli = T.MeanT_Right(idx_con);
MeanT_Left_Logici     = T.MeanT_Left(idx_log);
MeanT_Right_Logici    = T.MeanT_Right(idx_log);

nCon = sum(idx_con);
nLog = sum(idx_log);

group      = [ones(1,2*nCon) ones(1,2*nLog)*2];
hemisphere = [ones(1,nCon) ones(1,nCon)*2 ones(1,nLog) ones(1,nLog)*2];
subjects   = [repmat(1:nCon,1,2) repmat((1:nLog)+nCon,1,2)];

%% ANOVA - EXTENT
y = [Formule_Left_Controlli(:); Formule_Right_Controlli(:); ...
     Formule_Left_Logici(:);    Formule_Right_Logici(:)];

anovan(y, {group, hemisphere, subjects}, 'model', 'full', 'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0], ...
    'varnames', {'group', 'hemisphere', 'subjects'})

%% ANOVA - PEAK T (intensity)
y = [PeakT_Left_Controlli(:); PeakT_Right_Controlli(:); ...
     PeakT_Left_Logici(:);    PeakT_Right_Logici(:)];

anovan(y, {group, hemisphere, subjects}, 'model', 'full', 'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0], ...
    'varnames', {'group', 'hemisphere', 'subjects'})

%% ANOVA - MEAN T (intensity)
y = [MeanT_Left_Controlli(:); MeanT_Right_Controlli(:); ...
     MeanT_Left_Logici(:);    MeanT_Right_Logici(:)];

anovan(y, {group, hemisphere, subjects}, 'model', 'full', 'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0], ...
    'varnames', {'group', 'hemisphere', 'subjects'})

%% Post hoc - extent right hemisphere
[h_right, p_right, ci_right, stats_right] = ttest2(Formule_Right_Controlli, Formule_Right_Logici)

%% Cohen's d - extent right hemisphere
d_extent_right = (mean(Formule_Right_Logici) - mean(Formule_Right_Controlli)) / ...
    sqrt((var(Formule_Right_Logici) + var(Formule_Right_Controlli)) / 2)
