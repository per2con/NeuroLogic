
## Dataset overview

**File**: **formula_activation_results.csv**
- **Size**: (rows = 23, columns = 8)


## Columns description (File 1 and File 2)

| Name | Data Type | Description |
|:---|:---|:---|
| `Subject` | numeric | Participant identifier |
| `Group` | string | Experimental group identifier |
| `Extent_Left` | numeric | Number of suprathreshold voxels (p < .01 uncorrected) in the cluster containing the individual peak of the Formulas > Others contrast (Left Hemisphere) |
| `Extent_Right` | numeric | Number of suprathreshold voxels (p < .01 uncorrected) in the cluster containing the individual peak of the Formulas > Others contrast (Right Hemisphere) |
| `PeakT_Left` | numeric | Maximum t-value within the cluster containing the individual peak of the Formulas > Others contrast (Left Hemisphere)|
| `PeakT_Right` | numeric | Maximum t-value within the cluster containing the individual peak of the Formulas > Others contrast (Right Hemisphere)|
| `MeanT_Left` | numeric | Mean t-value across all suprathreshold voxels within the cluster containing the individual peak of the Formulas > Others contrast (Left Hemisphere) |
| `MeanT_Right` | numeric | Mean t-value across all suprathreshold voxels within the cluster containing the individual peak of the Formulas > Others contrast (Right Hemisphere) |

### Example Row

| Subject | Group | Extent_Left | Extent_Right | PeakT_Left | PeakT_Right | MeanT_Left | MeanT_Right |
|:---|:---|:---|:---|:---|
| 2 | control | 19 | 5 | 3.647 | 3.58 | 2.77 | 3.00 |


### Example Row

| subject_id | group | roi | category_id | parameter_estimate |
|:---|:---|:---|:---|:---|
| sub-01 | logicians | left_IPS | 1 | 2.5 | 
