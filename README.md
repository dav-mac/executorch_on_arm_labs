# 🚀 **ExecuTorch on Arm Practical Labs** 🚀

![learn_on_arm](./img/Learn%20on%20Arm_banner.png)

## Course overview
Welcome to the **ExecuTorch on Arm Practical Labs**, a series of hands-on sessions providing an accessible entry point for those wanting to learn more about ExecuTorch. Combining theoretical understanding and practical implementation skills, these labs allow participants to get started building and deploying quickly, even for those with a limited background in Edge AI. You will explore how PyTorch models can be exported and lowered to the ExecuTorch runtime for more effective, lightweight, minimalist inference at the Edge.
- Note: This is **NOT** a substitute for the [official documentation](https://docs.pytorch.org/executorch/stable/index.html) on pytorch.org

## Who is this for?
These labs are designed for industry ML engineers with little or no ExecuTorch experience who want to understand how and why to deploy AI inference applications at the Edge using the ExecuTorch runtime.  They are also well suited for embedded engineers with basic AI and/or ML knowledge, who are interested in incorporating ML in their embedded and edge applications. Students who want to learn more will also find this accessible and useful. Academics, teachers, and trainers are encouraged to incorporate these resources into their teaching for free, subject to the attached EULA in `LICENSE.md`.

**Not ready yet?** Those who want to build or refresh fundamentals can first complete introductory and intermediate material such as Arm's [Intro to AI](https://www.edx.org/learn/computer-science/arm-education-introduction-to-ai) or [Optimizing Generative AI on Arm](https://www.edx.org/learn/computer-science/arm-education-ai-on-arm) courses.

## What will you learn?
By completing these labs, you will be able to:

- Export and convert PyTorch models to the ExecuTorch runtime for efficient edge inference
- Run and benchmark transformer and CNN models on Arm CPUs using the XNNPACK backend
- Understand the trade-offs between PyTorch and ExecuTorch for edge deployment
- Apply model optimization techniques such as quantization for performance and efficiency
- Build and run real-world edge AI applications (e.g. image classification on Raspberry Pi)
- Deploy models to Arm Ethos-U NPUs using Fixed Virtual Platforms (FVPs)
- Understand the role of TOSA (Tensor Operator Set Architecture) in model lowering and portability
- Use tools such as Google Model Explorer to inspect and analyze model graphs
- Gain practical experience deploying across CPU and NPU backends in a consistent workflow

## Prerequisites
### Knowledge and skills
- Basic Python programming
- Familiarity with machine learning concepts (e.g. models, inference, tensors)
- Some exposure to Linux/command line usage
- (Recommended) Introductory experience with PyTorch is recommended but not required
- (Recommended) Basic understanding of embedded systems or edge AI concepts
### Hardware and software

> Note: Regardless of hardware, all of the labs are provided as Jupyter Notebooks and can be read for their educational value without running the code, but running them is recommended for full hands-on experience.

You can run the labs using one of the following setups:

#### Minimum requirements:

- A computer running Linux (x86 or aarch64) or macOS
- Python 3.9+
- Git installed
- Ability to install Python packages (e.g. via pip)

#### Recommended setups (for full experience):

- Raspberry Pi 5 (or other Arm-based device) for CPU-based edge inference
- PiCamera (optional, for image classification application)
- Arm-based MacBook or Linux device (aarch64) for best compatibility

#### For NPU labs:

- Linux or macOS system capable of running Arm Fixed Virtual Platforms (FVPs)
- Additional setup as described in `Lab_0_Setup.md`

## Course structure

This course consists of three hands-on labs.

### Hands-on labs
| Part                                                                                                                       | Title                                                                         | Focus                                                                      | Required Hardware  |
|----------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------|----------------------------------------------------------------------------|---|
| [Lab_1](https://github.com/dav-mac/executorch_on_arm_labs/blob/main/Lab_1_Transformer_Inference_ExecuTorch.ipynb)          | Edge AI Inference on Arm Using the ExecuTorch Runtime + XNNPACK and Kleidi AI | PU Inference on Raspberry Pi 5 (Arm-powered) - PyTorch vs ExecuTorch at the Edge for Transformer-based Models.    | Can be completed on Raspberry Pi, or Arm-powered MacBook / Linux device ✅  |
| [Lab_2](https://github.com/dav-mac/executorch_on_arm_labs/blob/main/Lab_2_Efficient_Image_Classification_ExecuTorch.ipynb) | Efficient Image Classification Using ExecuTorch on Raspberry Pi | CPU Inference on Raspberry Pi 5 (Arm-powered) - MobileNetV2 CNN, Quantization, and Example Application. | Can be completed on Raspberry Pi + PiCamera, or Arm-powered MacBook / Linux device if not completing PiCamera section ✅   |
| [Lab_3](https://github.com/dav-mac/executorch_on_arm_labs/blob/main/Lab_3_Accelerating_ExecuTorch_Ethos_NPU.ipynb)         | Accelerating ExecuTorch on Arm Ethos-U Neural Processing Units | NPU Inference on Ethos-U Fixed Virtual Platform (FVP) - Understanding TOSA, Google Model Explorer.   | Can be completed on Linux device (aarch64 or x86) or Arm-powered MacBook (with extra steps required for MacBook) ✅   |

---

## 🚀 Start here 🚀

> **New to this course? Follow these steps:**
>
> - Clone the repo with `git clone https://github.com/arm-education/executorch_on_arm_labs.git`
> - Follow the setup guide [`Lab_0_Setup.md`](https://github.com/dav-mac/executorch_on_arm_labs/blob/main/Lab_0_Setup.md) before attempting the labs.



---

# Additional notes

## Interested in contributing?

We would welcome labs for this repository that are contributed from the community - check out `CONTRIBUTING.md`.

## Special thanks
**✍️ Contributors:**
- Lab 2 was produced from original content contributed by [Professor Marcelo Rovai](https://github.com/Mjrovai) at UNIFEI University, in collaboration with Matt Cossins from Arm.

## License
You are free to fork or clone this material. See `LICENSE.md` for the complete license.

## Inclusive Language Commitment
Arm is committed to making the language we use inclusive, meaningful, and respectful. Our goal is to remove and replace non-inclusive language from our vocabulary to reflect our values and represent our global ecosystem.
 
Arm is working actively with our partners, standards bodies, and the wider ecosystem to adopt a consistent approach to the use of inclusive language and to eradicate and replace offensive terms. We recognize that this will take time. This course may contain references to non-inclusive language; it will be updated with newer terms as those terms are agreed and ratified with the wider community. 
 
Contact us at education@arm.com with questions or comments about this course. You can also report non-inclusive and offensive terminology usage in Arm content at terms@arm.com.

---
