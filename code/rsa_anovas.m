%% RSA ANOVA ANALYSES
% Loads distances from rsa_distances.csv and runs two mixed-model ANOVAs:
% 1) Group x Modality (auditory vs visual)
% 2) Group x Content x Hemisphere (logic vs general knowledge)

dataFile = 'rsa_distances.csv';
T = readtable(dataFile);

%% RSA ANOVA ANALYSES

dataFile = 'rsa_distances.csv';
T = readtable(dataFile);

idx_con = strcmp(T.Group, 'control');
idx_log = strcmp(T.Group, 'logician');

nCon = sum(idx_con);
nLog = sum(idx_log);

%% ANOVA 1: GROUP x MODALITY

y = [T.Auditory_Mean(idx_con); T.Visual_Mean(idx_con); ...
     T.Auditory_Mean(idx_log); T.Visual_Mean(idx_log)];

group    = [ones(1,2*nCon) ones(1,2*nLog)*2];
modality = [ones(1,nCon) ones(1,nCon)*2 ones(1,nLog) ones(1,nLog)*2];
subjects = [repmat(1:nCon,1,2) repmat((1:nLog)+nCon,1,2)];

anovan(y, {group, modality, subjects}, 'model', 'full', 'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0], ...
    'varnames', {'group', 'modality', 'subjects'})

%% ANOVA 2: GROUP x CONTENT x HEMISPHERE

y = [T.Dist_Logic_Left(idx_con);    T.Dist_General_Left(idx_con); ...
     T.Dist_Logic_Right(idx_con);   T.Dist_General_Right(idx_con); ...
     T.Dist_Logic_Left(idx_log);    T.Dist_General_Left(idx_log); ...
     T.Dist_Logic_Right(idx_log);   T.Dist_General_Right(idx_log)];

group      = [ones(1,4*nCon) ones(1,4*nLog)*2];
content    = [ones(1,nCon) ones(1,nCon)*2 ones(1,nCon) ones(1,nCon)*2 ...
              ones(1,nLog) ones(1,nLog)*2 ones(1,nLog) ones(1,nLog)*2];
hemisphere = [ones(1,2*nCon) ones(1,2*nCon)*2 ones(1,2*nLog) ones(1,2*nLog)*2];
subjects   = [repmat(1:nCon,1,4) repmat((1:nLog)+nCon,1,4)];

anovan(y, {group, content, hemisphere, subjects}, 'model', 'full', 'random', 4, ...
    'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0], ...
    'varnames', {'group', 'content', 'hemisphere', 'subjects'})