## Dataset overview

**File**: **rsa_distances.csv**
- **Size**: (rows = 23, columns = 8)


## Columns description

| Name | Data Type | Description |
|:---|:---|:---|
| `Subject` | numeric | Participant identifier |
| `Group` | string | Experimental group identifier |
| `Dist_Logic_Left` | numeric | Euclidean distance between the neural pattern evoked by Formulas and that evoked by Logic statements computed on z-score normalized beta estimates (LH) |
| `Dist_Logic_Right` | numeric | Euclidean distance between the neural pattern evoked by Formulas and that evoked by Logic statements computed on z-score normalized beta estimates (RH) |
| `Dist_General_Left` | numeric | Euclidean distance between the neural pattern evoked by Formulas and that evoked by General Knowledge statements computed on z-score normalized beta estimates (LH) |
| `Dist_General_Right` | numeric | Euclidean distance between the neural pattern evoked by Formulas and that evoked by General Knowledge statements computed on z-score normalized beta estimates (RH) |
| `Auditory_Mean` | numeric | Mean of 'Dist_Logic' and 'Dist_General', averaged across hemispheres, representing the average representational distance between Formulas and auditory categories |
| `Visual_Mean` | numeric | Mean Euclidean distance between Formulas and the five visual categories, averaged across hemispheres, representing the average representational distance between Formulas and visual categories |

### Example Row

| Subject | Group | Dist_Logic_Left | Dist_Logic_Right | Dist_General_Left | Dist_General_Right | Auditory_Mean | Visual_Mean |
|:---|:---|:---|:---|:---|:---|:---|:---|
| 2 | control | 33.10 | 15.13 | 34.77 | 15.40 | 24.60 | 25.34 |
