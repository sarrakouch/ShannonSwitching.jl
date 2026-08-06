# Few-Shot Roof Detection — Comparative Case Study

This repository contains the Google Colab notebooks, experimental results, figures, and accompanying report for a comparative investigation of few-shot roof instance segmentation using modern deep learning architectures.

The study investigates roof detection from an extremely small training dataset consisting of **25 labeled aerial images**, with the objective of exploring how different model architectures and targeted augmentation strategies behave under severe data constraints. Due to the limited dataset size, the reported results should be interpreted as observations from a small-scale case study rather than as general performance claims.

---

## Models Evaluated

- **YOLOv8n-seg**
- **YOLO26n-seg**
- **RF-DETR Seg**

All models were initialized from COCO-pretrained weights and fine-tuned on the same training dataset under comparable experimental conditions.

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
└── Predict/
    ├── baseline_yolov8n Predict
    ├── baseline_yolo26n_100ep Predict
    ├── baseline_yolo26n_150ep Predict
    ├── sahi_inference Predict
    └── augmentation Predict
