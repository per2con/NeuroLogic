# Dice between logic statements and formulas

This file contains the voxel counts used for the dice, the hypergeometric test and the Stouffer's test reported in "*The brain encodes pure logic beyond natural language and at the boundaries with mathematics*" (Amalric et al., 2026).

## Dataset overview

**File**: **dice_raw.csv**
- **Size**: (rows = 12, columns = 5)


## Columns description

| Name | Data Type | Description |
|:---|:---|:---|
| `Subject` | numeric | Participant identifier |
| `V_total` | numeric | Total number of voxels in the union ROI |
| `V_logic` | numeric | Number of voxels classified as Logic within the union ROI |
| `V_form` | numeric | Number of voxels classified as Formulas within the union ROI |
| `V_int` | numeric | Number of voxels overlapping between Logic and Formulas|


### Example Row

| Subject | V_total | V_logic | V_form | V_int | 
|:---|:---|:---|:---|:---|
| 3 | 20157 | 376 | 471 | 192 |

