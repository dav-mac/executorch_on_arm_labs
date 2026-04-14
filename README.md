# 🚀 **Get Practical with ExecuTorch on Arm Labs** 🚀

![learn_on_arm](./img/Learn%20on%20Arm_banner.png)

## Course overview
Welcome to the **ExecuTorch on Arm Practical Labs**! In these hands-on sessions, you will explore how PyTorch models can be exported and lowered to the ExecuTorch runtime for more effective, lightweight, minimalist inference at the Edge. This will cover deploying to CPUs, particularly via the XNNPACK backend, for transformer-based and CNN models, before covering deployment to other hardware backends, such as the Arm Ethos-U Neural Processing Unit (NPU), understanding the TOSA IR, use of Fixed Virtual Platforms, and use of tools such as Google's Model Explorer. This is **NOT** a substitute for [official documentation](https://docs.pytorch.org/executorch/stable/index.html), but provides an accessible entry point for those wanting to learn more about ExecuTorch. Combining theoretical understanding and practical implementation skills, these labs allow participants to get started building and deploying quickly, even for those with a limited background in Edge AI.

## Who is this for?
- These labs are designed for industry ML engineers with little or no ExecuTorch experience who want to understand how and why to deploy AI inference applications at the Edge using the ExecuTorch runtime. 
- They are also well suited for embedded engineers with basic AI and/or ML knowledge, who are interested in incorporating ML in their embedded and edge applications.
- Students who want to learn more will also find this accessible and useful. Academics, teachers, and trainers are encouraged to incorporate these resources into their teaching for free, subject to the attached EULA in `LICENSE.md`.

Those who want to build or refresh fundamentals can first complete introductory and intermediate material such as the [Intro to AI](https://www.edx.org/learn/computer-science/arm-education-introduction-to-ai) or [Optimizing Generative AI on Arm](https://www.edx.org/learn/computer-science/arm-education-ai-on-arm) course.

## What will you learn?
...
## Prerequisites
### Knowledge and skills
...
### Hardware and software
...

1) **Edge AI Inference on Arm Using the ExecuTorch Runtime + XNNPACK and Kleidi AI** - CPU Inference on Raspberry Pi 5 (Arm-powered) - PyTorch vs ExecuTorch at the Edge for Transformer-based Models
- Can be completed on Raspberry Pi, or Arm-powered MacBook / Linux device ✅

2) **Efficient Image Classification Using ExecuTorch on Raspberry Pi** - CPU Inference on Raspberry Pi 5 (Arm-powered) - MobileNetV2 CNN, Quantization, and Example Application
- Can be completed on Raspberry Pi + PiCamera, or Arm-powered MacBook / Linux device if not completing PiCamera section ✅

3) **Accelerating ExecuTorch on Arm Ethos-U Neural Processing Units** - NPU Inference on Ethos-U Fixed Virtual Platform (FVP) - Understanding TOSA, Google Model Explorer
- Can be completed on Linux device (aarch64 or x86) or Arm-powered MacBook (with extra steps required for MacBook) ✅

> Note: Regardless of hardware, all labs are executable documentation in the Jupyter Notebook style, so can be read for their educational value without running the code.




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
