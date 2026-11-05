---
permalink: /
title: "About me"
author_profile: true
redirect_from: 
  - /about/
  - /about.html
---

I'm a Ph.D. student in Computer and Information Science at the University of Delaware, starting in Fall 2026. I'm currently working on something involving Frama-C and MPI. I'm very excited about Frama-C, which seems to combine deductive verification and SMT. Another French technology! (developed in France, like CompCert, Rocq, and OCaml).

Past Projects
======

- **Compiling Structured Operational Semantics to Executable OCaml Code.** I added a module to the Sterling compiler developed by Dr. Dawn Michaelson. The extension translates structured operational semantics into OCaml, supporting both small-step and big-step semantics and both dynamic and static rules such as type checking. It is part of the [Modular Metatheory for Extensible Languages](https://mmel.cs.umn.edu/) project.
- **Verified compilation for a Rust-like ownership language.** I worked on a compiler for a Rust-like ownership language built on top of CompCertO, which extends CompCert, a formally verified C compiler written in Rocq. I primarily verified a pass from RustIR to Clight, a small-step intermediate language subset of C, using backward simulation. I proved theorems such as one that translates any RustIR expression into a Clight expression while maintaining an injection relation between the memory blocks of the two program states. [arXiv paper](https://arxiv.org/abs/2510.10015)

Publications
======

- [End-to-end Compositional Verification of Program Safety through Verified and Verifying Compilation](https://arxiv.org/abs/2510.10015). Jinhua Wu, Yuting Wang, Liukun Yu, **Linglong Meng**. arXiv preprint arXiv:2510.10015, 2025.

Education
======

- Ph.D. in Computer Science, University of Delaware (2026 – ∞)
- M.S. in Computer Science, University of Minnesota, Twin Cities (2024 – 2026)
- B.S. in Computer Science, Minor in Mathematics, Asian & Middle Eastern Studies, University of Minnesota, Twin Cities (2020 – 2024)

Outside of computer science, I write about Japanese and East Asian history, literature and film: see the [Humanities](/humanities/) page.
