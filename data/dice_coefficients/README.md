# Dice coefficients

This file contains the dice coefficients reported in "*The brain encodes pure logic beyond natural language and at the boundaries with mathematics*" (Amalric et al., 2026).

## Dataset overview

**File**: **dice_coefficients.csv**
- **Size**: (rows = 55, columns = 4)

## Columns description

| Name | Data Type | Description |
|:---|:---|:---|
| `subject_id` | string | Participant identifier |
| `maps` | string | Statistical maps used for computing dice coefficients: `logic_calculation` = *logic knowledge* and *calculation*; `logic_language` = *logic knowledge* - *sentence processing*; `gk_language` = *general knowledge* - *sentence processing* |
| `hemisphere` | string | Hemispheric mask applied: `bilateral` = bilateral mask; `LH` = left hemisphere mask; `RH` = right hemisphere mask |
| `dice` | numeric | Dice coefficients |


## Example Row

| subject_id | maps | hemisphere | dice |
|:---|:---|:---|:---|
| sub-01 | logic_calculation | bilateral | 0.5 | 

