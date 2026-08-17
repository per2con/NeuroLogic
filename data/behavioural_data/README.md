# Behavioural data

This file contains the behavioural responses collected during the main task which have been used to generate figure 1b.

## Dataset overview

**File**: **behavioural_data.csv**
- **Size**: (rows = 2112, columns = 7)

## Columns description

| Name | Data Type | Description |
|:---|:---|:---|
| `subject_id` | string | Participant identifier |
| `group` | string | Experimental group identifier |
| `run_nr` | numeric | Run number |
| `trial_nr` | numeric | Trial number |
| `category_id` | numeric | Statement category identifier: `1` = True propositional logic; `2` = True inferential logic; `3` = False propositional logic; `4` = False inferential logic; `5` = Meaningless propositional logic; `6` = Meaningless inferential logic; `7` = True propositional gk; `8` = True inferential gk; `9` = False propositional gk; `10` = False inferential gk; `11` = Meaningless propositional gk; `12` = Meaningless inferential gk |
| `response` | numeric | `0` = response not collected; `1` = participant judged the statement as **true**; `2` = judged it as **false**; `3` = judged it as **meaningless** |
| `accuracy` | numeric | `1` =  **correct** response ; `0` = **incorrect** response |


## Example Row

| subject_id | group | run_nr | trial_nr | category_id | response | accuracy |
|:---|:---|:---|:---|:---|:---|:---|
| sub-01 | logicians | 1 | 1 | 1 | 1 | 1 | 

