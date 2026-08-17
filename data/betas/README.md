# Parameter estimates

This file contains the parameter estimates which have been used to generate figure 2a and 3d. 

## Dataset overview

**File 1**: **logicians_betas_logic_main_task.csv**
- **Size**: (rows = 432, columns = 5)

**File 2**: **logicians_betas_gk_main_task.csv**
- **Size**: (rows = 432, columns = 5)

**File 3**: **logicians_betas_logic_difficulty_ratings.csv**
- **Size**: (rows = 144, columns = 5)

## Columns description (File 1 and File 2)

| Name | Data Type | Description |
|:---|:---|:---|
| `subject_id` | string | Participant identifier |
| `group` | string | Experimental group identifier |
| `roi` | string | Region from which parameter estimates have been extracted |
| `category_id` | numeric | Statement category identifier (propositions and inferences collapsed together): `1` = True logic knowledge; `2` = False logic knowledge; `3` = Meaningless logic knowledge; `4` = True general knowledge; `5` = False general knowledge; `6` = Meaningless general knowledge |
| `parameter_estimate` | numeric | Parameter estimate extracted from the region peak |

### Example Row

| subject_id | group | roi | category_id | parameter_estimate |
|:---|:---|:---|:---|:---|
| sub-01 | logicians | left_IPS | 1 | 2.5 | 



## Columns description (File 3)

| Name | Data Type | Description |
|:---|:---|:---|
| `subject_id` | string | Participant identifier |
| `group` | string | Experimental group identifier |
| `roi` | string | Region from which parameter estimates have been extracted |
| `category_id` | numeric | Statement category identifier (ref. Methods - Controls for difficulty analyses): `1` = Easy logic knowledge; `2` = Difficult logic knowledge; `3` = Easy general knowledge; `4` = Difficult general knowledge |
| `parameter_estimate` | numeric | Parameter estimate extracted from the region peak |

### Example Row

| subject_id | group | roi | category_id | parameter_estimate |
|:---|:---|:---|:---|:---|
| sub-01 | logicians | left_IPS | 1 | 2.5 | 


