# Few-Shot Roof Detection — Comparative Case Study

This repository contains the Google Colab notebooks, experimental results, figures, and accompanying report for a comparative investigation of few-shot roof instance segmentation using modern deep learning architectures.

The study investigates roof detection from an extremely small training dataset consisting of **25 labeled aerial images**, with the objective of exploring how different model architectures and targeted augmentation strategies behave under severe data constraints. Due to the limited dataset size, the reported results should be interpreted as observations from a small-scale case study rather than as general performance claims.

---

## Models Evaluated

- **YOLOv8n-seg**
- **YOLO26n-seg**
- **RF-DETR Seg**

The evaluated models used pretrained weights and were fine-tuned on the same training dataset under comparable experimental conditions.

---

## Repository Contents

```text
.
├── notebooks/
│   ├── baseline_yolov8n.ipynb
│   ├── baseline_yolo26n_100ep.ipynb
│   ├── baseline_yolo26n_150ep.ipynb
│   ├── baseline_rfdetr.ipynb
│   ├── sahi_inference.ipynb
│   └── augmentation.ipynb
│
├── Few_Shot_Roof_Detection.pdf
├── Note_on_AI_Usage.pdf
│
├── README.md
│
└── predictions/
    ├── baseline_yolov8n_predictions/
    ├── baseline_yolo26n_100ep_predictions/
    ├── baseline_yolo26n_150ep_predictions/
    ├── sahi_inference_predictions/
    ├── augmentation_predictions/
    └── unseen_test_predictions.zip
```

Each notebook contains the complete workflow for a single experiment, including data preparation, model training, evaluation, and visualization.

All experiments were developed and executed in **Google Colab** using GPU acceleration.

---

# Experimental Runs

| Run | Model | Training Images | Configuration | Evaluation Outcome |
| --- | --- | ---: | --- | --- |
| **baseline_yolov8n** | YOLOv8n-seg | 25 | 100 epochs | Detected the majority of roof instances in the held-out evaluation images; Roof C and Roof B were not detected. |
| **baseline_yolo26n_100ep** | YOLO26n-seg | 25 | 100 epochs | Detected the majority of roof instances; Roof C was not detected. Selected as the baseline for subsequent experiments. |
| **baseline_yolo26n_150ep** | YOLO26n-seg | 25 | 150 epochs | Produced a similar evaluation outcome to the 100-epoch model. No observable difference was found during evaluation. |
| **baseline_rfdetr** | RF-DETR Seg | 25 | Default configuration | Detected the majority of roof instances; Roof C, Roof A, and Roof B were not detected. No qualitative advantage was observed despite higher computational requirements. |
| **sahi_inference** | YOLO26n-seg | 25 | SAHI tiled inference without retraining | Produced similar predictions to the baseline model; Roof C remained undetected. |
| **augmentation_0** | YOLO26n-seg | 28 | Three augmented images using 0.5× scaling and rotations (30°, 60°, 90°) | Roof C remained undetected, and Roof A was additionally missed. |
| **augmentation_1** | YOLO26n-seg | 29 | Three augmented images using 0.5× scaling and one augmented image using 0.25× scaling; no rotation | Roof C was detected, while one large roof and Roof B were not detected. Additional false-positive predictions were observed on shadows and vegetation. |

---

# Methodology

The experiments followed a controlled design in which individual interventions were evaluated separately.

The investigation included:

- baseline comparison of three segmentation architectures,
- training-duration control,
- inference-time control using SAHI,
- two targeted small-object augmentation strategies,
- evaluation on a held-out test set,
- qualitative evaluation on previously unseen AIRS images.

The AIRS evaluation did not use ground-truth annotations; results were assessed through visual inspection only.

---

# Main Observations

- Under the evaluated conditions, YOLO26n-seg was selected as the baseline model for further experimentation.
- Extending training from 100 to 150 epochs did not produce an observable difference on the evaluated images.
- Applying SAHI tiled inference produced similar predictions to the baseline model.
- The scale-only augmentation strategy recovered Roof C but also introduced additional missed detections and false-positive predictions.
- Evaluation on previously unseen AIRS images showed roof predictions in many scenes, while smaller roof structures continued to represent challenging cases.
- The experiments illustrate that automatic validation metrics and evaluation on unseen images can provide different perspectives when working with extremely small datasets.

# External Qualitative Evaluation on AIRS Dataset

The selected baseline model (**YOLO26n-seg, 100 epochs**) was additionally evaluated on 80 previously unseen aerial images from the public AIRS dataset. These images were not used during training or model selection. As no ground-truth annotations were available, evaluation was performed through visual inspection only.

The model detected roof instances in many unseen images, while smaller and partially occluded roofs remained more difficult to detect. This evaluation provides additional qualitative observations of model behaviour beyond the client dataset.

---

# References and Resources

The implementation and experimental workflow were informed by:

- Ultralytics documentation and GitHub repository
- RF-DETR documentation and GitHub repository
- SAHI documentation and GitHub repository
- Additional references listed in the accompanying paper
- AI usage transparency documentation (see accompanying PDF)

Claude and ChatGPT were used as AI-assisted tools for:

- literature exploration,
- reference identification,
- targeted implementation guidance,
- debugging assistance,
- scientific writing support.

All implementation decisions, experiments, analyses, and reported results were carried out by the author.

---

# Environment

The experiments were executed using:

- Google Colab
- Python 3.11
- Ultralytics
- RF-DETR
- SAHI
- OpenCV
- NumPy
- PIL
- Supervision
