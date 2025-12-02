# FAQ – Fatal Accidents Study Dashboard

---

### 1. What does this dashboard do?

This dashboard has **two main purposes**:

1. **Generate new predictions** of the probability that a person involved in a fatal motor vehicle accident would experience a fatality, based on user-entered accident, person, and vehicle characteristics.
2. **Display model performance** on an independent **test dataset** (data the model never saw during training), so you can understand how well the model performs overall.

---

### 2. How do I get a prediction?

Use the **“Enter Information”** tab:

1. Fill out the sections about the **Accident**, **Person**, and (if applicable) **Vehicle**.
2. Provide as much detail as possible- fields that don’t apply (e.g., pedestrian-only cases) are handled automatically.
3. Once you’ve entered all relevant information, go to the  
   **“Predicted Probability of Fatality”** tab.
4. The dashboard will display the **estimated probability of fatality** for the scenario you entered.

The more specific and complete the inputs are, the more reliable the prediction will be.

---

### 3. What does the “Predicted Probability of Fatality” actually represent?

The predicted probability is the model’s estimate (between 0 and 1, shown as a percentage) that the person described in your inputs would experience a fatal outcome in an accident with those characteristics.

- A **higher percentage** means the model believes the scenario is more likely to involve a fatality.
- A **lower percentage** means the model believes the scenario is less likely to involve a fatality.

This is a **model-based estimate**, not a guarantee or a real-world forecast for any specific individual.

The probability shown is not the chance that a fatality occurs in the accident overall. Instead, it is the probability that, given a fatality has occurred in the crash, the person you described in the Enter Information tab is the one who died.

This also assumes that more than one person was involved in the accident. If only a single person is involved, then the conditional probability that this person is the fatality is, by definition, 100%.

---

### 4. Why does the prediction change when I modify certain inputs?

Each input (weather, lighting, person role, age, vehicle characteristics, speed, etc.) is a **feature** in the statistical model. Changes to these features can increase or decrease the model’s prediction.

Examples:

- Increasing **speed** often increases the predicted probability.
- Changing **restraint use** from “properly used” to “not used” can increase the predicted probability.
- Switching the **person type** from driver to pedestrian changes which variables are relevant and how they are interpreted.

The model combines all of these features at once; sometimes small changes can have noticeable effects on the prediction.

---

### 5. What is the “Model Performance on Test Data” tab?

The **“Model Performance on Test Data”** tab is not about your specific input. Instead, it shows how the model performs on a **held-out test dataset**:

- This test data was **not used during training**.
- It provides an **independent assessment** of how well the model discriminates between fatal and non-fatal outcomes for persons listed in the test dataset.

On this tab, you can:

- View the **ROC curve**.
- Select a **classification threshold**.
- See the resulting **confusion matrix** and metrics (Accuracy, Sensitivity, Specificity) for the test data at that threshold.

---

### 6. What is the ROC curve?

The **ROC (Receiver Operating Characteristic) curve** shows how the model trades off **Sensitivity** vs **False Positive Rate** across all possible classification thresholds.

- **X-axis:** False Positive Rate (1 – Specificity)
- **Y-axis:** True Positive Rate (Sensitivity)
- Each point on the curve corresponds to a different **probability threshold** used to classify “Fatality” vs “Non-Fatal”.

The closer the ROC curve is to the **top-left corner**, the better the model is at discriminating between fatal and non-fatal outcomes at any threshold.

---

### 7. What is the “threshold” slider and how does it affect the metrics?

The **threshold** slider lets you choose the cutoff used to classify a case as a **“Fatality” (positive)** vs **“Non-Fatality” (negative)** based on predicted probability.

- If predicted probability >= threshold, then it is classified as **Fatality**.
- If predicted probability < threshold, the it is classified as **Non-Fatality**.

Changing the threshold affects:

- **Sensitivity (True Positive Rate):** proportion of actual fatalities correctly predicted as fatal.
- **Specificity (True Negative Rate):** proportion of non-fatal cases correctly predicted as non-fatal.
- **Accuracy:** overall proportion of correct classifications.

On the **Model Performance** tab, when you move the threshold slider:

- A point on the ROC curve moves to show the chosen threshold.
- The **confusion matrix** and **metrics table** are recalculated using that threshold on the test data.

This lets you explore trade-offs, such as:

- Higher Sensitivity (catch more true fatalities) vs  
- Higher Specificity (fewer false alarms).

---

### 8. Why don’t the test metrics always match what I see for a single prediction?

The **Predicted Probability of Fatality** tab shows the model’s estimate for **one specific scenario**.

The **Model Performance on Test Data** tab aggregates results across **many test cases**, showing how the model behaves on average.

It’s normal for:

- An individual prediction to look “high” or “low” relative to the average.
- Test metrics (e.g., 90% accuracy at a certain threshold) do not map directly to any one person’s predicted risk.

They serve **different purposes**:

- **Individual prediction:** “Given these inputs, what is the model’s estimated probability of fatality?”
- **Test performance:** “Across many historical cases, how often is the model right or wrong at this threshold?”

---

### 9. Is this dashboard intended for real-world decision-making?

This dashboard is designed primarily as a **study tool** to:

- Explore how different variables relate to the estimated probability of fatality, and
- Understand the **performance characteristics** of the underlying model on test data.

This study is not inherently causal. The inputs do not cause a fatality. Rather, the model has identified features that are associated with higher or lower probabilities of fatality.

It is entirely possible that a feature that appears important is simply correlated with a more fundamentally causal factor that is not included in the model. For example, the model finds that a greater number of occupants in a vehicle is associated with a lower probability of fatality for a given person. One might incorrectly interpret this to mean that cramming more people into a vehicle makes it safer for everyone, which is not true.

A more reasonable interpretation is that vehicles designed to carry many occupants often differ in ways that genuinely improve safety: they tend to be larger, heavier, and built with additional protective features. A school bus, for instance, can carry many passengers, but it also has reinforced structure, high-backed padded seats, and is subject to special traffic laws that enhance occupant protection.
