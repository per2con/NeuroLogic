# Analysis codes

MATLAB scripts for the behavioural and fMRI analyses reported in the manuscript "*The brain encodes pure logic beyond natural language and at the boundaries with mathematics*" (Amalric et al., 2026).

## Folder Overview 

| Script | Purpose | Input file | 
|---|---|---|
| `behavioural_analysis.m` | Accuracy and d-prime (Logic vs Non-Logic; Logicians vs Controls): t-tests vs chance, paired, two-sample, and mixed ANOVA | `behavioural_data.csv` |
| `betas_analysis.m` | Parameter estimates by group, stimulus type, truth value and ROI (descriptive stats for plotting) | `logicians_betas_logic_main_task` / `logicians_betas_gk_main_task` |
| `dice_coefficients.m` | Overlap between activation maps; logit-transformed paired t-tests | `dice_coefficients.csv` |
| `lateralization_indices.m` | Lateralization indices: Fisher-z t-tests vs 0 and paired comparisons across conditions | `lateralization_indices.csv` |
| `intensity_and_extent.m` | Intensity and extent of formula-selective activation: mixed ANOVA, t-test | `formula_activation_results.csv` |
| `dice_writtenformulas_logicstatements.m` | Overlap between activation maps; hypergeometric tests, Stouffer's Z-score |  |

## 1. System requirements

- **Software:** MATLAB R2019b or later, with the Statistics and Machine Learning Toolbox (`ttest`, `ttest2`, `anovan`, `grpstats`, `groupsummary`, `norminv`).
- **Operating systems:** any OS supported by MATLAB (Windows 10/11, macOS 11+, Linux)
- **Tested on:** MATLAB R2023b, Windows 11.

## 2. Installation guide

1. Install MATLAB and the Statistics and Machine Learning Toolbox (see MathWorks installer).
2. Download this folder and add it to the MATLAB path, or `cd` into it.

**Scripts installation time**: <1 min

## 3. Demo

Add the data folders to MATLAB path and run the corresponding script. For example:

```matlab
addpath("data/behavioural_data/")
run("code/behavioural_analysis/")
```

**Expected output** (printed to the Command Window):

- `behavioural_analysis.m` — summary tables of accuracy (%) and d-prime by group and stimulus type (mean ± SEM), a table of t-tests results (`Test`, `t`, `df`, `p`), and two ANOVA tables (group × condition for both accuracy and d-prime).
- `betas_analysis.m` — `group_stats` table with mean ± SEM parameter estimates per group, stimulus type, truth value and ROI.
- `dice_coefficients.m` — `group_stats` table plus two lines reporting `t`, `df`, `p` for the paired comparisons.
- `lateralization_indices.m` — `group_stats` table, one line per condition for the tests against 0, and one line per pair for the paired tests.
-  `intensity_and_extent.m` — three ANOVA tables (for peak intensity, cluster intensity, extent), post-hoc t-tests for the extent analysis, Cohen's d in the right hemisphere (`d_extent_right`) .
-  `dice_writtenformulas_logicstatements.m` — summary tables of dice (number of subjects, mean, SD, median, individual values), individual results from the hypergeometric test, number of significant subjects (p<0.05 and p<0.01), Stouffer's test results (individual z-values, global z-value, p-value) .

**Expected run time:** a few seconds per script on a normal desktop computer.

## 4. Instructions for use

For each script, set `dataFile` at the top to your own file and run it. Required columns:

- **Behavioural:** `subject_id`, `group` (`logicians`/`controls`), `category_id` (1–12), `response` (1 = true, 2 = false, 3 = meaningless; 0/−3 = no response), `accuracy`.
- **Betas:** `subject_id`, `group`, `roi`, `category_id` (1–6), `parameter_estimate`.
- **Dice:** `maps`, `hemisphere` (`LH`/`RH`/`bilateral`), `dice`.
- **Lateralization:** `subject_id`, `condition` (`logic`/`gk`/`calculation`), `LI_wm`.
-  **Intensity and extent:** `Subject`, `Group`, `Extent_Left`, `Extent_Right`, `PeakT_Left`, `PeakT_Right`, `MeanT_Left`, `MeanT_Right` .
