# Lateralization indices

This file contains the lateralization indices (LIs) which have been used to generate figure 2c and figure 4c.

Lateralization indices have been computed using the bootstrap method as implemented in LI-toolbox (Wilke and Lidzba, 2007; Wilke and Schmithorst, 2006)

## Dataset overview

**File**: **lateralization_indices.csv**
- **Size**: (rows = 35, columns = 7)

## Columns description

| Name | Data Type | Description |
|:---|:---|:---|
| `subject_id` | string | Participant identifier |
| `map` | string | Statistical map on which lateralization indices have been computed: `logic` = *Meaningful logic knowledge* > *meaningful general knowledge*; `gk` = *Meaningful general knowledge* > *meaningful logic knowledge*; `calculation` = *calculation* > *sentence processing* |
| `LI_overall` | numeric | LI simple mean |
| `LI_SD` | numeric | LI standard deviation |
| `LI_min` | numeric | Minimum LI from bootstrap samples |
| `LI_max` | numeric | Maximum LI from bootstrap samples |
| `LI_wm` | numeric | LI threshold-weighted mean |


## Example Row

| subject_id | map | LI_overall | LI_sd | LI_min | LI_max | LI_wm |
|:---|:---|:---|:---|:---|:---|:---|
| sub-01 | logic | 0.62 | 0.11 | 0.38 | 0.82 | 0.59 |

