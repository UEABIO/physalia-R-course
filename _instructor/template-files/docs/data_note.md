# Data note: vole metabolism experiment

From the colony manager who collected the data. One row per animal.

- **subject_id**: `V` followed by three digits (for example `V007`). Each
  animal appears once.
- **sex**: `M` or `F`.
- **treatment_arm**: `Control`, `Low_dose` or `High_dose`.
- **mass_pre_g**, **mass_post_g**: body mass in grams, before and after
  treatment. Adults in this colony weigh between 15 and 60 g. We entered
  `9999` when an animal could not be weighed.
- **metabolic_rate_post**: metabolic rate after treatment, from the
  respirometer. Valid readings lie between 5 and 30. We entered `-1` when the
  respirometry run failed.
