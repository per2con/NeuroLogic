%% RSA ANOVA ANALYSES
% Loads distances from rsa_distances.csv and runs two mixed-model ANOVAs:
% 1) Group x Modality (auditory vs visual)
% 2) Group x Content x Hemisphere (logic vs general knowledge)

dataFile = 'rsa_distances.csv';
T = readtable(dataFile);

idx_controls  = strcmp(T.Group, 'control');
idx_logicians = strcmp(T.Group, 'logician');

nControls  = sum(idx_controls);
nLogicians = sum(idx_logicians);

%% =====================================================
%  ANOVA 1: GROUP x MODALITY
%  Auditory = mean(Formulas-Logic, Formulas-GK) across hemispheres
%  Visual   = mean(Formulas-Houses/Numbers/Words/Faces/Tools) across hemispheres
%% =====================================================

auditory_controls  = T.Auditory_Mean(idx_controls);
auditory_logicians = T.Auditory_Mean(idx_logicians);
visual_controls    = T.Visual_Mean(idx_controls);
visual_logicians   = T.Visual_Mean(idx_logicians);

y_mod = [auditory_controls(:); visual_controls(:); ...
         auditory_logicians(:); visual_logicians(:)];

GROUP_mod = [ones(1,2*nControls), 2*ones(1,2*nLogicians)];

MODALITY = [ones(1,nControls), 2*ones(1,nControls), ...
            ones(1,nLogicians), 2*ones(1,nLogicians)];

SUB_mod = [repmat(1:nControls,1,2), repmat((1:nLogicians)+nControls,1,2)];

fprintf('\n=====================================================\n');
fprintf('ANOVA 1: GROUP x MODALITY\n');
fprintf('=====================================================\n');

[p_mod, tbl_mod, stats_mod] = anovan(y_mod, {GROUP_mod, MODALITY, SUB_mod}, ...
    'varnames', {'Group', 'Modality', 'Subject'}, ...
    'model', 'full', ...
    'random', 3, ...
    'nested', [0 0 0; 0 0 0; 1 0 0]);

fprintf('\nDescriptive means:\n');
fprintf('Controls  - Auditory: %.4f\n', mean(auditory_controls,  'omitnan'));
fprintf('Controls  - Visual:   %.4f\n', mean(visual_controls,    'omitnan'));
fprintf('Logicians - Auditory: %.4f\n', mean(auditory_logicians, 'omitnan'));
fprintf('Logicians - Visual:   %.4f\n', mean(visual_logicians,   'omitnan'));

%% =====================================================
%  ANOVA 2: GROUP x CONTENT x HEMISPHERE
%  Content = Formulas-Logic vs Formulas-General Knowledge
%  Hemisphere = Left vs Right
%% =====================================================

dist_logic_controls_left    = T.Dist_Logic_Left(idx_controls);
dist_logic_controls_right   = T.Dist_Logic_Right(idx_controls);
dist_general_controls_left  = T.Dist_General_Left(idx_controls);
dist_general_controls_right = T.Dist_General_Right(idx_controls);

dist_logic_logicians_left    = T.Dist_Logic_Left(idx_logicians);
dist_logic_logicians_right   = T.Dist_Logic_Right(idx_logicians);
dist_general_logicians_left  = T.Dist_General_Left(idx_logicians);
dist_general_logicians_right = T.Dist_General_Right(idx_logicians);

y_con = [dist_logic_controls_left(:); dist_general_controls_left(:); ...
         dist_logic_controls_right(:); dist_general_controls_right(:); ...
         dist_logic_logicians_left(:); dist_general_logicians_left(:); ...
         dist_logic_logicians_right(:); dist_general_logicians_right(:)];

GROUP_con = [ones(1,4*nControls), 2*ones(1,4*nLogicians)];

CONTENT = [ones(1,nControls), 2*ones(1,nControls), ...
           ones(1,nControls), 2*ones(1,nControls), ...
           ones(1,nLogicians), 2*ones(1,nLogicians), ...
           ones(1,nLogicians), 2*ones(1,nLogicians)];

HEMISPHERE = [ones(1,2*nControls), 2*ones(1,2*nControls), ...
              ones(1,2*nLogicians), 2*ones(1,2*nLogicians)];

SUB_con = [repmat(1:nControls,1,4), repmat((1:nLogicians)+nControls,1,4)];

fprintf('\n=====================================================\n');
fprintf('ANOVA 2: GROUP x CONTENT x HEMISPHERE\n');
fprintf('=====================================================\n');

[p_con, tbl_con, stats_con] = anovan(y_con, {GROUP_con, CONTENT, HEMISPHERE, SUB_con}, ...
    'varnames', {'Group', 'Content', 'Hemisphere', 'Subject'}, ...
    'model', 'full', ...
    'random', 4, ...
    'nested', [0 0 0 0; 0 0 0 0; 0 0 0 0; 1 0 0 0]);

fprintf('\nDescriptive means:\n');
fprintf('Controls  - Left  - Logic:   %.4f\n', mean(dist_logic_controls_left,    'omitnan'));
fprintf('Controls  - Left  - General: %.4f\n', mean(dist_general_controls_left,  'omitnan'));
fprintf('Controls  - Right - Logic:   %.4f\n', mean(dist_logic_controls_right,   'omitnan'));
fprintf('Controls  - Right - General: %.4f\n', mean(dist_general_controls_right, 'omitnan'));
fprintf('Logicians - Left  - Logic:   %.4f\n', mean(dist_logic_logicians_left,   'omitnan'));
fprintf('Logicians - Left  - General: %.4f\n', mean(dist_general_logicians_left, 'omitnan'));
fprintf('Logicians - Right - Logic:   %.4f\n', mean(dist_logic_logicians_right,  'omitnan'));
fprintf('Logicians - Right - General: %.4f\n', mean(dist_general_logicians_right,'omitnan'));