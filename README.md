# Nera

This repo hosts the code for NERA - Pure Negations to Enhance Small LM Performance on
Boolean Commonsense: Replication and Extension of VERA

![Nera Poster](/poster/nera_poster.png)

If you are interested in using the Vera model, please visit our demo or download the model from HuggingFace.
This repo is mainly for model training and reproducing the results in the paper.

* Original Repo: <https://github.com/liujch1998/vera>
* Model: <https://huggingface.co/liujch1998/vera>
* Demo: <https://huggingface.co/spaces/liujch1998/vera>

## Setup

Create a conda environment and activate it:
```bash
conda env create -f environment.yml
conda activate vera
```

## Data Format

The training and evaluation data should be in the format of declarative statements.
Each dataset split should be a JSON file with the following format:
```json
[
    {
        "golds": [
            "Green is a color."
        ],
        "distractors": [
            "Sky is a color.",
            "Bread is a color."
        ]
    },
    {
        "golds": [
            "Green is a color."
        ],
        "distractors": []
    },
    {
        "golds": [],
        "distractors": [
            "Sky is a color."
        ]
    }
]
```
The JSON file should contain a list of problems, and each problem is a dictionary with correct statements under `golds` and incorrect statements under `distractors`.
* The first problem examplifies a multiple-choice problem, which should have one correct statement and one or more incorrect statements.
* The second is a boolean problem with label True, which should have one correct statement and no incorrect statement.
* The third is a boolean problem with label False, which should have no correct statement and one incorrect statement.

In practice, each JSON file should contain either purely multiple-choice problems or purely boolean problems.

## Training

To train a commonsense verification model based on the T5 Encoder on 1 GPU, run
```bash
accelerate launch run.py --run_name "train_stage_b"
accelerate launch run.py --load_from_ckpt {PATH_TO_STAGE_A_CKPT} --run_name "train_stage_c"
```
which by default would set the base model to be the encoder of T5-v1.1-small, and the per-GPU batch size to be 1.
Refer to `run.py` for the list of customizable parameters.

where `{PATH_TO_STAGE_A_CKPT}` is the path to the model ckpt from Stage A training, and it should be something like `../runs/train_stage_a/model/ckp_XXXXX.pth`

## Evaluation

To evaluate a trained model, run
```bash
accelerate launch \
    run.py \
    --mode eval \
    --load_from_ckpt {PATH_TO_CKPT} \
    --eval_tasks {dataset1,dataset2,...} \
    --run_name "eval"
```

To evaluate the Nera model trained in the previous section, run
```bash
accelerate launch run.py --mode eval --load_from_ckpt {PATH_TO_CKPT} --run_name "eval_stage_c"
```

where `{PATH_TO_STAGE_A_CKPT}` is the path to the model ckpt from Stage A training, and it should be something like `../runs/train_stage_a/model/ckp_XXXXX.pth`

## Citation

If you find this repo useful, please consider citing our paper:
```bibtex
@article{Liu2023VeraAG,
  title={Vera: A General-Purpose Plausibility Estimation Model for Commonsense Statements},
  author={Jiacheng Liu and Wenya Wang and Dianzhuo Wang and Noah A. Smith and Yejin Choi and Hanna Hajishirzi},
  journal={ArXiv},
  year={2023},
  volume={abs/2305.03695}
}
```